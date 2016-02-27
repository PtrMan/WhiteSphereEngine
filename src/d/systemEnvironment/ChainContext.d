module systemEnvironment.ChainContext;

import api.vulkan.Vulkan;
import memory.NonGcHandle : NonGcHandle;
import vulkan.VulkanSwapChain;
import vulkan.VulkanDevice;

// context which is passed between all chain functions for exchainging configuration information
class ChainContext {
	struct Window {
		public string caption;
		public uint width;
		public uint height;
	}
	public Window window;
	
	version(Win32) {
		import  core.sys.windows.windows;
		
		struct WindowsContext {
			public HINSTANCE hInstance;
			public HWND hwnd;
		}
		
		WindowsContext windowsContext;
	}
	
	struct Vulkan {
		VulkanDevice chosenDevice;
		
		NonGcHandle!VkInstance instance;
		
		NonGcHandle!VkCommandPool cmdPool;
		
		NonGcHandle!VkFormat depthFormatMediumPrecision;
		NonGcHandle!VkFormat depthFormatHighPrecision;
		
		VkQueue highPriorityQueue, lowPriorityQueue;
		
		
		
		
		// prototyping
			VkRenderPass renderPass;
			
			

			
		// swapchain related
			VulkanSwapChain swapChain = null;
			
			VkCommandBuffer setupCmdBuffer;			
			TypedPointerWithLength!VkCommandBuffer drawCmdBuffers;
			TypedPointerWithLength!VkFramebuffer frameBuffers;
	}
	
	public Vulkan vulkan;
}