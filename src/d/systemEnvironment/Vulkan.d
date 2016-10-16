module systemEnvironment.Vulkan;

import memory.NonGcHandle : NonGcHandle;
import systemEnvironment.EnvironmentChain;
import systemEnvironment.ChainContext;

public void platformVulkan1Libary(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	import vulkan.VulkanPlatform;
	
	initializeVulkanPointers();
	scope(exit) releaseVulkanLibrary();
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
}

import std.string : toStringz;
import core.memory : GC;
import std.stdint;
import std.format : format;

import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import vulkan.VulkanDevice;
import vulkan.VulkanTools;
import vulkan.VulkanPlatform;
import vulkan.VulkanSurface;
import vulkan.QueueManager;
import vulkan.VulkanQueueHelpers : DeviceQueueInfoHelper, QueueInfo;
static import vulkan.InitialisationHelpers;
import Exceptions : EngineException;
import TypedPointerWithLength : TypedPointerWithLength;


import helpers.Conversion : convertCStringToD;

import helpers.VariableValidator : VariableValidator;

private extern(System) VkBool32 vulkanDebugCallback(VkFlags msgFlags, VkDebugReportObjectTypeEXT objType, uint64_t srcObject, size_t location, int32_t msgCode, const char *pLayerPrefix, const char *pMsg, void *pUserData) {
	import std.stdio;
	
	writeln("vulkan debug: layerprefix=", convertCStringToD(pLayerPrefix), " message=", convertCStringToD(pMsg));
	return 1;
}

/**
 * queries all devices and creates a connection to the best device,
 * creates basic vulkan resources
 *
 */
public void platformVulkan2DeviceBase(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	VkResult vulkanResult;
	
	QueueManager queueManager = chainContext.vulkan.queueManager;
	
	bool withDebugReportExtension = true;
	
	// we enable the standard debug and validation layers
	string[] layersToLoadGced = ["VK_LAYER_LUNARG_standard_validation"];
	
	string[] extensionsToLoadGced;
	
	if( withDebugReportExtension ) {
		extensionsToLoadGced ~= VK_EXT_DEBUG_REPORT_EXTENSION_NAME;
	}
	
	const bool withSurface = true; // do we want to render to a surface?
	if( withSurface ) {
		extensionsToLoadGced ~= VK_KHR_SURFACE_EXTENSION_NAME; // required
		version(Win32) {
			extensionsToLoadGced ~= VK_KHR_WIN32_SURFACE_EXTENSION_NAME;
		}
		// TODO< linux >
	}
	
	string[] deviceExtensionsToLoadGced;
	deviceExtensionsToLoadGced ~= VK_KHR_SWAPCHAIN_EXTENSION_NAME;
	
	// TODO< see https://software.intel.com/en-us/articles/api-without-secrets-introduction-to-vulkan-part-2
	//       check for available extension  see chapter "Checking Whether an Instance Extension Is Supported"
	//       check for device extensions    see chapter "Checking Whether a Device Extension is Supported"
	// >
	
	// DESTROY THIS
	// we need it later, but we also need to refactor the code below and put it into a box>
	TypedPointerWithLength!(immutable(char)*) layersNonGced = TypedPointerWithLength!(immutable(char)*).allocate(layersToLoadGced.length);
	for( uint i = 0; i < layersNonGced.length; i++ ) {
		layersNonGced.ptr[i] = toStringz(layersToLoadGced[i]);
	}
	
	TypedPointerWithLength!(immutable(char)*) extensionsNonGced = TypedPointerWithLength!(immutable(char)*).allocate(extensionsToLoadGced.length);
	for( uint i = 0; i < extensionsNonGced.length; i++ ) {
		extensionsNonGced.ptr[i] = toStringz(extensionsToLoadGced[i]);
	}
	
	TypedPointerWithLength!(immutable(char)*) deviceExtensionsNonGced = TypedPointerWithLength!(immutable(char)*).allocate(deviceExtensionsToLoadGced.length);
	for( uint i = 0; i < deviceExtensionsNonGced.length; i++ ) {
		deviceExtensionsNonGced.ptr[i] = toStringz(deviceExtensionsToLoadGced[i]);
	}
	// END DESTROY THIS
	
	
	
	
	chainContext.vulkan.instance.invalidate();

	{
		VkInstance instance;
		vulkan.InitialisationHelpers.initializeInstance(layersToLoadGced, extensionsToLoadGced, deviceExtensionsToLoadGced, cast(const(bool))withSurface, instance);
		chainContext.vulkan.instance = instance;
	}
	scope(exit) vulkan.InitialisationHelpers.cleanupInstance(chainContext.vulkan.instance.value);
	
	
	// init remaining function pointers for debugging
	if( withDebugReportExtension ) {
		bindVulkanFunctionByInstance(cast(void**)&vkCreateDebugReportCallbackEXT, chainContext.vulkan.instance.value, "vkCreateDebugReportCallbackEXT");
		bindVulkanFunctionByInstance(cast(void**)&vkDestroyDebugReportCallbackEXT, chainContext.vulkan.instance.value, "vkDestroyDebugReportCallbackEXT");
		bindVulkanFunctionByInstance(cast(void**)&vkDebugReportMessageEXT, chainContext.vulkan.instance.value, "vkDebugReportMessageEXT");
	}
	
	// init debugging
	if( withDebugReportExtension ) {
		VkDebugReportCallbackCreateInfoEXT debugReportCallbackCreateInfoEXT;
		initDebugReportCallbackCreateInfoEXT(&debugReportCallbackCreateInfoEXT);
		debugReportCallbackCreateInfoEXT.pfnCallback = &vulkanDebugCallback;
		debugReportCallbackCreateInfoEXT.flags = VK_DEBUG_REPORT_ERROR_BIT_EXT | VK_DEBUG_REPORT_WARNING_BIT_EXT; // enable me | VK_DEBUG_REPORT_INFORMATION_BIT_EXT | VK_DEBUG_REPORT_PERFORMANCE_WARNING_BIT_EXT;
	
		VkDebugReportCallbackEXT debugReportCallback;
		vulkanResult = vkCreateDebugReportCallbackEXT( chainContext.vulkan.instance.value, cast(const(VkDebugReportCallbackCreateInfoEXT)*)&debugReportCallbackCreateInfoEXT, null, &debugReportCallback );
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "vkCreateDebugReportCallbackEXT failed!");
		}
	}
	
	scope(exit) {
		if( withDebugReportExtension ) {
			// TODO< debug cleanup >
		}
	}
	
	
	VulkanDevice[] vulkanDevices = vulkan.InitialisationHelpers.enumerateAllPossibleDevices(chainContext.vulkan.instance.value);
	
	import common.IPipe;
	chainContext.loggerPipe.write(IPipe.EnumLevel.INFO, "", format("i have %s vulkan devices", vulkanDevices.length), "vulkan");
	
	// now we filter for the devices with at least n queue of the given type


	/* TODO
	final uint minimumNumberOfComputeQueues = 2;

	foreach( VulkanDevice currentDevice; vulkanDevices ) {
		// TODO< check for required properties of the queues >
		deviceIterator.queueFamilyProperties
	}
	*/
	
	// HACK
	// for now we just add all devices to possibleDevices
	VulkanDevice[] possibleDevices;
	foreach( VulkanDevice currentDevice; vulkanDevices ) {
		possibleDevices ~= currentDevice;
	}

	if( possibleDevices.length == 0 ) {
		throw new EngineException(true, true, "Could not find a vulkan device with the required properties!");
	}

	// now we select the best device
	// HACK
	// < we select the first device >
	chainContext.vulkan.chosenDevice = possibleDevices[0];


	// query memory
	chainContext.vulkan.chosenDevice.physicalDeviceMemoryProperties = cast(VkPhysicalDeviceMemoryProperties*)GC.malloc(VkPhysicalDeviceMemoryProperties.sizeof, GC.BlkAttr.NO_MOVE | GC.BlkAttr.NO_SCAN);
	vkGetPhysicalDeviceMemoryProperties(chainContext.vulkan.chosenDevice.physicalDevice, chainContext.vulkan.chosenDevice.physicalDeviceMemoryProperties);
	
	// create surface
	chainContext.vulkan.surface = new VulkanSurface();
	version(Win32) {
		vulkanResult = chainContext.vulkan.surface.createSurface(chainContext.vulkan.instance, chainContext.windowsContext.hInstance, chainContext.windowsContext.hwnd);
	}
	
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "Couldn't create Surface!");
	}
	
	scope(exit) chainContext.vulkan.surface.destroySurface(chainContext.vulkan.instance);






	// first we figure out the queue families for the graphics and compute queue for the 
	// TODO ASK< is the graphics queue really necessary here or just refactor the queue to get the presentation queue and check later against
	//           the primary and secondary queue for graphics and compute? >
	//uint32_t graphicsQueueFamilyIndex = UINT32_MAX;
	//uint32_t presentQueueFamilyIndex  = UINT32_MAX;
	
	
	QueueInfo primaryQueue;
	QueueInfo secondaryQueue;
	QueueInfo presentQueue;
	
    primaryQueue = new QueueInfo();
    presentQueue = new QueueInfo();
	{
		ExtendedQueueFamilyProperty[] requestedQueueFamilyProperties;
		QueryQueueResult[] queryQueueResult;
		
		VariableValidator!VkPhysicalDevice physicalDevice;
		physicalDevice = chainContext.vulkan.chosenDevice.physicalDevice;
		
		ExtendedQueueFamilyProperty[] availableQueueFamilyProperties = getSupportPresentForAllQueueFamiliesAndQueueInfo(physicalDevice, chainContext.vulkan.surface.surface);
		
		ExtendedQueueFamilyProperty queueFamilyPropertyForGraphicsAndComputeAndPresentation = new ExtendedQueueFamilyProperty(true, false, false, true);
		ExtendedQueueFamilyProperty queueFamilyPropertyForGraphicsAndPresentation = new ExtendedQueueFamilyProperty(true, false, false, true);
		
		requestedQueueFamilyProperties.length = 0;
		// try to find a queue family which can do graphics, present and compute capability
		requestedQueueFamilyProperties ~= queueFamilyPropertyForGraphicsAndComputeAndPresentation;
		// followed by a queue which can do only graphics and presentation
		requestedQueueFamilyProperties ~= queueFamilyPropertyForGraphicsAndPresentation;
		
		queryQueueResult = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
		
		if( queryQueueResult.length == 0 ) {
			// TODO< it could be the case that we need a extra present queue >
			
	    	throw new EngineException(true, true, "Couldn't find a suitable queue for graphics and presentation!");
	    }
		
		// the best queue is the first result
		primaryQueue.queueFamilyIndex = presentQueue.queueFamilyIndex = queryQueueResult[0].queueFamilyIndex;
		primaryQueue.queueFamilyProperty = presentQueue.queueFamilyProperty = queryQueueResult[0].requiredProperties;
		
		
		// now we try to find the secondary queue, it has only to offer graphics and compute
		
		ExtendedQueueFamilyProperty queueFamilyPropertyForGraphicsAndCompute = new ExtendedQueueFamilyProperty(true, false, false, false);
		requestedQueueFamilyProperties.length = 0;
		requestedQueueFamilyProperties ~= queueFamilyPropertyForGraphicsAndCompute;
		
		queryQueueResult = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
		
		if( queryQueueResult.length == 0 ) {
			throw new EngineException(true, true, "Couldn't find a suitable queue for graphics and compute!");
	    }
		
		secondaryQueue = new QueueInfo();
		secondaryQueue.queueFamilyIndex = queryQueueResult[0].queueFamilyIndex;
		secondaryQueue.queueFamilyProperty = queryQueueResult[0].requiredProperties;
		
		
		/*
		
		// the best queue would be one with both graphics and present capabilities
		ExtendedQueueFamilyProperty queueFamilyPropertyForGraphicsAndPresentation = new ExtendedQueueFamilyProperty(true, false, false, true);
		
		ExtendedQueueFamilyProperty[] requestedQueueFamilyProperties;
		requestedQueueFamilyProperties ~= queueFamilyPropertyForGraphicsAndPresentation;
		
		// if the is not available, we choose seperate queues
		requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty(false, false, false, true);
		requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty(true, false, false, false);
		
		QueryQueueResult[] queryQueueResult = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
		
		
	    
	    if( queryQueueResult.length == 0 ) {
	    	throw new EngineException(true, true, "Couldn't find a suitable queue for graphics and presentation");
	    }
	    
	    if( queryQueueResult[0].requiredProperties.isEqual(queueFamilyPropertyForGraphicsAndPresentation) ) {
	    	graphicsQueueFamilyIndex = queryQueueResult[0].queueFamilyIndex;
	    	presentQueueFamilyIndex = queryQueueResult[0].queueFamilyIndex;
	    }
	    else {
	    	foreach( QueryQueueResult iterationQueryQueueResult; queryQueueResult ) {
	    		if( iterationQueryQueueResult.requiredProperties.isEqual(new ExtendedQueueFamilyProperty(false, false, false, true)) ) {
	    			presentQueueFamilyIndex = iterationQueryQueueResult.queueFamilyIndex;
	    		}
	    		else if( iterationQueryQueueResult.requiredProperties.isEqual(new ExtendedQueueFamilyProperty(true, false, false, false)) ) {
	    			graphicsQueueFamilyIndex = iterationQueryQueueResult.queueFamilyIndex;
	    		}
	    	}
	    }
		
	    // Generate error if could not find both a graphics and a present queue
	    if (graphicsQueueFamilyIndex == UINT32_MAX || presentQueueFamilyIndex == UINT32_MAX) {
	        throw new EngineException(true, true, "Could not find a graphics and a present queue");
	    }
	    */
	    
	    // log
	    chainContext.loggerPipe.write(IPipe.EnumLevel.INFO, "", format("primary queue family index is %s", primaryQueue.queueFamilyIndex), "vulkan");
	    chainContext.loggerPipe.write(IPipe.EnumLevel.INFO, "", format("present queue family index is %s", presentQueue.queueFamilyIndex), "vulkan");
	    chainContext.loggerPipe.write(IPipe.EnumLevel.INFO, "", format("secondary queue family index is %s", secondaryQueue.queueFamilyIndex), "vulkan");
	}
    
    
	/*
	
	// choose queue family for primary and maybe secondary queues
	
	// possible because later we try to fit the presentation, primary and maybe secondary queues into the available resources
	uint32_t possibleComputeQueueFamilyIndex;
	uint32_t possibleGraphicsQueueFamilyIndex;
	{
		ExtendedQueueFamilyProperty[] availableQueueFamilyProperties;
		ExtendedQueueFamilyProperty queueFamilyPropertyForGraphicAndCompute = new ExtendedQueueFamilyProperty(true, true, false, false);
		
		requestedQueueFamilyProperties.length = 0;
		requestedQueueFamilyProperties ~= queueFamilyPropertyForGraphicAndCompute;
		queryQueueResult = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
		if( queryQueueResult.length == 1 ) {
			possibleComputeQueueFamilyIndex = queryQueueResult[0].queueFamilyIndex;
	    	possibleGraphicsQueueFamilyIndex = queryQueueResult[0].queueFamilyIndex;
		}
		else {
			requestedQueueFamilyProperties.length = 0;
			requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty(true, false, false, false);
			requestedQueueFamilyProperties ~= new ExtendedQueueFamilyProperty(false, true, false, false);
			queryQueueResult = queryPossibleQueueFamilies(availableQueueFamilyProperties, requestedQueueFamilyProperties);
			if( queryQueueResult.length != 2 ) {
				throw new EngineException(true, true, "Could not find a graphics and a present queue");
			}
			
			possibleGraphicsQueueFamilyIndex = queryQueueResult[0].queueFamilyIndex;
			possibleComputeQueueFamilyIndex = queryQueueResult[1].queueFamilyIndex;
		}
	
		// log
	    chainContext.loggerPipe.write(IPipe.EnumLevel.INFO, "", format("possible graphics queue family index is %s", possibleGraphicsQueueFamilyIndex), "vulkan");
	    chainContext.loggerPipe.write(IPipe.EnumLevel.INFO, "", format("possible present queue family index is %s", possibleComputeQueueFamilyIndex), "vulkan");
	}
	*/





	/// TODO< fit the queue families from the steps above into the queue budget of the device >
	//BEGIN TO REFACTOR
	
	
	
	

	// create device	
	VkPhysicalDeviceFeatures physicalDeviceFeatures;
	initPhysicalDeviceFeatures(&physicalDeviceFeatures);
	
	primaryQueue.priority = 1.0f;
	presentQueue.priority = 1.0f;
	secondaryQueue.priority = 0.3f;
	
	uint[string] queueIndexByName;
	
	QueueInfo[] uniqueQueues;
	
	size_t primaryQueueIndex = uniqueQueues.length;
	queueIndexByName["primary"] = uniqueQueues.length;
	queueIndexByName["graphics"] = uniqueQueues.length; // graphics queue is the primary queue
	uniqueQueues ~= primaryQueue;
	
	if( primaryQueue !is presentQueue ) {
		uniqueQueues ~= presentQueue;
	}
	
	// if there is a present queue which is not the primary queue then we have to set it to the length
	if( primaryQueue !is presentQueue ) {
		queueIndexByName["present"] = uniqueQueues.length - 1;
	}
	else {
		queueIndexByName["present"] = primaryQueueIndex;
	}
	
	queueIndexByName["secondary"] = uniqueQueues.length;
	uniqueQueues ~= secondaryQueue;
	
	
	

	
	
	
	
	DeviceQueueInfoHelper.DeviceQueueInfoAndIndexType[] queueDeviceQueueInfoAndQueueIndices;
	queueManager.queueInfos = DeviceQueueInfoHelper.createQueueInfoForQueues(uniqueQueues, queueDeviceQueueInfoAndQueueIndices);
	queueManager.addQueueByName("primary", queueDeviceQueueInfoAndQueueIndices[queueIndexByName["primary"]][0], queueDeviceQueueInfoAndQueueIndices[queueIndexByName["primary"]][1]);
	queueManager.addQueueByName("secondary", queueDeviceQueueInfoAndQueueIndices[queueIndexByName["secondary"]][0], queueDeviceQueueInfoAndQueueIndices[queueIndexByName["secondary"]][1]);
	queueManager.addQueueByName("present", queueDeviceQueueInfoAndQueueIndices[queueIndexByName["present"]][0], queueDeviceQueueInfoAndQueueIndices[queueIndexByName["present"]][1]);
	queueManager.addQueueByName("graphics", queueDeviceQueueInfoAndQueueIndices[queueIndexByName["graphics"]][0], queueDeviceQueueInfoAndQueueIndices[queueIndexByName["graphics"]][1]);
	
	
	VkDeviceQueueCreateInfo[] queueCreateInfoArray = DeviceQueueInfoHelper.translateDeviceQueueCreateInfoHelperToVk(queueManager.queueInfos);
	
	VkDeviceCreateInfo deviceCreateInfo;
	initDeviceCreateInfo(&deviceCreateInfo);
	deviceCreateInfo.queueCreateInfoCount = queueCreateInfoArray.length;
	deviceCreateInfo.pQueueCreateInfos = cast(immutable(VkDeviceQueueCreateInfo)*)queueCreateInfoArray.ptr;

	// we enable the standard debug and validation layers
	deviceCreateInfo.enabledLayerCount = cast(uint32_t)layersNonGced.length;
	deviceCreateInfo.ppEnabledLayerNames = layersNonGced.ptr;
	
	deviceCreateInfo.enabledExtensionCount = cast(uint32_t)deviceExtensionsNonGced.length;
	deviceCreateInfo.ppEnabledExtensionNames = deviceExtensionsNonGced.ptr;

	deviceCreateInfo.pEnabledFeatures = cast(immutable(VkPhysicalDeviceFeatures)*)&physicalDeviceFeatures;

	vulkanResult = vkCreateDevice(chainContext.vulkan.chosenDevice.physicalDevice, &deviceCreateInfo, null, &chainContext.vulkan.chosenDevice.logicalDevice);
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "Couldn't create vulkan device!");
	}
	scope(exit) vkDestroyDevice(chainContext.vulkan.chosenDevice.logicalDevice, null);


	
	// retrive queues
	{
		foreach( iterationDeviceQueueInfoHelper; queueManager.queueInfos ) {
			iterationDeviceQueueInfoHelper.queues.length = iterationDeviceQueueInfoHelper.count;
			
			foreach( queueIndex; 0..iterationDeviceQueueInfoHelper.count ) {
				vkGetDeviceQueue(chainContext.vulkan.chosenDevice.logicalDevice, iterationDeviceQueueInfoHelper.queueFamilyIndex, queueIndex, &iterationDeviceQueueInfoHelper.queues[queueIndex]);
			}
		}
	}
	




	//END TO REFACTOR





























	// now we can free the array with the layers and the baked gc memory
	//layersNonGced.dispose();
	//layersNonGced = null; // free memory for gc		
	layersToLoadGced.length = 0; // release GC memory
	
	//extensionsNonGced.dispose();
	//extensionsNonGced = null; // free memory for gc		
	extensionsToLoadGced.length = 0; // release GC memory
	
	//deviceExtensionsNonGced.dispose();
	//deviceExtensionsNonGced = null; // free memory for gc		
	deviceExtensionsToLoadGced.length = 0; // release GC memory
	
	





	// create command pools
	foreach( iterationQueueName; chainContext.vulkan.queueManager.queueNames ) {
		uint32_t queueFamilyIndex = chainContext.vulkan.queueManager.getDeviceQueueInfoByName(iterationQueueName).queueFamilyIndex;

		VkCommandPoolCreateInfo commandPoolCreateInfo;
		initCommandPoolCreateInfo(&commandPoolCreateInfo);
		commandPoolCreateInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
		commandPoolCreateInfo.queueFamilyIndex = queueFamilyIndex;
		
		VkCommandPool cmdPool;
		vulkanResult = vkCreateCommandPool(
			chainContext.vulkan.chosenDevice.logicalDevice,
			&commandPoolCreateInfo,
			null,
			&cmdPool
		);
	
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create command pool!");
		}
		
		chainContext.vulkan.commandPoolsByQueueName[iterationQueueName] = VariableValidator!VkCommandPool();
		chainContext.vulkan.commandPoolsByQueueName[iterationQueueName] = cmdPool;
	}
	
	scope(exit) {
		foreach( iterationQueueName; chainContext.vulkan.queueManager.queueNames ) {
			VkCommandPool cmdPool = chainContext.vulkan.commandPoolsByQueueName[iterationQueueName].value;
			vkDestroyCommandPool(chainContext.vulkan.chosenDevice.logicalDevice, cmdPool, null);
		}
	}




	// create command buffer
	// we later can create n command buffers and fill them in different threads

	VkCommandBuffer primaryCommandBuffer;
	
	VkCommandBufferAllocateInfo commandBufferAllocationInfo;
	initCommandBufferAllocateInfo(&commandBufferAllocationInfo);
	commandBufferAllocationInfo.commandPool = chainContext.vulkan.commandPoolsByQueueName["primary"].value;
	commandBufferAllocationInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
	commandBufferAllocationInfo.commandBufferCount = 1; // we just want to allocate one command buffer in the target array

	// SYNC : this needs to be host synced with a mutex
	vulkanResult = vkAllocateCommandBuffers(
		chainContext.vulkan.chosenDevice.logicalDevice,
		&commandBufferAllocationInfo,
		&primaryCommandBuffer);
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, vulkan.Messages.COULDNT_COMMAND_BUFFER);
	}
	scope(exit) vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.commandPoolsByQueueName["primary"].value, 1, &primaryCommandBuffer);


	// find best formats
	{
		VkFormat[] preferedMediumPrecisionFormats = [VK_FORMAT_D24_UNORM_S8_UINT, VK_FORMAT_D16_UNORM_S8_UINT, VK_FORMAT_D16_UNORM];
		chainContext.vulkan.depthFormatMediumPrecision = vulkanHelperFindBestFormatTryThrows(chainContext.vulkan.chosenDevice.physicalDevice, preferedMediumPrecisionFormats, VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT, "depthFormatMediumPrecision");

		VkFormat[] preferedHighPrecisionFormats = [VK_FORMAT_D32_SFLOAT_S8_UINT, VK_FORMAT_D32_SFLOAT];
		chainContext.vulkan.depthFormatHighPrecision = vulkanHelperFindBestFormatTryThrows(chainContext.vulkan.chosenDevice.physicalDevice, preferedHighPrecisionFormats, VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT, "depthFormatHighPrecision");
	}
	
	
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
	
	// before (out of scope triggered) destruction of vulkan resources we have to ensure that the decive idles
    vkDeviceWaitIdle(chainContext.vulkan.chosenDevice.logicalDevice);
}

static import vulkan.Messages;


import vulkan.VulkanSwapChain2 : VulkanSwapChain2;

public void platformVulkan3SwapChain(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	VkResult vulkanResult;
	
	chainContext.vulkan.swapChain = new VulkanSwapChain2();

	chainContext.vulkan.swapChain.connect(chainContext.vulkan.instance.value, chainContext.vulkan.chosenDevice.physicalDevice, chainContext.vulkan.chosenDevice.logicalDevice);
	
	VulkanSwapChain2.InitSwapChainArguments swapchainArgument = VulkanSwapChain2.InitSwapChainArguments.init;
	swapchainArgument.imageUsageBits = VK_IMAGE_USAGE_TRANSFER_DST_BIT; // required for render to image(texture) and copy/blit to swapchain images
	swapchainArgument.loggerPipe = chainContext.loggerPipe;
	swapchainArgument.surface = chainContext.vulkan.surface.surface;
	
	version(Win32) {
		chainContext.vulkan.swapChain.initSwapchain(swapchainArgument);
	}
	
	scope(exit) {
		chainContext.vulkan.swapChain.shutdown();
	}
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
	
	// before (out of scope triggered) destruction of vulkan resources we have to ensure that the decive idles
    vkDeviceWaitIdle(chainContext.vulkan.chosenDevice.logicalDevice);
}

public void platformVulkanTestSwapChain(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	VkResult vulkanResult;
		
	VkCommandBuffer[] cmdBuffers;
	VkImageView[] views;
	
    // Construct command buffers rendering to the presentable images
    cmdBuffers.length = chainContext.vulkan.swapChain.swapchainImages.length;
    views.length = chainContext.vulkan.swapChain.swapchainImages.length;
    
    
	// Allow a maximum of two outstanding presentation operations.
    const int FRAME_LAG = 2;
    
    VkFence[] fences;
	bool[] fencesInited;
	
	fences.length = FRAME_LAG;
	fencesInited.length = FRAME_LAG;
	
	int frameIdx = 0;
	int imageIdx = 0;
	int waitFrame;
	
	void createFences(VkDevice device, out VkFence[] fences) {
		VkFenceCreateInfo fenceCreateInfo;
		initFenceCreateInfo(&fenceCreateInfo);
		fenceCreateInfo.flags = 0;
		
		for( uint i = 0; i < fences.length; i++ ) {
    		vulkanResult = vkCreateFence(
				device,
				&fenceCreateInfo,
				null,
				&fences[i]);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't create fences!");
			}
		}
	}

	createFences(chainContext.vulkan.chosenDevice.logicalDevice, fences);
	
	scope(exit) {
		// TODO< free fences >
	}

	
    // create command buffers
    for (size_t i = 0; i < chainContext.vulkan.swapChain.swapchainImages.length; ++i) {
		VkCommandBufferAllocateInfo commandBufferAllocationInfo;
		initCommandBufferAllocateInfo(&commandBufferAllocationInfo);
		with( commandBufferAllocationInfo ) {
			level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
			commandBufferCount = 1; // we just want to allocate one command buffer in the target array
		}
		commandBufferAllocationInfo.commandPool = chainContext.vulkan.commandPoolsByQueueName["primary"].value;
		
		// SYNC : this needs to be host synced with a mutex
		vulkanResult = vkAllocateCommandBuffers(
			chainContext.vulkan.chosenDevice.logicalDevice,
			&commandBufferAllocationInfo,
			&cmdBuffers[i]
		);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, vulkan.Messages.COULDNT_COMMAND_BUFFER);
		}
    }
    
    scope(exit) {
		// TODO< free command buffers >
	}
    
    // see hack #0000
    {
    	VkFenceCreateInfo fenceCreateInfo;
		initFenceCreateInfo(&fenceCreateInfo);
		fenceCreateInfo.flags = 0;
		
		vulkanResult = vkCreateFence(
			chainContext.vulkan.chosenDevice.logicalDevice,
			&fenceCreateInfo,
			null,
			&chainContext.vulkan.swapChain.context.additionalFence);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create fences!");
		}
	
    }
    
	
    for (size_t i = 0; i < chainContext.vulkan.swapChain.swapchainImages.length; ++i) {
        const VkImageViewCreateInfo viewInfo = {
            VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,          // sType
            null,                                              // pNext
            0,                                                 // flags
            chainContext.vulkan.swapChain.swapchainImages[i],  // image
            VK_IMAGE_VIEW_TYPE_2D,                             // viewType
            chainContext.vulkan.swapChain.swapchainFormat,     // format
            {VK_COMPONENT_SWIZZLE_R, VK_COMPONENT_SWIZZLE_G, VK_COMPONENT_SWIZZLE_B, VK_COMPONENT_SWIZZLE_A}, // components
            {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1}            // subresourceRange
        };
        vulkanResult = vkCreateImageView(chainContext.vulkan.chosenDevice.logicalDevice, &viewInfo, null, &views[i]);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create imageview [vkCreateImageView]!");
		}

        
        // from https://software.intel.com/en-us/articles/api-without-secrets-introduction-to-vulkan-part-2
        // license: copyleft
        // section: "Recording Command Buffers"
        
        VkCommandBufferBeginInfo cmd_buffer_begin_info = {
			VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO, // sType
			null, // pNext
			VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT, // flags
			null // pInheritanceInfo
		};

        
        VkImageSubresourceRange image_subresource_range = {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 };
        
        VkClearColorValue clear_color;
        clear_color.float32 = [1.0f, 0.8f, 0.4f, 0.0f];
        
        // TODO< multi queue syncronisation if queues are different as described in
        //       https://software.intel.com/en-us/articles/api-without-secrets-introduction-to-vulkan-part-2
        //       chapter "Image Presentation" (or around there)
        // >
        
        // NOTE< not 100% sure if this is right for multiple queues, test on hardware where the queues are different ones > 
        uint32_t presentQueueFamilyIndex = chainContext.vulkan.queueManager.getDeviceQueueInfoByName("present").queueFamilyIndex;
        uint32_t primaryQueueFamilyIndex = chainContext.vulkan.queueManager.getDeviceQueueInfoByName("primary").queueFamilyIndex;
        
        
        VkImageMemoryBarrier barrier_from_present_to_clear;
        with (barrier_from_present_to_clear) {
        	sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
	        pNext = null;
	        srcAccessMask = 0; // must be null because layout is undefined
		    dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
	        oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
	        newLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
	        srcQueueFamilyIndex = primaryQueueFamilyIndex;
	        dstQueueFamilyIndex = presentQueueFamilyIndex;
	        image = chainContext.vulkan.swapChain.swapchainImages[i];
	        subresourceRange = image_subresource_range;
        }
        
        VkImageMemoryBarrier barrier_from_clear_to_present;
        with (barrier_from_clear_to_present) {
			sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
	        pNext = null;
	        srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
	        dstAccessMask = VK_ACCESS_MEMORY_READ_BIT;
	        oldLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
	        newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
	        srcQueueFamilyIndex = presentQueueFamilyIndex;
	        dstQueueFamilyIndex = primaryQueueFamilyIndex;
		    image = chainContext.vulkan.swapChain.swapchainImages[i];
		    subresourceRange = image_subresource_range;	
	    }
 
		vkBeginCommandBuffer(cmdBuffers[i], &cmd_buffer_begin_info );
		vkCmdPipelineBarrier(cmdBuffers[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT, 0, 0, null, 0, null, 1, &barrier_from_present_to_clear);
		vkCmdClearColorImage(cmdBuffers[i], chainContext.vulkan.swapChain.swapchainImages[i], VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, &clear_color, 1, &image_subresource_range);
		vkCmdPipelineBarrier(cmdBuffers[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0, 0, null, 0, null, 1, &barrier_from_clear_to_present);
		
		vulkanResult = vkEndCommandBuffer(cmdBuffers[i]);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't end command buffer [vkEndCommandBuffer]!");
		}
    }
	
	// we need a pair of semaphores for each image we display
	chainContext.vulkan.swapChain.semaphorePairs.length = chainContext.vulkan.swapChain.desiredNumberOfSwapchainImages;
	
    const VkSemaphoreCreateInfo semaphoreCreateInfo = {
        VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,    // sType
        null,                                       // pNext
        0                                           // flags
    };
	
	foreach( i; 0..chainContext.vulkan.swapChain.semaphorePairs.length ) {
		VkResult vulkanResults[3];
		
		vulkanResults[0] = vkCreateSemaphore(chainContext.vulkan.chosenDevice.logicalDevice,
                      &semaphoreCreateInfo, null,
                      &chainContext.vulkan.swapChain.semaphorePairs[i].imageAcquiredSemaphore);
    	
    	vulkanResults[1] = vkCreateSemaphore(chainContext.vulkan.chosenDevice.logicalDevice,
                      &semaphoreCreateInfo, null,
                      &chainContext.vulkan.swapChain.semaphorePairs[i].chainSemaphore);
    	
    	vulkanResults[2] = vkCreateSemaphore(chainContext.vulkan.chosenDevice.logicalDevice,
                      &semaphoreCreateInfo, null,
                      &chainContext.vulkan.swapChain.semaphorePairs[i].renderingCompleteSemaphore);
	    
	    if( !vulkanSuccess(vulkanResults[0]) || !vulkanSuccess(vulkanResults[1]) || !vulkanSuccess(vulkanResults[2]) ) {
			throw new EngineException(true, true, "Couldn't create semaphore [vkCreateSemaphore]!");		    	
	    }
	}
	
	scope(exit) {
		// TODO< free semaphore pairs >
	}
	
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);


    
    // before (out of scope triggered) destruction of vulkan resources we have to ensure that the decive idles
    vkDeviceWaitIdle(chainContext.vulkan.chosenDevice.logicalDevice);
}
