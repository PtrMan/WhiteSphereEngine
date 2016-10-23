module systemEnvironment.ChainContext;

import common.LoggerPipe;
import whiteSphereEngine.graphics.vulkan.VulkanContext;

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
	
	public VulkanContext vulkan = new VulkanContext();
}
