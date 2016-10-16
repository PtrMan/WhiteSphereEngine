
import systemEnvironment.EnvironmentChain;
import systemEnvironment.Vulkan;
import systemEnvironment.Window;
import systemEnvironment.ChainContext;
import systemEnvironment.Logging;
import systemEnvironment.Engine;

import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import vulkan.VulkanDevice;
import vulkan.VulkanTools;
import whiteSphereEngine.graphics.vulkan.VulkanSwapChain;

import std.stdint;


//int myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
void main(string[] args) {
	// for tracing down possible bugs
	import core.memory : GC;
	GC.disable();
	
	
	ChainContext chainContext = new ChainContext();
	chainContext.window.caption = "PtrEngine Demo1";
	chainContext.window.width = 800;
	chainContext.window.height = 600;
	version(Win32) {
		import core.sys.windows.windows;
		
		// this is not 100% clean but we grab the hInstance from the system and set it
		// see http://stackoverflow.com/questions/1749972/determine-the-current-hinstance
		// NOTE< propably doesn't work if we create a opengl context >
		chainContext.windowsContext.hInstance = GetModuleHandleA(null);
	}
	
	ChainElement[] chainElements;
	chainElements ~= new ChainElement(&platformLogging);
	chainElements ~= new ChainElement(&platformWindow);
	chainElements ~= new ChainElement(&platformVulkan1Libary);
	chainElements ~= new ChainElement(&platformVulkan2DeviceBase);
	chainElements ~= new ChainElement(&platformVulkan3SwapChain);
	chainElements ~= new ChainElement(&platformVulkanTestSwapChain);
	chainElements ~= new ChainElement(&systemEnvironmentEngineEntry);
	
	processChain(chainElements, chainContext);

    //return 1;
}
