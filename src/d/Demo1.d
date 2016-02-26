import core.runtime;
import core.sys.windows.windows;
import std.string;

extern (Windows)
int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
            LPSTR lpCmdLine, int nCmdShow)
{
    int result;
 
    try
    {
        Runtime.initialize();
        result = myWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);
        Runtime.terminate();
    }
    catch (Throwable e) 
    {
        //MessageBoxA(null, e.toString().toStringz(), "Error",
        //            MB_OK | MB_ICONEXCLAMATION);
        result = 0;     // failed
    }
 
    return result;
}


import systemEnvironment.EnvironmentChain;
import systemEnvironment.Vulkan;
import systemEnvironment.Window;
import systemEnvironment.ChainContext;

void innerFunction(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	import std.stdio;
	
	writeln("INNER");
}

int myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	ChainContext chainContext = new ChainContext();
	chainContext.window.caption = "PtrEngine Demo1";
	chainContext.window.width = 800;
	chainContext.window.height = 600;
	
	ChainElement[] chainElements;
	chainElements ~= new ChainElement(&platformWindow);
	chainElements ~= new ChainElement(&platformVulkan1Libary);
	chainElements ~= new ChainElement(&platformVulkan2DeviceBase);
	chainElements ~= new ChainElement(&platformVulkan3SwapChain);
	chainElements ~= new ChainElement(&innerFunction);
	processChain(chainElements, chainContext);

    return 1;
}
