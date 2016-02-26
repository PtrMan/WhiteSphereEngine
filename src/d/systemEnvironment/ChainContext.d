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
		
		VulkanSwapChain swapChain = null;
		
		NonGcHandle!VkInstance instance;
		
		NonGcHandle!VkCommandPool cmdPool;
	}
	
	public Vulkan vulkan;
}