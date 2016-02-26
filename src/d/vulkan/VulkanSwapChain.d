module vulkan.VulkanSwapChain;

version(Win32) {
	import core.sys.windows.windows;
}
import std.stdint;

import api.vulkan.Vulkan;
import vulkan.VulkanPlatform;
import vulkan.VulkanHelpers;
static import vulkan.VulkanTools;
import TypedPointerWithLength : TypedPointerWithLength;
import Exceptions;

// based on https://github.com/SaschaWillems/Vulkan/blob/master/base/vulkanswapchain.hpp
// which is under MIT license


// Macro to get a procedure address based on a vulkan instance
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

struct SwapChainBuffer {
	VkImage image;
	VkImageView view;
}

class VulkanSwapChain {
	private VkInstance instance;
	private VkDevice device;
	private VkPhysicalDevice physicalDevice;
	private VkSurfaceKHR surface;
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

	public VkFormat colorFormat;
	public VkColorSpaceKHR colorSpace;

	public VkSwapchainKHR swapChain = VK_NULL_HANDLE;

	public uint32_t imageCount;
	public TypedPointerWithLength!VkImage images;
	public TypedPointerWithLength!SwapChainBuffer buffers;

	// Index of the deteced graphics and presenting device queue
	public uint32_t queueNodeIndex = UINT32_MAX;

	// Creates an os specific surface
	// Tries to find a graphics and a present queue
	void initSurface(
//version(Win32) { // #ifdef _WIN32
		HINSTANCE platformHandle, HWND platformWindow
//}
//version(Linux) {
//#ifdef __ANDROID__
//		ANativeWindow* window
//#else
//		xcb_connection_t* connection, xcb_window_t window
//#endif
//}
	)
	{
		VkResult vulkanResult;
		
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
		
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create SwapChain Surface!");
		}
		
		// Get available queue family properties
		uint32_t queueCount;
		vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueCount, null);
		assert(queueCount >= 1);
		
		TypedPointerWithLength!VkQueueFamilyProperties queueProps = TypedPointerWithLength!VkQueueFamilyProperties.allocate(queueCount);
		scope(exit) queueProps.dispose();
		vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, &queueCount, queueProps.ptr);

		// Iterate over each queue to learn whether it supports presenting:
		// Find a queue with present support
		// Will be used to present the swap chain images to the windowing system
		TypedPointerWithLength!VkBool32 supportsPresent = TypedPointerWithLength!VkBool32.allocate(queueCount);
		scope(exit) supportsPresent.dispose();
		for (uint32_t i = 0; i < queueCount; i++) {
			fpGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, i, surface, &supportsPresent.ptr[i]);
		}

		// Search for a graphics and a present queue in the array of queue
		// families, try to find one that supports both
		uint32_t graphicsQueueNodeIndex = UINT32_MAX;
		uint32_t presentQueueNodeIndex = UINT32_MAX;
		for (uint32_t i = 0; i < queueCount; i++) {
			if ((queueProps[i].queueFlags & VK_QUEUE_GRAPHICS_BIT) != 0) {
				if (graphicsQueueNodeIndex == UINT32_MAX) {
					graphicsQueueNodeIndex = i;
				}

				if (supportsPresent[i] == VK_TRUE) {
					graphicsQueueNodeIndex = i;
					presentQueueNodeIndex = i;
					break;
				}
			}
		}
		
		if (presentQueueNodeIndex == UINT32_MAX) {	
			// If there's no queue that supports both present and graphics
			// try to find a separate present queue
			for (uint32_t i = 0; i < queueCount; ++i) {
				if (supportsPresent[i] == VK_TRUE) {
					presentQueueNodeIndex = i;
					break;
				}
			}
		}

		// Exit if either a graphics or a presenting queue hasn't been found
		if (graphicsQueueNodeIndex == UINT32_MAX || presentQueueNodeIndex == UINT32_MAX) {
			throw new EngineException(true, true, "Could not find a graphics and/or presenting queue!");

		}

		// todo : Add support for separate graphics and presenting queue
		if (graphicsQueueNodeIndex != presentQueueNodeIndex) {
			throw new EngineException(true, true, "Separate graphics and presenting queues are not supported yet!");
		}

		queueNodeIndex = graphicsQueueNodeIndex;

		// Get list of supported surface formats
		const string errorMessagePhysicalDeviceSurfaces = "Couldn't get physical device surface formats for SwapChain!";
		
		uint32_t formatCount;
		vulkanResult = fpGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &formatCount, null);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, errorMessagePhysicalDeviceSurfaces);
		}
		
		assert(formatCount > 0);

		TypedPointerWithLength!VkSurfaceFormatKHR surfaceFormats = TypedPointerWithLength!VkSurfaceFormatKHR.allocate(formatCount);
		scope(exit) surfaceFormats.dispose();
		vulkanResult = fpGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, &formatCount, surfaceFormats.ptr);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, errorMessagePhysicalDeviceSurfaces);
		}
		
		// If the surface format list only includes one entry with VK_FORMAT_UNDEFINED,
		// there is no preferered format, so we assume VK_FORMAT_B8G8R8A8_UNORM
		if ((formatCount == 1) && (surfaceFormats[0].format == VK_FORMAT_UNDEFINED)) {
			colorFormat = VK_FORMAT_B8G8R8A8_UNORM;
		}
		else {
			// Always select the first available color format
			// If you need a specific format (e.g. SRGB) you'd need to
			// iterate over the list of available surface format and
			// check for it's presence
			colorFormat = surfaceFormats[0].format;
		}
		colorSpace = surfaceFormats[0].colorSpace;
	}
	
	
	// Connect to the instance und device and get all required function pointers
	void connect(VkInstance instance, VkPhysicalDevice physicalDevice, VkDevice device) {
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
	
	

	// Create the swap chain and get images with given width and height
	void create(VkCommandBuffer cmdBuffer, uint32_t *width, uint32_t *height) {
		VkResult vulkanResult;
		VkSwapchainKHR oldSwapchain = swapChain;

		// Get physical device surface properties and formats
		VkSurfaceCapabilitiesKHR surfCaps;
		vulkanResult = fpGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, &surfCaps);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't get physical device surface capabilities!");
		}
		
		// Get available present modes
		const string errorMessagePhysicalDeviceSurfacePresentModes = "Couldn't get physical device surface present modes!";
		
		uint32_t presentModeCount;
		vulkanResult = fpGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &presentModeCount, null);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, errorMessagePhysicalDeviceSurfacePresentModes);
		}
		assert(presentModeCount > 0);

		TypedPointerWithLength!VkPresentModeKHR presentModes = TypedPointerWithLength!VkPresentModeKHR.allocate(presentModeCount);
		scope(exit) presentModes.dispose();
		
		vulkanResult = fpGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, &presentModeCount, presentModes.ptr);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, errorMessagePhysicalDeviceSurfacePresentModes);
		}

		VkExtent2D swapchainExtent;
		// width and height are either both -1, or both not -1.
		if (surfCaps.currentExtent.width == -1) {
			// If the surface size is undefined, the size is set to
			// the size of the images requested.
			swapchainExtent.width = *width;
			swapchainExtent.height = *height;
		}
		else {
			// If the surface size is defined, the swap chain size must match
			swapchainExtent = surfCaps.currentExtent;
			*width = surfCaps.currentExtent.width;
			*height = surfCaps.currentExtent.height;
		}

		// Prefer mailbox mode if present, it's the lowest latency non-tearing present  mode
		VkPresentModeKHR swapchainPresentMode = VK_PRESENT_MODE_FIFO_KHR;
		for (size_t i = 0; i < presentModeCount; i++) {
			if (presentModes[i] == VK_PRESENT_MODE_MAILBOX_KHR) {
				swapchainPresentMode = VK_PRESENT_MODE_MAILBOX_KHR;
				break;
			}
			if ((swapchainPresentMode != VK_PRESENT_MODE_MAILBOX_KHR) && (presentModes[i] == VK_PRESENT_MODE_IMMEDIATE_KHR)) {
				swapchainPresentMode = VK_PRESENT_MODE_IMMEDIATE_KHR;
			}
		}

		// Determine the number of images
		uint32_t desiredNumberOfSwapchainImages = surfCaps.minImageCount + 1;
		if ((surfCaps.maxImageCount > 0) && (desiredNumberOfSwapchainImages > surfCaps.maxImageCount)) {
			desiredNumberOfSwapchainImages = surfCaps.maxImageCount;
		}

		VkSurfaceTransformFlagsKHR preTransform;
		if (surfCaps.supportedTransforms & VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR) {
			preTransform = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR;
		}
		else {
			preTransform = surfCaps.currentTransform;
		}

		VkSwapchainCreateInfoKHR swapchainCI;
		swapchainCI.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
		swapchainCI.pNext = null;
		swapchainCI.surface = surface;
		swapchainCI.minImageCount = desiredNumberOfSwapchainImages;
		swapchainCI.imageFormat = colorFormat;
		swapchainCI.imageColorSpace = colorSpace;
		swapchainCI.imageExtent.width = swapchainExtent.width;
		swapchainCI.imageExtent.height = swapchainExtent.height;
		swapchainCI.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
		swapchainCI.preTransform = cast(VkSurfaceTransformFlagBitsKHR)preTransform;
		swapchainCI.imageArrayLayers = 1;
		swapchainCI.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
		swapchainCI.queueFamilyIndexCount = 0;
		swapchainCI.pQueueFamilyIndices = null;
		swapchainCI.presentMode = swapchainPresentMode;
		swapchainCI.oldSwapchain = oldSwapchain;
		swapchainCI.clipped = true;
		swapchainCI.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;

		vulkanResult = fpCreateSwapchainKHR(device, cast(immutable(VkSwapchainCreateInfoKHR)*)&swapchainCI, null, &swapChain);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Couldn't create swapchain!");
		}

		// If an existing sawp chain is re-created, destroy the old swap chain
		// This also cleans up all the presentable images
		if (oldSwapchain != VK_NULL_HANDLE) {
			fpDestroySwapchainKHR(device, oldSwapchain, null);
		}
		
		const string errorMessageGetSwapchainImages = "Couldn't get swapchain images!";

		vulkanResult = fpGetSwapchainImagesKHR(device, swapChain, &imageCount, null);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, errorMessageGetSwapchainImages);
		}

		// Get the swap chain images
		
		assert(images is null);
		images = TypedPointerWithLength!VkImage.allocate(imageCount);
		
		vulkanResult = fpGetSwapchainImagesKHR(device, swapChain, &imageCount, images.ptr);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, errorMessageGetSwapchainImages);
		}

		// Get the swap chain buffers containing the image and imageview
		assert(buffers is null);
		buffers = TypedPointerWithLength!SwapChainBuffer.allocate(imageCount);
		
		for (uint32_t i = 0; i < imageCount; i++) {
			VkImageViewCreateInfo colorAttachmentView;
			colorAttachmentView.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
			colorAttachmentView.pNext = null;
			colorAttachmentView.format = colorFormat;
			colorAttachmentView.components.r = VK_COMPONENT_SWIZZLE_R;
			colorAttachmentView.components.g = VK_COMPONENT_SWIZZLE_G;
			colorAttachmentView.components.b = VK_COMPONENT_SWIZZLE_B;
			colorAttachmentView.components.a = VK_COMPONENT_SWIZZLE_A;
			colorAttachmentView.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
			colorAttachmentView.subresourceRange.baseMipLevel = 0;
			colorAttachmentView.subresourceRange.levelCount = 1;
			colorAttachmentView.subresourceRange.baseArrayLayer = 0;
			colorAttachmentView.subresourceRange.layerCount = 1;
			colorAttachmentView.viewType = VK_IMAGE_VIEW_TYPE_2D;
			colorAttachmentView.flags = 0;

			buffers.ptr[i].image = images[i];

			// Transform images from initial (undefined) to present layout
			vulkan.VulkanTools.setImageLayout(
				cmdBuffer,
				buffers.ptr[i].image,
				VK_IMAGE_ASPECT_COLOR_BIT,
				VK_IMAGE_LAYOUT_UNDEFINED,
				VK_IMAGE_LAYOUT_PRESENT_SRC_KHR
			);
			
			colorAttachmentView.image = buffers.ptr[i].image;

			vulkanResult = vkCreateImageView(device, &colorAttachmentView, null, &buffers.ptr[i].view);
			if( !vulkanSuccess(vulkanResult) ) {
				import std.stdio;
				writeln(vulkanResult);
				
				throw new EngineException(true, true, "Couldn't create image view!");
			}
		}
	}

	// Acquires the next image in the swap chain
	VkResult acquireNextImage(VkSemaphore presentCompleteSemaphore, uint32_t *currentBuffer) {
		return fpAcquireNextImageKHR(device, swapChain, UINT64_MAX, presentCompleteSemaphore, cast(VkFence)null, currentBuffer);
	}

	// Present the current image to the queue
	VkResult queuePresent(VkQueue queue, uint32_t currentBuffer) {
		VkPresentInfoKHR presentInfo;
		presentInfo.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
		presentInfo.pNext = null;
		presentInfo.swapchainCount = 1;
		presentInfo.pSwapchains = cast(immutable(ulong)*)&swapChain;
		presentInfo.pImageIndices = cast(immutable(uint)*)&currentBuffer;
		return fpQueuePresentKHR(queue, cast(immutable(VkPresentInfoKHR)*)&presentInfo);
	}

	// Free all Vulkan resources used by the swap chain
	// TODO< reame to dispose and implement IDisposable >
	void cleanup() {
		for (uint32_t i = 0; i < imageCount; i++) {
			vkDestroyImageView(device, buffers.ptr[i].view, null);
			buffers.ptr[i].view = 0;
		}
		fpDestroySwapchainKHR(device, swapChain, null);
		vkDestroySurfaceKHR(instance, surface, null);
		
		if( images !is null ) {
			images.dispose();
			images = null;
		}
		
		if( buffers !is null ) {
			buffers.dispose();
			buffers = null;
		}
	}
}
