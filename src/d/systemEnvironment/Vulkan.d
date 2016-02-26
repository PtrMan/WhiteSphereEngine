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

import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import vulkan.VulkanDevice;
import vulkan.VulkanTools;
import Exceptions : EngineException;
import TypedPointerWithLength : TypedPointerWithLength;

/**
 * queries all devices and creates a connection to the best device,
 * creates basic vulkan resources
 *
 */
public void platformVulkan2DeviceBase(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	VkResult vulkanResult;
	
	// we enable the standard debug and validation layers
	string[] layersToLoadGced = ["VK_LAYER_LUNARG_standard_validation"];
	
	string[] extensionsToLoadGced;
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
	
	
	
	
	
	VkInstanceCreateInfo instanceCreateInfo;
	initInstanceCreateInfo(&instanceCreateInfo);

	instanceCreateInfo.enabledLayerCount = cast(uint32_t)layersNonGced.length;
	instanceCreateInfo.ppEnabledLayerNames = layersNonGced.ptr;
	
	instanceCreateInfo.enabledExtensionCount = cast(uint32_t)extensionsNonGced.length;
	instanceCreateInfo.ppEnabledExtensionNames = extensionsNonGced.ptr;
	
	chainContext.vulkan.instance = NonGcHandle!VkInstance.createNotInitialized();
	scope(exit) chainContext.vulkan.instance.dispose();
	
	vulkanResult = vkCreateInstance(&instanceCreateInfo, null, chainContext.vulkan.instance.ptr);
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "vkCreateInstance failed!");
	}
	scope(exit) vkDestroyInstance(chainContext.vulkan.instance.value, null);
	
	
	// enumerate devices
	uint32_t physicalDevicesCount;
	vulkanResult = vkEnumeratePhysicalDevices(chainContext.vulkan.instance.value, &physicalDevicesCount, null);
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "vkEnumeratePhysicalDevices failed!");
	}
	
	if( physicalDevicesCount == 0 ) {
		throw new EngineException(true, true, "vkEnumeratePhysicalDevices returned a device count of zero!");
	}


	// TODO< check if we do this like this in the OpenGL implementation and rewrite this code here if we allocate memory not over the GC
	VkPhysicalDevice[] physicalDevices = new VkPhysicalDevice[physicalDevicesCount];
	vulkanResult = vkEnumeratePhysicalDevices(chainContext.vulkan.instance.value, &physicalDevicesCount, physicalDevices.ptr);
	if( !vulkanSuccess(vulkanResult) ) {
		throw new EngineException(true, true, "vkEnumeratePhysicalDevices failed!");
	}

	VulkanDevice[] vulkanDevices = new VulkanDevice[physicalDevicesCount];
	for( uint deviceI = 0; deviceI < physicalDevicesCount; deviceI++ ) {
		vulkanDevices[deviceI] = new VulkanDevice();
	}

	// copy
	for( uint deviceI = 0; deviceI < physicalDevicesCount; deviceI++ ) {
		vulkanDevices[deviceI].physicalDevice = physicalDevices[deviceI];
	}

	// invalidate/ free
	physicalDevices = null;
	physicalDevicesCount = 0;


	// enumerate all properties and queue information of the physical devices for the selection of the best device
	foreach( VulkanDevice deviceIterator; vulkanDevices ) {
		vkGetPhysicalDeviceProperties(deviceIterator.physicalDevice, &(deviceIterator.physicalDeviceProperties));

		uint32_t queueFamilyPropertiesCount;
		vkGetPhysicalDeviceQueueFamilyProperties(deviceIterator.physicalDevice, &queueFamilyPropertiesCount, null);

		deviceIterator.queueFamilyProperties = new VkQueueFamilyProperties[queueFamilyPropertiesCount];
		vkGetPhysicalDeviceQueueFamilyProperties(deviceIterator.physicalDevice, &queueFamilyPropertiesCount, deviceIterator.queueFamilyProperties.ptr);
	}
	
	{
		import std.stdio : writeln;
		writeln("I have ", vulkanDevices.length, " vulkan devices");
	
	}
	
	// now we filter for the devices with at least n queue of the given type
	VulkanDevice[] possibleDevices;

	/* TODO
	final uint minimumNumberOfComputeQueues = 2;

	foreach( VulkanDevice currentDevice; vulkanDevices ) {
		// TODO< check for required properties of the queues >
		deviceIterator.queueFamilyProperties
	}
	*/

	// HACK
	// for now we just add all devices to possibleDevices
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



	// create device	
	VkPhysicalDeviceFeatures physicalDeviceFeatures;
	initPhysicalDeviceFeatures(&physicalDeviceFeatures);

	// TODO< check if we do this like this in the OpenGL implementation and rewrite this code here if we allocate memory not over the GC
	float[] queuePriorities = new float[2];
	queuePriorities[0] = 1.0f;
	queuePriorities[1] = 0.3f;

	// TODO< check if we do this like this in the OpenGL implementation and rewrite this code here if we allocate memory not over the GC
	// for now we just request two queues
	// one high priority queue and one low priority queue
	VkDeviceQueueCreateInfo[] queueCreateInfoArray = new VkDeviceQueueCreateInfo[1];
	initDeviceQueueCreateInfo(&(queueCreateInfoArray[0]));
	queueCreateInfoArray[0].queueFamilyIndex = 0; // HACK< TODO< lookup index > >
	queueCreateInfoArray[0].queueCount = 2;
	queueCreateInfoArray[0].pQueuePriorities = cast(immutable(float)*)queuePriorities.ptr;

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


	// now we can free the array with the layers and the baked gc memory
	layersNonGced.dispose();
	layersNonGced = null; // free memory for gc		
	layersToLoadGced.length = 0; // release GC memory
	
	extensionsNonGced.dispose();
	extensionsNonGced = null; // free memory for gc		
	extensionsToLoadGced.length = 0; // release GC memory
	
	deviceExtensionsNonGced.dispose();
	deviceExtensionsNonGced = null; // free memory for gc		
	deviceExtensionsToLoadGced.length = 0; // release GC memory
	
	


	// retrive queues

	VkQueue highPriorityQueue, lowPriorityQueue;
	{
		uint32_t queueFamilyIndex = 0; // HACK< TODO< lookup index > >

		vkGetDeviceQueue(chainContext.vulkan.chosenDevice.logicalDevice, queueFamilyIndex, 0, &highPriorityQueue);
		vkGetDeviceQueue(chainContext.vulkan.chosenDevice.logicalDevice, queueFamilyIndex, 1, &lowPriorityQueue);
	}



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


	VkFormat depthFormatMediumPrecision;
	VkFormat depthFormatHighPrecision;

	// find best formats
	{
		bool calleeSuccess;
		VkFormat[] preferedMediumPrecisionFormats = [VK_FORMAT_D24_UNORM_S8_UINT, VK_FORMAT_D16_UNORM_S8_UINT, VK_FORMAT_D16_UNORM];
		depthFormatMediumPrecision = vulkanHelperFindBestFormatTry(chainContext.vulkan.chosenDevice.physicalDevice, preferedMediumPrecisionFormats, VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT, calleeSuccess);
		if( !calleeSuccess ) {
			throw new EngineException(true, true, "Couldn't find a format for '" ~ "depthFormatMediumPrecision" ~ "'!");
		}

		VkFormat[] preferedHighPrecisionFormats = [VK_FORMAT_D32_SFLOAT_S8_UINT, VK_FORMAT_D32_SFLOAT];
		depthFormatHighPrecision = vulkanHelperFindBestFormatTry(chainContext.vulkan.chosenDevice.physicalDevice, preferedHighPrecisionFormats, VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT, calleeSuccess);
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
	VkCommandBuffer postPresentCmdBuffer;
	VkCommandBuffer setupCmdBuffer;
	
	TypedPointerWithLength!VkCommandBuffer drawCmdBuffers;
	
	void createSetupCommandBuffer() {
		if (setupCmdBuffer !is null) {
			vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, 1, &setupCmdBuffer);
			setupCmdBuffer = null; // todo : check if still necessary
		}
	
		VkCommandBufferAllocateInfo cmdBufAllocateInfo;
		initCommandBufferAllocateInfo(&cmdBufAllocateInfo);
		cmdBufAllocateInfo.commandPool = chainContext.vulkan.cmdPool.value;
    	cmdBufAllocateInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
		cmdBufAllocateInfo.commandBufferCount = 1;
		
		vulkanResult = vkAllocateCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, &cmdBufAllocateInfo, &setupCmdBuffer);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, vulkan.Messages.COULDNT_COMMAND_BUFFER);
		}
		
		// todo : Command buffer is also started here, better put somewhere else
		// todo : Check if necessaray at all...
		VkCommandBufferBeginInfo cmdBufInfo;
		initCommandBufferBeginInfo(&cmdBufInfo);
		// todo : check null handles, flags?
	
		vulkanResult = vkBeginCommandBuffer(setupCmdBuffer, &cmdBufInfo);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't begin command buffer!");
		}
	}
	
	void setupSwapChain() {
		uint32_t width = chainContext.window.width;
		uint32_t height = chainContext.window.height;
		chainContext.vulkan.swapChain.create(setupCmdBuffer, &width, &height);
	}
	
	void createCommandBuffers() {
		// Create one command buffer per frame buffer 
		// in the swap chain
		// Command buffers store a reference to the 
		// frame buffer inside their render pass info
		// so for static usage withouth having to rebuild 
		// them each frame, we use one per frame buffer
		assert(chainContext.vulkan.swapChain.imageCount > 0);
		drawCmdBuffers = TypedPointerWithLength!VkCommandBuffer.allocate(chainContext.vulkan.swapChain.imageCount);
		
		VkCommandBufferAllocateInfo cmdBufAllocateInfo;
		initCommandBufferAllocateInfo(&cmdBufAllocateInfo);
		cmdBufAllocateInfo.commandPool = chainContext.vulkan.cmdPool.value;
		cmdBufAllocateInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
		cmdBufAllocateInfo.commandBufferCount = cast(uint32_t)drawCmdBuffers.length;
		
		vulkanResult = vkAllocateCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, &cmdBufAllocateInfo, drawCmdBuffers.ptr);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't allocate command buffer!");
		}
	
		// Create one command buffer for submitting the
		// post present image memory barrier
		cmdBufAllocateInfo.commandBufferCount = 1;
	
		vulkanResult = vkAllocateCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, &cmdBufAllocateInfo, &postPresentCmdBuffer);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't allocate command buffer!");
		}
	}
	
	// not necessary, we did this already
	//createCommandPool();
	//scope(exit) vkDestroyCommandPool(chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, null);

	createSetupCommandBuffer();
	scope(exit) vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, 1, &setupCmdBuffer);
	
	setupSwapChain();
	scope(exit) chainContext.vulkan.swapChain.cleanup();
	
	createCommandBuffers();
	scope(exit) {
		vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, 1, &postPresentCmdBuffer);
		vkFreeCommandBuffers(chainContext.vulkan.chosenDevice.logicalDevice, chainContext.vulkan.cmdPool.value, drawCmdBuffers.length, drawCmdBuffers.ptr);		
	}
	
	// TODO< other initialisation for swapchain and vulkan api >
	
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
}
