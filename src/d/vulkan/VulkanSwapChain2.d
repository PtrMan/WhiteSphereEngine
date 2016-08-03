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
import Exceptions;

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



import helpers.VariableValidator;

/**
 * alternative implementation of swapchain because I had issues with the other implementation
 * (see the code at the time of the first commit)
 * 
 * almost completly based on
 * https://www.khronos.org/registry/vulkan/specs/1.0-wsi_extensions/xhtml/vkspec.html#_vk_khr_swapchain
 */
class VulkanSwapChain2 {
	private VariableValidator!VkSurfaceKHR surface;
	private VariableValidator!VkInstance instance;
	private VariableValidator!VkDevice device;
	private VariableValidator!VkPhysicalDevice physicalDevice;
	private VariableValidator!VkCommandPool commandPool;
	
	// Function pointers
	private PFN_vkCreateSwapchainKHR fpCreateSwapchainKHR;
	private PFN_vkDestroySwapchainKHR fpDestroySwapchainKHR;
	private PFN_vkGetSwapchainImagesKHR fpGetSwapchainImagesKHR;
	private PFN_vkAcquireNextImageKHR fpAcquireNextImageKHR;
	private PFN_vkQueuePresentKHR fpQueuePresentKHR;
	
	
	// Connect to the instance und device and get all required function pointers
	public final void connect(VkInstance instance, VkPhysicalDevice physicalDevice, VkDevice device, VkCommandPool commandPool) {
		this.instance = instance;
		this.physicalDevice = physicalDevice;
		this.device = device;
		this.commandPool = commandPool;
		
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
		const string ERROR_COULDNT_PHYSICAL_DEVICE_FORMATS = "Couldn't get physical device surface formats!";
		const string ERROR_COULDNT_PHYSICAL_DEVICE_PRESENTATION = "Couldn't get physical device present modes!";
		
		VkResult vulkanResult;

		surface.invalidate();
		
		import core.memory : GC;

		import vulkan.VulkanTools;

		vulkanResult = createSurface(platformHandle, platformWindow);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create SwapChain Surface!");
		}

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
	    uint32_t desiredNumberOfSwapchainImages = cast(uint32_t)getSwapChainNumImages(numberOfImagesToOwnRequest);
		
	    {
	    	import std.stdio;
	    	writeln("desiredNumberOfSwapchainImages ", desiredNumberOfSwapchainImages);
	    }
	
	    VkFormat swapchainFormat;
	    VkColorSpaceKHR swapchainColorSpace;
	    // If the format list includes just one entry of VK_FORMAT_UNDEFINED,
	    // the surface has no preferred format.  Otherwise, at least one
	    // supported format will be returned (assuming that the
	    // vkGetPhysicalDeviceSurfaceSupportKHR function, in the
	    // VK_KHR_surface extension returned support for the surface).
	    if ((formatCount == 1) && (surfaceFormats[0].format == VK_FORMAT_UNDEFINED)) {
	        swapchainFormat = VK_FORMAT_R8G8B8_UNORM;
	        swapchainColorSpace = VK_COLORSPACE_SRGB_NONLINEAR_KHR;
	    }
	    else {
	        assert(formatCount >= 1);
	        swapchainFormat = surfaceFormats[0].format;
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
	    
	
	    VkSwapchainKHR swapchain;
	    vulkanResult = fpCreateSwapchainKHR(device.value, cast(immutable(VkSwapchainCreateInfoKHR)*)&createInfo, null, &swapchain);
	    if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create swapchain!");
    	}
	    
	    
	    
	    
	    /////////////////////////////////////////////////
	    // Obtaining the persistent images of a swapchain
	    /////////////////////////////////////////////////
	    uint32_t swapchainImageCount;
    	vulkanResult = fpGetSwapchainImagesKHR(device.value, cast(immutable(VkSwapchainCreateInfoKHR)*)swapchain, &swapchainImageCount, null);
    	if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't get swapchain images!");
    	}

    	VkImage* pSwapchainImages = cast(VkImage*)malloc(swapchainImageCount * VkImage.sizeof);
    	vulkanResult = fpGetSwapchainImagesKHR(device.value, swapchain, &swapchainImageCount, pSwapchainImages);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't get swapchain images!");
		}
	    
	    
	    
	    
	    //////////////////////////////////
	    // simple rendering and presenting
	    //////////////////////////////////

	    // Construct command buffers rendering to the presentable images
	    VkCommandBuffer[] cmdBuffers;
	    VkImageView[] views;
	    
	    cmdBuffers.length = swapchainImageCount;
	    views.length = swapchainImageCount;
	    
	    
    	// Allow a maximum of two outstanding presentation operations.
	    const int FRAME_LAG = 2;
	    
	    VkFence[FRAME_LAG] fences;
    	bool[FRAME_LAG] fencesInited;
    	int frameIdx = 0;
    	int imageIdx = 0;
    	int waitFrame;
    	
    	void createFences(VkDevice device, out VkFence[FRAME_LAG] fences) {
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

    	createFences(device.value, fences);
		
	    // create command buffers
	    for (size_t i = 0; i < swapchainImageCount; ++i) {
			VkCommandBufferAllocateInfo commandBufferAllocationInfo;
			initCommandBufferAllocateInfo(&commandBufferAllocationInfo);
			with( commandBufferAllocationInfo ) {
				level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
				commandBufferCount = 1; // we just want to allocate one command buffer in the target array
			}
			commandBufferAllocationInfo.commandPool = commandPool.value;
			
			// SYNC : this needs to be host synced with a mutex
			vulkanResult = vkAllocateCommandBuffers(
				device.value,
				&commandBufferAllocationInfo,
				&cmdBuffers[i]
			);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, vulkan.Messages.COULDNT_COMMAND_BUFFER);
			}
	    }
	    
	    // see hack #0000
	    VkFence additionalFence;
	    {
	    	VkFenceCreateInfo fenceCreateInfo;
    		initFenceCreateInfo(&fenceCreateInfo);
    		fenceCreateInfo.flags = 0;
    		
    		vulkanResult = vkCreateFence(
				device.value,
				&fenceCreateInfo,
				null,
				&additionalFence);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't create fences!");
			}
		
	    }
	    
		
	    for (size_t i = 0; i < swapchainImageCount; ++i) {
	        const VkImageViewCreateInfo viewInfo = {
	            VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,   // sType
	            null,                                       // pNext
	            0,                                          // flags
	            pSwapchainImages[i],                        // image
	            VK_IMAGE_VIEW_TYPE_2D,                      // viewType
	            swapchainFormat,                            // format
	            {VK_COMPONENT_SWIZZLE_R, VK_COMPONENT_SWIZZLE_G, VK_COMPONENT_SWIZZLE_B, VK_COMPONENT_SWIZZLE_A}, // components
	            {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1}// subresourceRange
	        };
	        vulkanResult = vkCreateImageView(device.value, &viewInfo, null, &views[i]);
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
	        
	        VkImageMemoryBarrier barrier_from_present_to_clear;
	        with (barrier_from_present_to_clear) {
	        	sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
		        pNext = null;
		        srcAccessMask = VK_ACCESS_MEMORY_READ_BIT;
			    dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
		        oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
		        newLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
		        srcQueueFamilyIndex = presentQueueFamilyIndex; // after the code its the present queue, could be another queue, TODO< check >
		        dstQueueFamilyIndex = presentQueueFamilyIndex; // after the code its the present queue, could be another queue, TODO< check >
		        image = pSwapchainImages[i];
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
		        srcQueueFamilyIndex = presentQueueFamilyIndex; // after the code its the present queue, could be another queue, TODO< check >
		        dstQueueFamilyIndex = presentQueueFamilyIndex; // after the code its the present queue, could be another queue, TODO< check >
		        image = pSwapchainImages[i];
		        subresourceRange = image_subresource_range;	
	        }
 
			vkBeginCommandBuffer(cmdBuffers[i], &cmd_buffer_begin_info );
			vkCmdPipelineBarrier(cmdBuffers[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT, 0, 0, null, 0, null, 1, &barrier_from_present_to_clear);
			vkCmdClearColorImage(cmdBuffers[i], pSwapchainImages[i], VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, &clear_color, 1, &image_subresource_range);
			vkCmdPipelineBarrier(cmdBuffers[i], VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0, 0, null, 0, null, 1, &barrier_from_clear_to_present);
			
			vulkanResult = vkEndCommandBuffer(cmdBuffers[i]);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Couldn't end command buffer [vkEndCommandBuffer]!");
			}
	    }
		
		// we need a pair of semaphores for each image we display
		struct SemaphorePair {
			VkSemaphore imageAcquiredSemaphore;
			VkSemaphore chainSemaphore;
			VkSemaphore renderingCompleteSemaphore;
		}
		
		SemaphorePair[] semaphorePairs;
		semaphorePairs.length = desiredNumberOfSwapchainImages;
		
	    const VkSemaphoreCreateInfo semaphoreCreateInfo = {
	        VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,    // sType
	        null,                                       // pNext
	        0                                           // flags
	    };
		
		for( uint i = 0; i < semaphorePairs.length; i++ ) {
			VkResult vulkanResults[3];
			
			vulkanResults[0] = vkCreateSemaphore(device.value,
	                      &semaphoreCreateInfo, null,
	                      &semaphorePairs[i].imageAcquiredSemaphore);
	    	
	    	vulkanResults[1] = vkCreateSemaphore(device.value,
	                      &semaphoreCreateInfo, null,
	                      &semaphorePairs[i].chainSemaphore);
	    	
	    	vulkanResults[2] = vkCreateSemaphore(device.value,
	                      &semaphoreCreateInfo, null,
	                      &semaphorePairs[i].renderingCompleteSemaphore);
		    
		    if( !vulkanSuccess(vulkanResults[0]) || !vulkanSuccess(vulkanResults[1]) || !vulkanSuccess(vulkanResults[2]) ) {
				throw new EngineException(true, true, "Couldn't create semaphore [vkCreateSemaphore]!");		    	
		    }
		}
		
		uint semaphorePairIndex = 0;	
		
		
	    VkResult result;
	    do {
	        uint32_t imageIndex = UINT32_MAX;
	
	        // Get the next available swapchain image
	        result = fpAcquireNextImageKHR(
	            device.value,
	            swapchain,
	            UINT64_MAX,
	            semaphorePairs[semaphorePairIndex].imageAcquiredSemaphore,
	            VK_NULL_HANDLE,
	            
	            &imageIndex);
	        
	
	        // Swapchain cannot be used for presentation if failed to acquired new image.
	        if (result < 0) {
	        	break;
	        }
	        
	        {
	        	immutable VkPipelineStageFlags waitDstStageMask = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
	        	VkSubmitInfo submitInfo;
	        	initSubmitInfo(&submitInfo);
	        	with (submitInfo) {
	        		waitSemaphoreCount = 1;
		        	pWaitSemaphores = cast(const(immutable(VkSemaphore)*))&semaphorePairs[semaphorePairIndex].imageAcquiredSemaphore;
		        	pWaitDstStageMask = cast(immutable(VkPipelineStageFlags)*)&waitDstStageMask;
		        	signalSemaphoreCount = 1;
		        	pSignalSemaphores = cast(const(immutable(VkSemaphore)*))&semaphorePairs[semaphorePairIndex].chainSemaphore;
	        	}
	        	
	        	vulkanResult = vkQueueSubmit(presentQueue, 1, &submitInfo, additionalFence);
				if( !vulkanSuccess(vulkanResult) ) {
					throw new EngineException(true, true, "Queue submit failed! (2)");
				}
	        }
			vulkanResult = vkWaitForFences(device.value, 1, &additionalFence, VK_TRUE, UINT64_MAX);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Wait for fences failed!");
			}
			vulkanResult = vkResetFences(device.value, 1, &additionalFence);
	        if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Fence reset failed!");
			}

	        
	            
	
	        // Submit rendering work to the graphics queue
	        const VkPipelineStageFlags waitDstStageMask = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
	        VkSubmitInfo submitInfo;
	        initSubmitInfo(&submitInfo);
	        with (submitInfo) {
	            waitSemaphoreCount = 1;
	            pWaitSemaphores = cast(const(immutable(VkSemaphore)*))&semaphorePairs[semaphorePairIndex].chainSemaphore;
	            pWaitDstStageMask = cast(const(immutable(VkPipelineStageFlags)*))&waitDstStageMask;
	            commandBufferCount = 1;
	            pCommandBuffers = cast(immutable(VkCommandBuffer)*)&cmdBuffers[imageIndex];
	            signalSemaphoreCount = 1;
	            pSignalSemaphores = cast(immutable(VkSemaphore)*)&semaphorePairs[semaphorePairIndex].renderingCompleteSemaphore;
	        }
	        
	        vulkanResult = vkQueueSubmit(graphicsQueue, 1, &submitInfo, additionalFence);
	        if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Queue submit failed! (3)");
			}
	    	
	    	vulkanResult = vkWaitForFences(device.value, 1, &additionalFence, VK_TRUE, UINT64_MAX);
			if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Wait for fences failed!");
			}
			vulkanResult = vkResetFences(device.value, 1, &additionalFence);
	        if( !vulkanSuccess(vulkanResult) ) {
				throw new EngineException(true, true, "Fence reset failed!");
			}

	        
	        
	        // Submit present operation to present queue
	        const VkPresentInfoKHR presentInfo = {
	            VK_STRUCTURE_TYPE_PRESENT_INFO_KHR,     // sType
	            null,                                   // pNext
	            1,                                      // waitSemaphoreCount
	            cast(immutable(VkSemaphore)*)&semaphorePairs[semaphorePairIndex].renderingCompleteSemaphore,            // pWaitSemaphores
	            1,                                      // swapchainCount
	            cast(immutable(VkSwapchainKHR)*)&swapchain,                             // pSwapchains
	            cast(immutable(uint32_t)*)&imageIndex,                            // pImageIndices
	            null                                    // pResults
	        };
	        
	        result = fpQueuePresentKHR(presentQueue, cast(immutable(VkPresentInfoKHR)*)&presentInfo);
	        
	        
	        semaphorePairIndex = (semaphorePairIndex+1) % semaphorePairs.length;
	        
	    } while (result >= 0);
	}
	
	private final VkResult createSurface(
		// for windows
		HINSTANCE platformHandle, HWND platformWindow
	) {
		VkResult vulkanResult;
		
		assert(!surface.isValid);
		
		// Create surface depending on OS
		version(Win32) {
		VkWin32SurfaceCreateInfoKHR surfaceCreateInfo;
		VkSurfaceKHR surface;
		surfaceCreateInfo.sType = VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
		surfaceCreateInfo.hinstance = platformHandle;
		surfaceCreateInfo.hwnd = platformWindow;
		vulkanResult = vkCreateWin32SurfaceKHR(instance.value, cast(const(VkWin32SurfaceCreateInfoKHR*))&surfaceCreateInfo, null, &surface);
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
		
		this.surface = surface;
		
		return vulkanResult;
	}
}
