module vulkan.VulkanSwapChain2;

import std.stdint;

import Exceptions;
import api.vulkan.Vulkan;
import vulkan.VulkanPlatform;
import vulkan.VulkanHelpers;
import helpers.VariableValidator;

/*
private template GET_INSTANCE_PROC_ADDR(string inst, string entrypoint) {
	enum GET_INSTANCE_PROC_ADDR = "fp" ~ entrypoint ~ " = cast(PFN_vk" ~ entrypoint ~ ")helperGetVulkanFunctionAdressByInstance(" ~ inst ~ ", \"vk" ~ entrypoint ~ "\");\n" ~
    "if (fp" ~ entrypoint ~ " is null) {\n" ~
    "throw new EngineException(true, true, \"Init of entrypoint for " ~ entrypoint ~ " failed!\");\n" ~
    "}\n";
}
*/

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
	
	private static struct Context {
		VkSwapchainKHR swapchain;
		
		VkImage[] swapchainImages; // no need to destroy(?)
		
		VkFormat swapchainFormat;
		
		uint32_t desiredNumberOfSwapchainImages;
		
		public static struct SemaphorePair {
			VkSemaphore imageAcquiredSemaphore;
			VkSemaphore chainSemaphore;
			VkSemaphore renderingCompleteSemaphore;
		}
	
		SemaphorePair[] semaphorePairs;
	
	}
	
	private Context context; // stores all created handles
	
	// Function pointers
	private PFN_vkCreateSwapchainKHR fpCreateSwapchainKHR;
	private PFN_vkDestroySwapchainKHR fpDestroySwapchainKHR;
	private PFN_vkGetSwapchainImagesKHR fpGetSwapchainImagesKHR;
	private PFN_vkAcquireNextImageKHR fpAcquireNextImageKHR;
	private PFN_vkQueuePresentKHR fpQueuePresentKHR;
	
	
	// accessors for access from outside
	public final @property VkImage[] swapchainImages() {
		return context.swapchainImages;
	}
	
	public final @property VkFormat swapchainFormat() {
		return context.swapchainFormat;
	}
	
	public final @property uint32_t desiredNumberOfSwapchainImages() {
		return context.desiredNumberOfSwapchainImages;
	}
	
	public final @property Context.SemaphorePair[] semaphorePairs() {
		return context.semaphorePairs;
	}
	
	
	// Connect to the instance und device and get all required function pointers
	public final void connect(VkInstance instance, VkPhysicalDevice physicalDevice, VkDevice device) {
		this.instance = instance;
		this.physicalDevice = physicalDevice;
		this.device = device;
		
		mixin(GET_DEVICE_PROC_ADDR!("device", "CreateSwapchainKHR"));
		mixin(GET_DEVICE_PROC_ADDR!("device", "DestroySwapchainKHR"));
		mixin(GET_DEVICE_PROC_ADDR!("device", "GetSwapchainImagesKHR"));
		mixin(GET_DEVICE_PROC_ADDR!("device", "AcquireNextImageKHR"));
		mixin(GET_DEVICE_PROC_ADDR!("device", "QueuePresentKHR"));
	}
	
	public final void initSwapchain(VariableValidator!VkSurfaceKHR surface) {
		const string ERROR_COULDNT_PHYSICAL_DEVICE_FORMATS = "Couldn't get physical device surface formats!";
		const string ERROR_COULDNT_PHYSICAL_DEVICE_PRESENTATION = "Couldn't get physical device present modes!";
		
		VkResult vulkanResult;
		
		import core.memory : GC;

		import vulkan.VulkanTools;

		assert(device.isValid && surface.isValid);
		
		// Check the surface properties and formats
	    VkSurfaceCapabilitiesKHR surfaceProperties;
	    vulkanResult = vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice.value, surface.value, &surfaceProperties);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't get physical device surface capabilities!");
    	}
		
	    uint32_t formatCount;
	    vulkanResult = vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.value, surface.value, &formatCount, null);
	    if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, ERROR_COULDNT_PHYSICAL_DEVICE_FORMATS);
    	}
	    
	    VkSurfaceFormatKHR[] surfaceFormats;
	    surfaceFormats.length = formatCount;
	
	    vulkanResult = vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice.value, surface.value, &formatCount, surfaceFormats.ptr);
	    if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, ERROR_COULDNT_PHYSICAL_DEVICE_FORMATS);
    	}
	
	    uint32_t presentModeCount;
	    vulkanResult = vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice.value, surface.value, &presentModeCount, null);
	    if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, ERROR_COULDNT_PHYSICAL_DEVICE_PRESENTATION);
    	}
	    
	    VkPresentModeKHR[] presentModes;
	    presentModes.length = presentModeCount;
	
	    vulkanResult = vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice.value, surface.value, &presentModeCount, presentModes.ptr);
	    if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, ERROR_COULDNT_PHYSICAL_DEVICE_PRESENTATION);
    	}
		
	    VkExtent2D swapchainExtent;
	    // width and height are either both -1, or both not -1.
	    if (surfaceProperties.currentExtent.width == -1) {
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
	    else {
	        // If the surface size is defined, the swapchain size must match
	        swapchainExtent = surfaceProperties.currentExtent;
	    }
		
		
		// inspired by https://software.intel.com/en-us/articles/api-without-secrets-introduction-to-vulkan-part-2
		//             see chapter "Selecting the Number of Swap Chain Images"
		uint getSwapChainNumImages(uint numberOfImagesToOwnRequest) {
			uint desiredNumberOfSwapchainImages = cast(uint)surfaceProperties.minImageCount + numberOfImagesToOwnRequest;
		    if (surfaceProperties.maxImageCount > 0) {
		    	// Application must settle for at maximum of the allowed images
		    	import std.algorithm.comparison : min;
		    	desiredNumberOfSwapchainImages = min(desiredNumberOfSwapchainImages, surfaceProperties.maxImageCount);
		    }
		    return desiredNumberOfSwapchainImages;
		}
		
		uint numberOfImagesToOwnRequest = 2; // Application desires to own 2 images at a time
	    context.desiredNumberOfSwapchainImages = cast(uint32_t)getSwapChainNumImages(numberOfImagesToOwnRequest);
		
		// TODO< log >
	    {
	    	import std.stdio;
	    	writeln("desiredNumberOfSwapchainImages ", context.desiredNumberOfSwapchainImages);
	    }
		
	    VkColorSpaceKHR swapchainColorSpace;
	    // If the format list includes just one entry of VK_FORMAT_UNDEFINED,
	    // the surface has no preferred format.  Otherwise, at least one
	    // supported format will be returned (assuming that the
	    // vkGetPhysicalDeviceSurfaceSupportKHR function, in the
	    // VK_KHR_surface extension returned support for the surface).
	    if ((formatCount == 1) && (surfaceFormats[0].format == VK_FORMAT_UNDEFINED)) {
	        context.swapchainFormat = VK_FORMAT_R8G8B8_UNORM;
	        swapchainColorSpace = VK_COLORSPACE_SRGB_NONLINEAR_KHR;
	    }
	    else {
	        assert(formatCount >= 1);
	        context.swapchainFormat = surfaceFormats[0].format;
	        swapchainColorSpace = surfaceFormats[0].colorSpace;
	    }
	    
	    
	    // If mailbox mode is available, use it, as it is the lowest-latency non-
	    // tearing mode.  If not, fall back to FIFO which is always available.
	    VkPresentModeKHR swapchainPresentMode = VK_PRESENT_MODE_FIFO_KHR;
	    foreach( iteratorPresentMode; presentModes ) {
	        if( iteratorPresentMode == VK_PRESENT_MODE_MAILBOX_KHR ) {
	            swapchainPresentMode = VK_PRESENT_MODE_MAILBOX_KHR;
	            break;
	        }
	    }
	    
		// TODO< cut me here >
		bool forceFifo = true;
		if( forceFifo ) {
			swapchainPresentMode = VK_PRESENT_MODE_FIFO_KHR;
		}
		
		
	    VkSwapchainCreateInfoKHR createInfo;
	    with (createInfo) {
	        sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
	        pNext = null;
	        flags = 0;
	        minImageCount = desiredNumberOfSwapchainImages;
	        imageFormat = swapchainFormat;
	        imageColorSpace = swapchainColorSpace;
	        imageExtent = swapchainExtent;
	        imageArrayLayers = 1;
	        imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
	        imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
	        queueFamilyIndexCount = 0;
	        pQueueFamilyIndices = null;
	        preTransform = surfaceProperties.currentTransform;
	        compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
	        presentMode = swapchainPresentMode;
	        clipped = VK_TRUE;
	        oldSwapchain = VK_NULL_HANDLE;
	    }
	    createInfo.surface = surface.value; // outside because ambiguous
	    
	
	    vulkanResult = fpCreateSwapchainKHR(device.value, cast(immutable(VkSwapchainCreateInfoKHR)*)&createInfo, null, &context.swapchain);
	    if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create swapchain!");
    	}
	    
	    scope(failure) fpDestroySwapchainKHR(device.value, context.swapchain, null);
	    
	    
	    /////////////////////////////////////////////////
	    // Obtaining the persistent images of a swapchain
	    /////////////////////////////////////////////////
	    uint32_t swapchainImageCount;
    	vulkanResult = fpGetSwapchainImagesKHR(device.value, cast(immutable(VkSwapchainCreateInfoKHR)*)context.swapchain, &swapchainImageCount, null);
    	if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't get swapchain images!");
    	}

    	
    	context.swapchainImages.length = swapchainImageCount;
    	vulkanResult = fpGetSwapchainImagesKHR(device.value, context.swapchain, &swapchainImageCount, context.swapchainImages.ptr);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't get swapchain images!");
		}
	}
	
	// Get the next available swapchain image
	public final VkResult acquireNextImage(VkSemaphore aquireSemaphore, uint32_t *imageIndexPtr) {
        return fpAcquireNextImageKHR(
            device.value,
            context.swapchain,
            UINT64_MAX,
            aquireSemaphore,
            VK_NULL_HANDLE,
            
            imageIndexPtr
        );
	}
	
	public final VkResult queuePresent(VkQueue presentationQueue, VkSemaphore waitSemaphore, uint32_t imageIndex) {
		 // Submit present operation to present queue
        const VkPresentInfoKHR presentInfo = {
            VK_STRUCTURE_TYPE_PRESENT_INFO_KHR,     // sType
            null,                                   // pNext
            1,                                      // waitSemaphoreCount
            cast(immutable(VkSemaphore)*)&waitSemaphore,            // pWaitSemaphores
            1,                                      // swapchainCount
            cast(immutable(VkSwapchainKHR)*)&context.swapchain,                             // pSwapchains
            cast(immutable(uint32_t)*)&imageIndex,                            // pImageIndices
            null                                    // pResults
        };
        
        return fpQueuePresentKHR(presentationQueue, cast(immutable(VkPresentInfoKHR)*)&presentInfo);
	}
	
	
	public final void shutdown() {
		fpDestroySwapchainKHR(device.value, context.swapchain, null);
	}
}
