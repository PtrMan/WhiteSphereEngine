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
	
	
	
	
	chainContext.vulkan.instance = NonGcHandle!VkInstance.createNotInitialized();
	scope(exit) chainContext.vulkan.instance.dispose();
	
	{
		VkInstance instance;
		vulkan.InitialisationHelpers.initializeInstance(layersToLoadGced, extensionsToLoadGced, deviceExtensionsToLoadGced, cast(const(bool))withSurface, instance);
		chainContext.vulkan.instance.value = instance;
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
		
		
		VariableValidator!VkSurfaceKHR surface;
		surface.invalidate();
		
		VariableValidator!VkPhysicalDevice physicalDevice;
		physicalDevice = chainContext.vulkan.chosenDevice.physicalDevice;
		
		// NOTE< this asserts because the surface is not set!, this is fine because we don't want to run this code >
		ExtendedQueueFamilyProperty[] availableQueueFamilyProperties = getSupportPresentForAllQueueFamiliesAndQueueInfo(physicalDevice, surface);
		
		
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
	
	QueueInfo[] uniqueQueues;
	uniqueQueues ~= primaryQueue;
	if( primaryQueue !is presentQueue ) {
		uniqueQueues ~= presentQueue;
	}
	uniqueQueues ~= secondaryQueue;
	
	
	

	
	
	
	
	
	
	DeviceQueueInfoHelper[] queueInfoHelpers = DeviceQueueInfoHelper.createQueueInfoForQueues(uniqueQueues);
	VkDeviceQueueCreateInfo[] queueCreateInfoArray = DeviceQueueInfoHelper.translateDeviceQueueCreateInfoHelperToVk(queueInfoHelpers);
	
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
		foreach( iterationDeviceQueueInfoHelper; queueInfoHelpers ) {
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
	
	





	// create command pool
	// TODO LOW< rename >
	chainContext.vulkan.cmdPool = NonGcHandle!VkCommandPool.createNotInitialized();
	
	uint32_t queueFamilyIndex = 0; // HACK< TODO< lookup index > >

	VkCommandPoolCreateInfo commandPoolCreateInfo;
	initCommandPoolCreateInfo(&commandPoolCreateInfo);
	commandPoolCreateInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
	commandPoolCreateInfo.queueFamilyIndex = queueFamilyIndex;

	vulkanResult = vkCreateCommandPool(
		chainContext.vulkan.chosenDevice.logicalDevice,
		&commandPoolCreateInfo,
		null,
		chainContext.vulkan.cmdPool.ptr
	);
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "Couldn't create command pool!");
	}
	scope(exit) vkDestroyCommandPool(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, null);




	// create command buffer
	// we later can create n command buffers and fill them in different threads

	VkCommandBuffer primaryCommandBuffer;
	
	VkCommandBufferAllocateInfo commandBufferAllocationInfo;
	initCommandBufferAllocateInfo(&commandBufferAllocationInfo);
	commandBufferAllocationInfo.commandPool = chainContext.vulkan.cmdPool.value;
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
	scope(exit) vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, 1, &primaryCommandBuffer);


	chainContext.vulkan.depthFormatMediumPrecision = NonGcHandle!VkFormat.createNotInitialized();
	chainContext.vulkan.depthFormatHighPrecision = NonGcHandle!VkFormat.createNotInitialized();

	// find best formats
	{
		bool calleeSuccess;
		VkFormat[] preferedMediumPrecisionFormats = [VK_FORMAT_D24_UNORM_S8_UINT, VK_FORMAT_D16_UNORM_S8_UINT, VK_FORMAT_D16_UNORM];
		*(chainContext.vulkan.depthFormatMediumPrecision.ptr) = vulkanHelperFindBestFormatTry(chainContext.vulkan.chosenDevice.physicalDevice, preferedMediumPrecisionFormats, VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT, calleeSuccess);
		if( !calleeSuccess ) {
			throw new EngineException(true, true, "Couldn't find a format for '" ~ "depthFormatMediumPrecision" ~ "'!");
		}

		VkFormat[] preferedHighPrecisionFormats = [VK_FORMAT_D32_SFLOAT_S8_UINT, VK_FORMAT_D32_SFLOAT];
		*(chainContext.vulkan.depthFormatHighPrecision.ptr) = vulkanHelperFindBestFormatTry(chainContext.vulkan.chosenDevice.physicalDevice, preferedHighPrecisionFormats, VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT, calleeSuccess);
		if( !calleeSuccess ) {
			throw new EngineException(true, true, "Couldn't find a format for '" ~ "depthFormatHighPrecision" ~ "'!");
		}
	}
	
	
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
}

import vulkan.VulkanSwapChain;
static import vulkan.Messages;

/**
 * initializes and setup the swapchain
 * this is an optional step for work where the swapchain is required (such as pushing images to the screen)
 * the step can be skiped if no monitor output is required (such as offline procedural rendering)
 *
 */
public void platformVulkan3SwapChain(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	// much is
	// from https://github.com/SaschaWillems/Vulkan/blob/master/base/vulkanexamplebase.cpp
	// under MIT license
	
	VkResult vulkanResult;
	
	chainContext.vulkan.swapChain = new VulkanSwapChain();

	chainContext.vulkan.swapChain.connect(chainContext.vulkan.instance.value, chainContext.vulkan.chosenDevice.physicalDevice, chainContext.vulkan.chosenDevice.logicalDevice);
	
	version(Win32) {
		chainContext.vulkan.swapChain.initSurface(chainContext.windowsContext.hInstance, chainContext.windowsContext.hwnd);
	}
	
	// TODO< linux >
	// do most things VulkanExampleBase does 
	
	
	
	void createSetupCommandBuffer() {
		if (chainContext.vulkan.setupCmdBuffer !is null) {
			vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, 1, &chainContext.vulkan.setupCmdBuffer);
			chainContext.vulkan.setupCmdBuffer = null; // todo : check if still necessary
		}
	
		VkCommandBufferAllocateInfo cmdBufAllocateInfo;
		initCommandBufferAllocateInfo(&cmdBufAllocateInfo);
		cmdBufAllocateInfo.commandPool = chainContext.vulkan.cmdPool.value;
    	cmdBufAllocateInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
		cmdBufAllocateInfo.commandBufferCount = 1;
		
		vulkanResult = vkAllocateCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, &cmdBufAllocateInfo, &chainContext.vulkan.setupCmdBuffer);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, vulkan.Messages.COULDNT_COMMAND_BUFFER);
		}
		
		// todo : Command buffer is also started here, better put somewhere else
		// todo : Check if necessaray at all...
		VkCommandBufferBeginInfo cmdBufInfo;
		initCommandBufferBeginInfo(&cmdBufInfo);
		// todo : check null handles, flags?
	
		vulkanResult = vkBeginCommandBuffer(chainContext.vulkan.setupCmdBuffer, &cmdBufInfo);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't begin command buffer!");
		}
	}
	
	void setupSwapChain() {
		uint32_t width = chainContext.window.width;
		uint32_t height = chainContext.window.height;
		chainContext.vulkan.swapChain.create(chainContext.vulkan.setupCmdBuffer, &width, &height);
	}
	
	void createCommandBuffers() {
		// Create one command buffer per frame buffer 
		// in the swap chain
		// Command buffers store a reference to the 
		// frame buffer inside their render pass info
		// so for static usage withouth having to rebuild 
		// them each frame, we use one per frame buffer
		assert(chainContext.vulkan.swapChain.imageCount > 0);
		chainContext.vulkan.drawCmdBuffers = TypedPointerWithLength!VkCommandBuffer.allocate(chainContext.vulkan.swapChain.imageCount);
		
		VkCommandBufferAllocateInfo cmdBufAllocateInfo;
		initCommandBufferAllocateInfo(&cmdBufAllocateInfo);
		cmdBufAllocateInfo.commandPool = chainContext.vulkan.cmdPool.value;
		cmdBufAllocateInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
		cmdBufAllocateInfo.commandBufferCount = cast(uint32_t)chainContext.vulkan.drawCmdBuffers.length;
		
		vulkanResult = vkAllocateCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, &cmdBufAllocateInfo, chainContext.vulkan.drawCmdBuffers.ptr);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't allocate command buffer!");
		}
	
		// Create one command buffer for submitting the
		// post present image memory barrier
		cmdBufAllocateInfo.commandBufferCount = 1;
	
		vulkanResult = vkAllocateCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, &cmdBufAllocateInfo, &chainContext.vulkan.postPresentCmdBuffer);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't allocate command buffer!");
		}
	}
	
	
	// not necessary, we did this already
	//createCommandPool();
	//scope(exit) vkDestroyCommandPool(chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, null);

	createSetupCommandBuffer();
	scope(exit) vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, 1, &chainContext.vulkan.setupCmdBuffer);
	
	setupSwapChain();
	scope(exit) chainContext.vulkan.swapChain.cleanup();
	
	createCommandBuffers();
	scope(exit) {
		vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, 1, &chainContext.vulkan.postPresentCmdBuffer);
		vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, chainContext.vulkan.drawCmdBuffers.length, chainContext.vulkan.drawCmdBuffers.ptr);
	}
	
	// TODO< other initialisation for swapchain and vulkan api >
	
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
}




// experimental BEGIN
import vulkan.VulkanSwapChain2;

public void platformVulkan3SwapChain2(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	VkResult vulkanResult;
	
	VulkanSwapChain2 swapChain = new VulkanSwapChain2();

	// for testing
	swapChain.connect(null, null, null);
	//swapChain.connect(chainContext.vulkan.instance.value, chainContext.vulkan.chosenDevice.physicalDevice, chainContext.vulkan.chosenDevice.logicalDevice);
	
	version(Win32) {
		swapChain.initSurface(chainContext.windowsContext.hInstance, chainContext.windowsContext.hwnd);
	}
	
	
}
// experimental END




/**
 * more specific, does access the swapchain informations 
 *
 *
 */
public void platformVulkan4(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	// most
	// from https://github.com/SaschaWillems/Vulkan/blob/master/base/vulkanexamplebase.cpp
	// under MIT license
	
	VkResult vulkanResult;

	struct DepthStencil {
		VkImage image;
		VkDeviceMemory mem;
		VkImageView view;
	}
	DepthStencil depthStencil;
	
	
	
	void setupDepthStencil() {
		VkImageCreateInfo image;
		initImageCreateInfo(&image);
		image.imageType = VK_IMAGE_TYPE_2D;
		image.format = chainContext.vulkan.depthFormatMediumPrecision.value;
		image.extent.width = chainContext.window.width;
		image.extent.height = chainContext.window.height;
		image.extent.depth = 1;
		image.mipLevels = 1;
		image.arrayLayers = 1;
		image.samples = VK_SAMPLE_COUNT_1_BIT;
		image.tiling = VK_IMAGE_TILING_OPTIMAL;
		image.usage = VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT | VK_IMAGE_USAGE_TRANSFER_SRC_BIT;
		image.flags = 0;
	
		VkMemoryAllocateInfo mem_alloc;
		initMemoryAllocateInfo(&mem_alloc);
		mem_alloc.allocationSize = 0;
		mem_alloc.memoryTypeIndex = 0;
	
		VkImageViewCreateInfo depthStencilView;
		initImageViewCreateInfo(&depthStencilView);
		depthStencilView.viewType = VK_IMAGE_VIEW_TYPE_2D;
		depthStencilView.format = chainContext.vulkan.depthFormatMediumPrecision.value;
		depthStencilView.flags = 0;
		depthStencilView.subresourceRange.aspectMask = VK_IMAGE_ASPECT_DEPTH_BIT | VK_IMAGE_ASPECT_STENCIL_BIT;
		depthStencilView.subresourceRange.baseMipLevel = 0;
		depthStencilView.subresourceRange.levelCount = 1;
		depthStencilView.subresourceRange.baseArrayLayer = 0;
		depthStencilView.subresourceRange.layerCount = 1;
	
		VkMemoryRequirements memReqs;
		
		vulkanResult = vkCreateImage(chainContext.vulkan.chosenDevice.logicalDevice, &image, null, &depthStencil.image);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, vulkan.Messages.COULDNT_IMAGE);
		}
		
		vkGetImageMemoryRequirements(chainContext.vulkan.chosenDevice.logicalDevice, depthStencil.image, &memReqs);
		mem_alloc.allocationSize = memReqs.size;
		
		bool calleeSuccess;
		mem_alloc.memoryTypeIndex = vulkanHelperSearchBestIndexOfMemoryType(chainContext.vulkan.chosenDevice.physicalDeviceMemoryProperties, memReqs.memoryTypeBits, VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, calleeSuccess);
		if( !calleeSuccess ) {
			throw new EngineException(true, true, "Failed to find best index of memory type!");
		}
		
		vulkanResult = vkAllocateMemory(chainContext.vulkan.chosenDevice.logicalDevice, &mem_alloc, null, &depthStencil.mem);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, vulkan.Messages.COULDNT_ALLOCATE_MEMORY);
		}

	
		vulkanResult = vkBindImageMemory(chainContext.vulkan.chosenDevice.logicalDevice, depthStencil.image, depthStencil.mem, 0);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, vulkan.Messages.COULDNT_BIND_IMAGE_MEMORY);
		}

		setImageLayout(chainContext.vulkan.setupCmdBuffer, depthStencil.image, VK_IMAGE_ASPECT_DEPTH_BIT, VK_IMAGE_LAYOUT_UNDEFINED, VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL);
	
		depthStencilView.image = depthStencil.image;
		vulkanResult = vkCreateImageView(chainContext.vulkan.chosenDevice.logicalDevice, &depthStencilView, null, &depthStencil.view);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, vulkan.Messages.COULDNT_IMAGE_VIEW);
		}
	}
	
	
	void createRenderpass() {
		
		VkFormat colorformat = VK_FORMAT_B8G8R8A8_UNORM;

		VkAttachmentDescription[2] attachments;
		attachments[0].format = colorformat;
		attachments[0].samples = VK_SAMPLE_COUNT_1_BIT;
		attachments[0].loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
		attachments[0].storeOp = VK_ATTACHMENT_STORE_OP_STORE;
		attachments[0].stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
		attachments[0].stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
		attachments[0].initialLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
		attachments[0].finalLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

		attachments[1].format = chainContext.vulkan.depthFormatMediumPrecision.value;
		attachments[1].samples = VK_SAMPLE_COUNT_1_BIT;
		attachments[1].loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
		attachments[1].storeOp = VK_ATTACHMENT_STORE_OP_STORE;
		attachments[1].stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
		attachments[1].stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
		attachments[1].initialLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
		attachments[1].finalLayout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

		VkAttachmentReference colorReference;
		colorReference.attachment = 0;
		colorReference.layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

		VkAttachmentReference depthReference;
		depthReference.attachment = 1;
		depthReference.layout = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

		VkSubpassDescription subpass;
		subpass.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS; // only this is possible in vulkan 1.0.2
		subpass.flags = 0;
		subpass.inputAttachmentCount = 0;
		subpass.pInputAttachments = null;
		subpass.colorAttachmentCount = 1;
		subpass.pColorAttachments = cast(immutable(VkAttachmentReference)*)&colorReference;
		subpass.pResolveAttachments = null;
		subpass.pDepthStencilAttachment = cast(immutable(VkAttachmentReference)*)&depthReference;
		subpass.preserveAttachmentCount = 0;
		subpass.pPreserveAttachments = null;

		VkRenderPassCreateInfo renderPassCreateInfo;
		initRenderPassCreateInfo(&renderPassCreateInfo);
		renderPassCreateInfo.attachmentCount = 2;
		renderPassCreateInfo.pAttachments = cast(immutable(VkAttachmentDescription)*)&attachments;
		renderPassCreateInfo.subpassCount = 1;
		renderPassCreateInfo.pSubpasses = cast(immutable(VkSubpassDescription)*)&subpass;
		renderPassCreateInfo.dependencyCount = 0;
		renderPassCreateInfo.pDependencies = cast(immutable(VkSubpassDependency)*)null;

		vulkanResult = vkCreateRenderPass(chainContext.vulkan.chosenDevice.logicalDevice, &renderPassCreateInfo, null, &chainContext.vulkan.renderPass);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create renderpass!");
		}
	}
	
	void setupFrameBuffer() {
		VkImageView[2] attachments;
	
		// Depth/Stencil attachment is the same for all frame buffers
		attachments[1] = depthStencil.view;
	
		VkFramebufferCreateInfo frameBufferCreateInfo;
		initFramebufferCreateInfo(&frameBufferCreateInfo);
		frameBufferCreateInfo.renderPass = chainContext.vulkan.renderPass;
		frameBufferCreateInfo.attachmentCount = 2;
		frameBufferCreateInfo.pAttachments = cast(immutable(VkImageView)*)attachments.ptr; // TODO< cleanup >
		frameBufferCreateInfo.width = chainContext.window.width;
		frameBufferCreateInfo.height = chainContext.window.height;
		frameBufferCreateInfo.layers = 1;
	
		// Create frame buffers for every swap chain image
		chainContext.vulkan.frameBuffers = TypedPointerWithLength!VkFramebuffer.allocate(chainContext.vulkan.swapChain.imageCount);
		for (uint32_t i = 0; i < chainContext.vulkan.frameBuffers.length; i++) {
			attachments[0] = chainContext.vulkan.swapChain.buffers.ptr[i].view;
			vulkanResult = vkCreateFramebuffer(chainContext.vulkan.chosenDevice.logicalDevice, &frameBufferCreateInfo, null, &chainContext.vulkan.frameBuffers.ptr[i]);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't create framebuffer!");
			}
		}
	}
	
	void flushSetupCommandBuffer() {
		if (chainContext.vulkan.setupCmdBuffer is null)
			return;
	
		vulkanSuccess = vkEndCommandBuffer(chainContext.vulkan.setupCmdBuffer);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't end command buffer!");
		}

	
		VkSubmitInfo submitInfo;
		submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
		submitInfo.commandBufferCount = 1;
		submitInfo.pCommandBuffers = cast(immutable(VkCommandBuffer)*)&chainContext.vulkan.setupCmdBuffer;
	
		vulkanSuccess = vkQueueSubmit(chainContext.vulkan.highPriorityQueue, 1, &submitInfo, 0);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't submi to queue!");
		}

		
		vulkanSuccess = vkQueueWaitIdle(chainContext.vulkan.highPriorityQueue);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't wait on queue idle!");
		}

	
		vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, 1, cast(immutable(VkCommandBuffer)*)&chainContext.vulkan.setupCmdBuffer);
		chainContext.vulkan.setupCmdBuffer = null; // todo : check if still necessary
	}
	
	// THIS IS DUPLICATED CODE!
	void createSetupCommandBuffer() {
		if (chainContext.vulkan.setupCmdBuffer !is null) {
			vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, 1, &chainContext.vulkan.setupCmdBuffer);
			chainContext.vulkan.setupCmdBuffer = null; // todo : check if still necessary
		}
	
		VkCommandBufferAllocateInfo cmdBufAllocateInfo;
		initCommandBufferAllocateInfo(&cmdBufAllocateInfo);
		cmdBufAllocateInfo.commandPool = chainContext.vulkan.cmdPool.value;
    	cmdBufAllocateInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
		cmdBufAllocateInfo.commandBufferCount = 1;
		
		vulkanResult = vkAllocateCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, &cmdBufAllocateInfo, &chainContext.vulkan.setupCmdBuffer);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, vulkan.Messages.COULDNT_COMMAND_BUFFER);
		}
		
		// todo : Command buffer is also started here, better put somewhere else
		// todo : Check if necessaray at all...
		VkCommandBufferBeginInfo cmdBufInfo;
		initCommandBufferBeginInfo(&cmdBufInfo);
		// todo : check null handles, flags?
	
		vulkanResult = vkBeginCommandBuffer(chainContext.vulkan.setupCmdBuffer, &cmdBufInfo);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't begin command buffer!");
		}
	}


	setupDepthStencil(); // DONE
	/*scope(exit) TODO;*/
	
	createRenderpass(); // DONE
	scope(exit) vkDestroyRenderPass(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.renderPass, null);

	// we don't do this for now
	// TODO LOW
	//createPipelineCache();
	
	
	setupFrameBuffer(); // DONE
	scope(exit) {
		for (uint32_t i = 0; i < chainContext.vulkan.frameBuffers.length; i++) {
			vkDestroyFramebuffer(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.frameBuffers.ptr[i], null);
		}
		
		chainContext.vulkan.frameBuffers.dispose();
		chainContext.vulkan.frameBuffers = null;
	}
	
	
	flushSetupCommandBuffer();
	
	createSetupCommandBuffer();
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
}
