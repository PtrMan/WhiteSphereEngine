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


/**
 * alternative implementation of swapchain because I had issues with the other implementation
 * (see the code at the time of the first commit)
 * 
 * almost completly based on
 * https://www.khronos.org/registry/vulkan/specs/1.0-wsi_extensions/xhtml/vkspec.html#_vk_khr_swapchain
 */
class VulkanSwapChain2 {
	private Nullable!VkInstance instance;
	private Nullable!VkDevice device;
	private Nullable!VkPhysicalDevice physicalDevice;
	private Nullable!VkSurfaceKHR surface;
	
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
		VkResult vulkanResult;
		
		vulkanResult = createSurface(platformHandle, platformWindow);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create SwapChain Surface!");
		}

		
		
		
		
		assert(!device.isNull() && !surface.isNull());
		
		// Check the surface properties and formats
	    VkSurfacePropertiesKHR surfaceProperties;
	    /*fpGetSurfacePropertiesKHR*/fpGetPhysicalDeviceSurfaceCapabilitiesKHR(device, surface, &surfaceProperties);
	
	    uint32_t formatCount;
	    fpGetSurfaceFormatsKHR(device, surface, &formatCount, null);
	
	    VkSurfaceFormatKHR* pSurfFormats = cast(VkSurfaceFormatKHR*)malloc(formatCount * VkSurfaceFormatKHR.sizeof);
	    fpGetSurfaceFormatsKHR(device, surface, &formatCount, pSurfFormats);
	
	    uint32_t presentModeCount;
	    fpGetSurfacePresentModesKHR(device, surface, &presentModeCount, null);
	
	    VkPresentModeKHR* pPresentModes = cast(VkPresentModeKHR*)malloc(presentModeCount * VkPresentModeKHR.sizeof);
	    fpGetSurfacePresentModesKHR(device, surface, &presentModeCount, pPresentModes);
	
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
	        surface,                                        // surface
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
	        VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR,             // compositeAlpha
	        swapchainPresentMode,                           // presentMode
	        VK_TRUE,                                        // clipped
	        VK_NULL_HANDLE                                  // oldSwapchain
	    };
	
	    VkSwapchainKHR swapchain;
	    fpCreateSwapchainKHR(device, cast(immutable(VkSwapchainCreateInfoKHR)*)&createInfo, null, &swapchain);
	    
	    
	    
	    
	    
	    /////////////////////////////////////////////////
	    // Obtaining the persistent images of a swapchain
	    /////////////////////////////////////////////////
	    uint32_t swapchainImageCount;
    	fpGetSwapchainImagesKHR(device, cast(immutable(VkSwapchainCreateInfoKHR)*)swapchain, &swapchainImageCount, null);

    	VkImage* pSwapchainImages = cast(VkImage*)malloc(swapchainImageCount * VkImage.sizeof);
    	fpGetSwapchainImagesKHR(device, swapchain, &swapchainImageCount, pSwapchainImages);

	    
	    
	    
	    
	    //////////////////////////////////
	    // simple rendering and presenting
	    //////////////////////////////////
	    // simple rendering nd presenting

	    // Construct command buffers rendering to the presentable images
	    VkCmdBuffer cmdBuffers[swapchainImageCount];
	    VkImageView views[swapchainImageCount];
		
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
	            ///...
	        };
	        vkCreateImageView(device, &viewInfo, &views[i]);
	
	        ///...
	
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
	            pSwapchainImages[i].image,                  // image
	            ///...
	        };
	
	        vkCmdPipelineBarrier(
	            cmdBuffers[i],
	            VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
	            VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
	            VK_FALSE,
	            1,
	            &acquireImageBarrier);
	
	        // ... Render to views[i] ...
	
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
	            pSwapchainImages[i].image,                  // image
	            ///...
	        };
	
	        vkCmdPipelineBarrier(
	            cmdBuffers[i],
	            VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
	            VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT,
	            VK_FALSE,
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
	    vkCreateSemaphore(device,
	                      &semaphoreCreateInfo,
	                      &imageAcquiredSemaphore);
	
	    VkSemaphore renderingCompleteSemaphore;
	    vkCreateSemaphore(device,
	                      &semaphoreCreateInfo,
	                      &renderingCompleteSemaphore);
	
	    VkResult result;
	    do
	    {
	        uint32_t imageIndex = UINT32_MAX;
	
	        // Get the next available swapchain image
	        result = fpAcquireNextImageKHR(
	            device,
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
	            cast(const(immutable(ulong)*))&imageAcquiredSemaphore,                // pWaitSemaphores
	            cast(const(immutable(ulong)*))&waitDstStageMask,                      // pWaitDstStageMasks
	            1,                                      // commandBufferCount
	            &cmdBuffers[imageIndex],                // pCommandBuffers
	            1,                                      // signalSemaphoreCount
	            &renderingCompleteSemaphore             // pSignalSemaphores
	        };
	        vkQueueSubmit(graphicsQueue, 1, &submitInfo, VK_NULL_HANDLE);
	
	        // Submit present operation to present queue
	        const VkPresentInfoKHR presentInfo =
	        {
	            VK_STRUCTURE_TYPE_PRESENT_INFO_KHR,     // sType
	            null,                                   // pNext
	            1,                                      // waitSemaphoreCount
	            &renderingCompleteSemaphore,            // pWaitSemaphores
	            1,                                      // swapchainCount
	            &swapchain,                             // pSwapchains
	            &imageIndex,                            // pImageIndices
	            null                                    // pResults
	        };
	
	        result = pfnQueuePresentKHR(presentQueue, &presentInfo);
	    } while (result >= 0);

	    
	    
	    

	}
	
	private final VkResult createSurface(
		// for windows
		HINSTANCE platformHandle, HWND platformWindow
	) {
		VkResult vulkanResult;
		
		assert(!instance.isNull());
		
		// Create surface depending on OS
		version(Win32) {
		VkWin32SurfaceCreateInfoKHR surfaceCreateInfo;
		surfaceCreateInfo.sType = VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
		surfaceCreateInfo.hinstance = platformHandle;
		surfaceCreateInfo.hwnd = platformWindow;
		vulkanResult = vkCreateWin32SurfaceKHR(instance, &surfaceCreateInfo, null, &surface);
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
