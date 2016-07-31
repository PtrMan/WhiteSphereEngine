module systemEnvironment.ChainContext;

import std.stdint;

import api.vulkan.Vulkan;
import memory.NonGcHandle : NonGcHandle;
import vulkan.VulkanSwapChain;
import vulkan.VulkanDevice;
import vulkan.QueueManager;
import common.LoggerPipe;

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
	
	public LoggerPipe loggerPipe;
	
	struct Vulkan {
		QueueManager queueManager = new QueueManager();
		
		VulkanDevice chosenDevice;
		
		NonGcHandle!VkInstance instance;
		
		NonGcHandle!VkCommandPool cmdPool;
		
		NonGcHandle!VkFormat depthFormatMediumPrecision;
		NonGcHandle!VkFormat depthFormatHighPrecision;
		
		//VkQueue highPriorityQueue, lowPriorityQueue;
		
		
		
		
		// prototyping
			VkRenderPass renderPass;
			
			

			
		// swapchain related
			VulkanSwapChain swapChain = null;
			
			// Active frame buffer index
			uint32_t currentBuffer = 0;
			
			VkCommandBuffer postPresentCmdBuffer;
			VkCommandBuffer setupCmdBuffer;			
			TypedPointerWithLength!VkCommandBuffer drawCmdBuffers;
			TypedPointerWithLength!VkFramebuffer frameBuffers;
	}
	
	public Vulkan vulkan;
}