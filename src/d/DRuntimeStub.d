module DRuntimeStub;

import core.runtime;

extern (C++) void initDRuntime() nothrow{
    try
    {
        Runtime.initialize();
        //result = myWinMain(hInstance, hPrevInstance, lpCmdLine, iCmdShow);
        //Runtime.terminate(&exceptionHandler);
    }
    catch (Throwable o)
    {
        //MessageBox(null, o.toString().toUTF16z, "Error", MB_OK | MB_ICONEXCLAMATION);
        //result = 0;
    }
}