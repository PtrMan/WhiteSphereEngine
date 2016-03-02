module vulkan.VulkanSwapChain2;

import std.typecons : Nullable;
import std.stdint;

// TODO< remove malloc and replace with something managed >
import core.stdc.stdlib; // malloc

version(Win32) {
	import core.sys.windows.windows;
}

import api.vulkan.Vulkan;
import vulkan.VulkanPlatform;
import vulkan.VulkanHelpers;
//static import vulkan.VulkanTools;
import Exceptions;

private template GET_INSTANCE_PROC_ADDR(string inst, string entrypoint) {
	enum GET_INSTANCE_PROC_ADDR = "fp" ~ entrypoint ~ " = cast(PFN_vk" ~ entrypoint ~ ")helperGetVulkanFunctionAdressByInstance(" ~ inst ~ ", \"vk" ~ entrypoint ~ "\");\n" ~
    "if (fp" ~ entrypoint ~ " is null) {\n" ~
    "throw new EngineException(true, true, \"Init of entrypoint for " ~ entrypoint ~ " failed!\");\n" ~
    "}\n";
}

// Macro to get a procedure address based on a vulkan device
private template GET_DEVICE_PROC_ADDR(string dev, string entrypoint) {
	enum GET_DEVICE_PROC_ADDR = "fp" ~ entrypoint ~ " = cast(PFN_vk" ~ entrypoint ~ ")helperGetVulkanFunctionAdressByDevice(" ~ dev ~ ", \"vk" ~ entrypoint ~ "\");\n" ~
    "if (fp" ~ entrypoint ~ " is null) {\n" ~
    "throw new EngineException(true, true, \"Init of entrypoint for " ~ entrypoint ~ " failed!\");\n" ~
    "}\n";
}



// HACK
// belongs finally into InitialisationHelpers.d
import helpers.Conversion : convertCStringToD;

private extern(System) VkBool32 vulkanDebugCallback2(VkFlags msgFlags, VkDebugReportObjectTypeEXT objType, uint64_t srcObject, size_t location, int32_t msgCode, const char *pLayerPrefix, const char *pMsg, void *pUserData) {
	import std.stdio;
	
	writeln("vulkan debug: layerprefix=", convertCStringToD(pLayerPrefix), " message=", convertCStringToD(pMsg));
	return 1;
}



import helpers.VariableValidator;

/**
 * alternative implementation of swapchain because I had issues with the other implementation
 * (see the code at the time of the first commit)
 * 
 * almost completly based on
 * https://www.khronos.org/registry/vulkan/specs/1.0-wsi_extensions/xhtml/vkspec.html#_vk_khr_swapchain
 */
class VulkanSwapChain2 {
	private VariableValidator!VkInstance instance;
	private VariableValidator!VkDevice device;
	private VariableValidator!VkPhysicalDevice physicalDevice;
	private VariableValidator!VkSurfaceKHR surface;
	
	// Function pointers
	private PFN_vkGetPhysicalDeviceSurfaceSupportKHR fpGetPhysicalDeviceSurfaceSupportKHR;
	private PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR fpGetPhysicalDeviceSurfaceCapabilitiesKHR; 
	private PFN_vkGetPhysicalDeviceSurfaceFormatsKHR fpGetPhysicalDeviceSurfaceFormatsKHR;
	private PFN_vkGetPhysicalDeviceSurfacePresentModesKHR fpGetPhysicalDeviceSurfacePresentModesKHR;
	private PFN_vkCreateSwapchainKHR fpCreateSwapchainKHR;
	private PFN_vkDestroySwapchainKHR fpDestroySwapchainKHR;
	private PFN_vkGetSwapchainImagesKHR fpGetSwapchainImagesKHR;
	private PFN_vkAcquireNextImageKHR fpAcquireNextImageKHR;
	private PFN_vkQueuePresentKHR fpQueuePresentKHR;
	
	//private PFN_vkGetSurfacePropertiesKHR fpGetSurfacePropertiesKHR;

	
	// Connect to the instance und device and get all required function pointers
	public final void connect(VkInstance instance, VkPhysicalDevice physicalDevice, VkDevice device) {
		this.instance = instance;
		this.physicalDevice = physicalDevice;
		this.device = device;
		mixin(GET_INSTANCE_PROC_ADDR!("instance", "GetPhysicalDeviceSurfaceSupportKHR"));
		mixin(GET_INSTANCE_PROC_ADDR!("instance", "GetPhysicalDeviceSurfaceCapabilitiesKHR"));
		mixin(GET_INSTANCE_PROC_ADDR!("instance", "GetPhysicalDeviceSurfaceFormatsKHR"));
		mixin(GET_INSTANCE_PROC_ADDR!("instance", "GetPhysicalDeviceSurfacePresentModesKHR"));
		mixin(GET_DEVICE_PROC_ADDR!("device", "CreateSwapchainKHR"));
		mixin(GET_DEVICE_PROC_ADDR!("device", "DestroySwapchainKHR"));
		mixin(GET_DEVICE_PROC_ADDR!("device", "GetSwapchainImagesKHR"));
		mixin(GET_DEVICE_PROC_ADDR!("device", "AcquireNextImageKHR"));
		mixin(GET_DEVICE_PROC_ADDR!("device", "QueuePresentKHR"));
	}
	
	public final void initSurface(
		// for windows
		HINSTANCE platformHandle, HWND platformWindow
	) {
		instance.invalidate();
		device.invalidate();
		physicalDevice.invalidate();
		surface.invalidate();
		
		import TypedPointerWithLength : TypedPointerWithLength;
		import std.string : toStringz;
		import vulkan.VulkanDevice;
		VkResult vulkanResult;
		
		
		// hack
		import systemEnvironment.ChainContext;
		ChainContext chainContext = new ChainContext();
			

		import core.memory : GC;












	// PULLED IN FROM Vulkan.d BEGIN

	
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
	//instance = chainContext.vulkan.instance.value;
	scope(exit) chainContext.vulkan.instance.dispose();
	
	{
		VkInstance instance;
		vulkan.InitialisationHelpers.initializeInstance(layersToLoadGced, extensionsToLoadGced, deviceExtensionsToLoadGced, cast(const(bool))withSurface, instance);
		
		{
			import std.stdio;
			writeln("initializeInstance value is ",instance);
		}
		
		
		chainContext.vulkan.instance.value = instance;
	}
	instance = chainContext.vulkan.instance.value;
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
		debugReportCallbackCreateInfoEXT.pfnCallback = &vulkanDebugCallback2;
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
	
	{
		import std.stdio : writeln;
		writeln("I have ", vulkanDevices.length, " vulkan devices");
	
	}
	
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
	
	
	// set some funny variables
	physicalDevice = chainContext.vulkan.chosenDevice.physicalDevice;
	
	
	

	// query memory
	chainContext.vulkan.chosenDevice.physicalDeviceMemoryProperties = cast(VkPhysicalDeviceMemoryProperties*)GC.malloc(VkPhysicalDeviceMemoryProperties.sizeof, GC.BlkAttr.NO_MOVE | GC.BlkAttr.NO_SCAN);
	vkGetPhysicalDeviceMemoryProperties(chainContext.vulkan.chosenDevice.physicalDevice, chainContext.vulkan.chosenDevice.physicalDeviceMemoryProperties);


	// PULLED IN FROM Vulkan.d END









		vulkanResult = createSurface(platformHandle, platformWindow);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create SwapChain Surface!");
		}



		
		
		
		
		
		import std.stdio;
		/////////////
		// big hack, we do initialize the whole crap device here, just for getting to a black screen, need to work out the correct queue initializing code
		///////////////
		writeln("HERE");
		
		uint32_t queueFamilyCount;
    vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice.value, &queueFamilyCount, null);

		writeln("HERE 2");

    VkQueueFamilyProperties* pMainQueueInfo = cast(VkQueueFamilyProperties*)malloc(queueFamilyCount * VkQueueFamilyProperties.sizeof);
    
    writeln("HERE 3");
    
    VkBool32* pSupportsPresent = cast(VkBool32 *)malloc(queueFamilyCount * VkBool32.sizeof);

    vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice.value, &queueFamilyCount, pMainQueueInfo);

    for (uint32_t i = 0; i < queueFamilyCount; ++i)
        fpGetPhysicalDeviceSurfaceSupportKHR(physicalDevice.value, i, surface.value, &pSupportsPresent[i]);

    // Search for a graphics and a present queue in the array of queue
    // families, try to find one that supports both
    uint32_t graphicsQueueFamilyIndex = UINT32_MAX;
    uint32_t presentQueueFamilyIndex  = UINT32_MAX;
    for (uint32_t i = 0; i < queueFamilyCount; ++i)
    {
        if ((pMainQueueInfo[i].queueFlags & VK_QUEUE_GRAPHICS_BIT) != 0)
        {
            if (graphicsQueueFamilyIndex == UINT32_MAX)
                graphicsQueueFamilyIndex = i;

            if (pSupportsPresent[i] == VK_TRUE)
            {
                graphicsQueueFamilyIndex = i;
                presentQueueFamilyIndex = i;
                break;
            }
        }
    }

    if (presentQueueFamilyIndex == UINT32_MAX)
    {
        // If didn't find a queue that supports both graphics and present, then
        // find a separate present queue.
        for (size_t i = 0; i < queueFamilyCount; ++i)
            if (pSupportsPresent[i] == VK_TRUE)
            {
                presentQueueFamilyIndex = i;
                break;
            }
    }

    // Free the temporary queue info allocations
    free(pMainQueueInfo);
    free(pSupportsPresent);

    // Generate error if could not find both a graphics and a present queue
    if (graphicsQueueFamilyIndex == UINT32_MAX || presentQueueFamilyIndex == UINT32_MAX)
    {
        throw new EngineException(true, true, "Could not find a graphics and a present queue");
    }

    // Put together the list of requested queues
    const float queuePriority = 1.0f;
    VkDeviceQueueCreateInfo[] requestedQueues =
    [
        {
            VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO, // sType
            NULL,                                       // pNext
            0,                                          // flags
            graphicsQueueFamilyIndex,                   // queueFamilyIndex
            1,                                          // queueCount
            cast(immutable(float)*)&queuePriority                              // pQueuePriorities
        },
        {
            VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO, // sType
            NULL,                                       // pNext
            0,                                          // flags
            presentQueueFamilyIndex,                    // queueFamilyIndex
            1,                                          // queueCount
            cast(immutable(float)*)&queuePriority                              // pQueuePriorities
        }
    ];
    uint32_t requestedQueueCount = 2;

    if (graphicsQueueFamilyIndex == presentQueueFamilyIndex)
    {
        // We need only a single queue if the graphics queue is also the present queue
        requestedQueueCount = 1;
    }

    // Create a device and request access to the specified queues
    /*
    const VkDeviceCreateInfo deviceCreateInfo =
    {
        VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,           // sType
        NULL,                                           // pNext
        0,                                              // flags
        requestedQueueCount,                            // queueCreateInfoCount
        &requestedQueues,                               // pQueueCreateInfos
        ...
    };

    VkDevice device;
    vkCreateDevice(physicalDevice, &deviceCreateInfo, &device);
    */
    
    
    
    VkPhysicalDeviceFeatures physicalDeviceFeatures;
	initPhysicalDeviceFeatures(&physicalDeviceFeatures);
    
    VkDeviceCreateInfo deviceCreateInfo;
	initDeviceCreateInfo(&deviceCreateInfo);
	deviceCreateInfo.queueCreateInfoCount = requestedQueueCount;
	deviceCreateInfo.pQueueCreateInfos = cast(immutable(VkDeviceQueueCreateInfo)*)requestedQueues.ptr;

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
    
    device = chainContext.vulkan.chosenDevice.logicalDevice;
    
    
    
    
    





    // Acquire graphics and present queue handle from device
    VkQueue graphicsQueue, presentQueue;
    vkGetDeviceQueue(device.value, graphicsQueueFamilyIndex, 0, &graphicsQueue);
    vkGetDeviceQueue(device.value, presentQueueFamilyIndex, 0, &presentQueue);
		
		
		
		




	{
		import std.stdio;
		writeln("family indides ", graphicsQueueFamilyIndex, " ", presentQueueFamilyIndex);
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






		
		
		
		
		
		
		
		
		
		
		assert(device.isValid && surface.isValid);
		
		// Check the surface properties and formats
	    VkSurfaceCapabilitiesKHR surfaceProperties;
	    /*fpGetSurfacePropertiesKHR*/fpGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice.value, surface.value, &surfaceProperties);
	
	    uint32_t formatCount;
	    fpGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.value, surface.value, &formatCount, null);
	
	    VkSurfaceFormatKHR* pSurfFormats = cast(VkSurfaceFormatKHR*)malloc(formatCount * VkSurfaceFormatKHR.sizeof);
	    fpGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.value, surface.value, &formatCount, pSurfFormats);
	
	    uint32_t presentModeCount;
	    fpGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice.value, surface.value, &presentModeCount, null);
	
	    VkPresentModeKHR* pPresentModes = cast(VkPresentModeKHR*)malloc(presentModeCount * VkPresentModeKHR.sizeof);
	    fpGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice.value, surface.value, &presentModeCount, pPresentModes);
		
	    VkExtent2D swapchainExtent;
	    // width and height are either both -1, or both not -1.
	    if (surfaceProperties.currentExtent.width == -1)
	    {
	        // If the surface size is undefined, the size is set to
	        // the size of the images requested, which must fit within the minimum
	        // and maximum values.
	        swapchainExtent.width = 320;
	        swapchainExtent.height = 320;
	
	        if (swapchainExtent.width < surfaceProperties.minImageExtent.width)
	            swapchainExtent.width = surfaceProperties.minImageExtent.width;
	        else if (swapchainExtent.width > surfaceProperties.maxImageExtent.width)
	            swapchainExtent.width = surfaceProperties.maxImageExtent.width;
	
	        if (swapchainExtent.height < surfaceProperties.minImageExtent.height)
	            swapchainExtent.height = surfaceProperties.minImageExtent.height;
	        else if (swapchainExtent.height > surfaceProperties.maxImageExtent.height)
	            swapchainExtent.height = surfaceProperties.maxImageExtent.height;
	    }
	    else
	    {
	        // If the surface size is defined, the swapchain size must match
	        swapchainExtent = surfaceProperties.currentExtent;
	    }
	
	    // Application desires to own 2 images at a time (still allowing
	    // 'minImageCount' images to be owned by the presentation engine).
	    uint32_t desiredNumberOfSwapchainImages = surfaceProperties.minImageCount + 2;
	    if ((surfaceProperties.maxImageCount > 0) &&
	        (desiredNumberOfSwapchainImages > surfaceProperties.maxImageCount))
	    {
	        // Application must settle for fewer images than desired:
	        desiredNumberOfSwapchainImages = surfaceProperties.maxImageCount;
	    }
	
	    VkFormat swapchainFormat;
	    // If the format list includes just one entry of VK_FORMAT_UNDEFINED,
	    // the surface has no preferred format.  Otherwise, at least one
	    // supported format will be returned (assuming that the
	    // vkGetPhysicalDeviceSurfaceSupportKHR function, in the
	    // VK_KHR_surface extension returned support for the surface).
	    if ((formatCount == 1) && (pSurfFormats[0].format == VK_FORMAT_UNDEFINED))
	        swapchainFormat = VK_FORMAT_R8G8B8_UNORM;
	    else
	    {
	        assert(formatCount >= 1);
	        swapchainFormat = pSurfFormats[0].format;
	    }
	    VkColorSpaceKHR swapchainColorSpace = pSurfFormats[0].colorSpace;
	    
	    // If mailbox mode is available, use it, as it is the lowest-latency non-
	    // tearing mode.  If not, fall back to FIFO which is always available.
	    VkPresentModeKHR swapchainPresentMode = VK_PRESENT_MODE_FIFO_KHR;
	    for (size_t i = 0; i < presentModeCount; ++i)
	        if (pPresentModes[i] == VK_PRESENT_MODE_MAILBOX_KHR)
	        {
	            swapchainPresentMode = VK_PRESENT_MODE_MAILBOX_KHR;
	            break;
	        }
		
		// TODO< cut me here >
		
		
		
	    const VkSwapchainCreateInfoKHR createInfo =
	    {
	        VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,    // sType
	        null,                                           // pNext
	        0,                                              // flags
	        surface.value,                                  // surface
	        desiredNumberOfSwapchainImages,                 // minImageCount
	        swapchainFormat,                                // imageFormat
	        swapchainColorSpace,                            // imageColorSpace
	        swapchainExtent,                                // imageExtent
	        1,                                              // imageArrayLayers
	        VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT,            // imageUsage
	        VK_SHARING_MODE_EXCLUSIVE,                      // imageSharingMode
	        0,                                              // queueFamilyIndexCount
	        null,                                           // pQueueFamilyIndices
	        surfaceProperties.currentTransform,             // preTransform
	        VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR,             // compositeAlpha
	        swapchainPresentMode,                           // presentMode
	        VK_TRUE,                                        // clipped
	        VK_NULL_HANDLE                                  // oldSwapchain
	    };
	
	    VkSwapchainKHR swapchain;
	    fpCreateSwapchainKHR(device.value, cast(immutable(VkSwapchainCreateInfoKHR)*)&createInfo, null, &swapchain);
	    
	    
	    
	    
	    
	    /////////////////////////////////////////////////
	    // Obtaining the persistent images of a swapchain
	    /////////////////////////////////////////////////
	    uint32_t swapchainImageCount;
    	fpGetSwapchainImagesKHR(device.value, cast(immutable(VkSwapchainCreateInfoKHR)*)swapchain, &swapchainImageCount, null);

    	VkImage* pSwapchainImages = cast(VkImage*)malloc(swapchainImageCount * VkImage.sizeof);
    	fpGetSwapchainImagesKHR(device.value, swapchain, &swapchainImageCount, pSwapchainImages);

	    
	    
	    
	    
	    //////////////////////////////////
	    // simple rendering and presenting
	    //////////////////////////////////
	    // simple rendering nd presenting

	    // Construct command buffers rendering to the presentable images
	    VkCommandBuffer[] cmdBuffers;
	    VkImageView[] views;
	    
	    cmdBuffers.length = swapchainImageCount;
	    views.length = swapchainImageCount;
	    
	    // create command buffers
	    for (size_t i = 0; i < swapchainImageCount; ++i) {
			VkCommandBufferAllocateInfo commandBufferAllocationInfo;
			initCommandBufferAllocateInfo(&commandBufferAllocationInfo);
			commandBufferAllocationInfo.commandPool = chainContext.vulkan.cmdPool.value;
			commandBufferAllocationInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
			commandBufferAllocationInfo.commandBufferCount = 1; // we just want to allocate one command buffer in the target array
		
			// SYNC : this needs to be host synced with a mutex
			vulkanResult = vkAllocateCommandBuffers(
				chainContext.vulkan.chosenDevice.logicalDevice,
				&commandBufferAllocationInfo,
				&cmdBuffers[i]);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, vulkan.Messages.COULDNT_COMMAND_BUFFER);
			}
	    }
	    
		
	    for (size_t i = 0; i < swapchainImageCount; ++i)
	    {
	        const VkImageViewCreateInfo viewInfo =
	        {
	            VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,   // sType
	            null,                                       // pNext
	            0,                                          // flags
	            pSwapchainImages[i],                        // image
	            VK_IMAGE_VIEW_TYPE_2D,                      // viewType
	            swapchainFormat,                            // format
	            {VK_COMPONENT_SWIZZLE_R, VK_COMPONENT_SWIZZLE_G, VK_COMPONENT_SWIZZLE_B, VK_COMPONENT_SWIZZLE_A}, // components
	            {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1}// subresourceRange
	        };
	        vkCreateImageView(device.value, &viewInfo, null, &views[i]);
			
			
	        ///...
	        
			VkCommandBufferBeginInfo beginInfo;
			initCommandBufferBeginInfo(&beginInfo);
	        vkBeginCommandBuffer(cmdBuffers[i], &beginInfo);
	
	        // Need to transition image from presentable state before being able to render
	        const VkImageMemoryBarrier acquireImageBarrier =
	        {
	            VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,     // sType
	            null,                                       // pNext
	            VK_ACCESS_MEMORY_READ_BIT,                  // srcAccessMask
	            VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT,       // dstAccessMask
	            VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,            // oldLayout
	            VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,   // newLayout
	            presentQueueFamilyIndex,                    // srcQueueFamilyIndex
	            graphicsQueueFamilyIndex,                   // dstQueueFamilyIndex
	            pSwapchainImages[i],                        // image
	            { VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 }   // subresourceRange
	        };
	
	        vkCmdPipelineBarrier(
	            cmdBuffers[i],
	            VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
	            VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
	            VK_FALSE,
	            0,
	            null,
	            0,
	            null,
	            1,
	            &acquireImageBarrier);
	
	        // ... Render to views[i] ...
	        {
	        	VkImageLayout imageLayout = VK_IMAGE_LAYOUT_GENERAL;
	        	VkClearColorValue clearColor;
	        	VkImageSubresourceRange range = {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1};
	        	
	        
	        	vkCmdClearColorImage(
					cmdBuffers[i],
					pSwapchainImages[i],
					imageLayout,
					&clearColor,
					1, // range count
					&range);
	        }
	        
	        
	
	        // Need to transition image into presentable state before being able to present
	        const VkImageMemoryBarrier presentImageBarrier =
	        {
	            VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,     // sType
	            null,                                       // pNext
	            VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT,       // srcAccessMask
	            VK_ACCESS_MEMORY_READ_BIT,                  // dstAccessMask
	            VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,   // oldLayout
	            VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,            // newLayout
	            graphicsQueueFamilyIndex,                   // srcQueueFamilyIndex
	            presentQueueFamilyIndex,                    // dstQueueFamilyIndex
	            pSwapchainImages[i],                        // image
	            { VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 }   // subresourceRange
	        };
	
	        vkCmdPipelineBarrier(
	            cmdBuffers[i],
	            VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
	            VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT,
	            VK_FALSE,
	            0,
	            null,
	            0,
	            null,
	            1,
	            &presentImageBarrier);
	
	        ///...
	
	        vkEndCommandBuffer(cmdBuffers[i]);
	    }
	
	    const VkSemaphoreCreateInfo semaphoreCreateInfo =
	    {
	        VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,    // sType
	        null,                                       // pNext
	        0                                           // flags
	    };
	
	    VkSemaphore imageAcquiredSemaphore;
	    vkCreateSemaphore(device.value,
	                      &semaphoreCreateInfo, null,
	                      &imageAcquiredSemaphore);
	
	    VkSemaphore renderingCompleteSemaphore;
	    vkCreateSemaphore(device.value,
	                      &semaphoreCreateInfo, null,
	                      &renderingCompleteSemaphore);
	
	    VkResult result;
	    do
	    {
	        uint32_t imageIndex = UINT32_MAX;
	
	        // Get the next available swapchain image
	        result = fpAcquireNextImageKHR(
	            device.value,
	            swapchain,
	            UINT64_MAX,
	            imageAcquiredSemaphore,
	            VK_NULL_HANDLE,
	            &imageIndex);
	
	        // Swapchain cannot be used for presentation if failed to acquired new image.
	        if (result < 0)
	            break;
	
	        // Submit rendering work to the graphics queue
	        const VkPipelineStageFlags waitDstStageMask = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
	        const VkSubmitInfo submitInfo =
	        {
	            VK_STRUCTURE_TYPE_SUBMIT_INFO,          // sType
	            null,                                   // pNext
	            1,                                      // waitSemaphoreCount
	            cast(const(immutable(VkSemaphore)*))&imageAcquiredSemaphore,                // pWaitSemaphores
	            cast(const(immutable(VkPipelineStageFlags)*))&waitDstStageMask,                      // pWaitDstStageMasks
	            1,                                      // commandBufferCount
	            cast(immutable(VkCommandBuffer)*)&cmdBuffers[imageIndex],                // pCommandBuffers
	            1,                                      // signalSemaphoreCount
	            cast(immutable(VkSemaphore)*)&renderingCompleteSemaphore             // pSignalSemaphores
	        };
	        vulkanResult = vkQueueSubmit(graphicsQueue, 1, &submitInfo, VK_NULL_HANDLE);
	        if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Queue submit failed!");
			}
	        
	        // Submit present operation to present queue
	        const VkPresentInfoKHR presentInfo =
	        {
	            VK_STRUCTURE_TYPE_PRESENT_INFO_KHR,     // sType
	            null,                                   // pNext
	            1,                                      // waitSemaphoreCount
	            cast(immutable(VkSemaphore)*)&renderingCompleteSemaphore,            // pWaitSemaphores
	            1,                                      // swapchainCount
	            cast(immutable(VkSwapchainKHR)*)&swapchain,                             // pSwapchains
	            cast(immutable(uint32_t)*)&imageIndex,                            // pImageIndices
	            null                                    // pResults
	        };
	        
	        result = fpQueuePresentKHR(presentQueue, cast(immutable(VkPresentInfoKHR)*)&presentInfo);
	        
	    } while (result >= 0);

	    
	    
	    

	}
	
	private final VkResult createSurface(
		// for windows
		HINSTANCE platformHandle, HWND platformWindow
	) {
		VkResult vulkanResult;
		
		assert(!surface.isValid);
		
		{
			import std.stdio;
			writeln(vkCreateWin32SurfaceKHR);
			writeln("instance value is ",instance.value);
		}
		
		
		// Create surface depending on OS
		version(Win32) {
		VkWin32SurfaceCreateInfoKHR surfaceCreateInfo;
		VkSurfaceKHR surface;
		surfaceCreateInfo.sType = VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
		surfaceCreateInfo.hinstance = platformHandle;
		surfaceCreateInfo.hwnd = platformWindow;
		vulkanResult = vkCreateWin32SurfaceKHR(instance.value, cast(const(VkWin32SurfaceCreateInfoKHR*))&surfaceCreateInfo, null, &surface);
		this.surface = surface;
		}
//#else
//#ifdef __ANDROID__
//		VkAndroidSurfaceCreateInfoKHR surfaceCreateInfo = {};
//		surfaceCreateInfo.sType = VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR;
//		surfaceCreateInfo.window = window;
//		vulkanResult = vkCreateAndroidSurfaceKHR(instance, &surfaceCreateInfo, NULL, &surface);
//#else
		version(Linux) {
		VkXcbSurfaceCreateInfoKHR surfaceCreateInfo;
		surfaceCreateInfo.sType = VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR;
		surfaceCreateInfo.connection = connection;
		surfaceCreateInfo.window = window;
		vulkanResult = vkCreateXcbSurfaceKHR(instance, &surfaceCreateInfo, null, &surface);
		}
		
		return vulkanResult;
	}
}
