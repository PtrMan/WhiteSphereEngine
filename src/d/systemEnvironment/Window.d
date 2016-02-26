module systemEnvironment.Window;

version(Win32) {
	import core.sys.windows.windows;
}

import systemEnvironment.EnvironmentChain;
import systemEnvironment.ChainContext;
import Exceptions;



/**
 * initializes and opens a window, closes it and destructs if application exists
 */

public void platformWindow(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	initializeWindow(chainContext);
	scope(exit) destroyWindow(chainContext);
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
}

version(Win32) {	
	private extern(Windows) nothrow
	LRESULT WndProc(HWND Hwnd, UINT Message, WPARAM WParam, LPARAM LParam) {
	   switch (Message) {
	      case WM_DESTROY:
	      PostQuitMessage (0);
	      break;
	
	      default:
	      break;
	   }
	
	   return DefWindowProcA(Hwnd, Message, WParam, LParam);
	}
}

private void initializeWindow(ChainContext chainContext) {
	version(Win32) {	
		import std.string : toStringz;
		import core.stdc.string : memset;
		
		// this is not 100% clean but we grab the hInstance from the system and set it
		// see http://stackoverflow.com/questions/1749972/determine-the-current-hinstance
		// NOTE< propably doesn't work if we create a opengl context >
		//chainContext.windowsContext.hInstance = GetModuleHandleA(null);
		
		string ClassName = "PtrEngine";
	   	string WindowCaption = chainContext.window.caption;
		
		WNDCLASSA Wnd;
		//MSG Msg;
		//bool CalleeSuccess;
		//string ErrorMessage;
		
		memset(&Wnd, 0, WNDCLASSA.sizeof);
		Wnd.style = CS_HREDRAW | CS_VREDRAW; // | CS_OWNDC; // CS_OWNDC
		Wnd.lpfnWndProc = &WndProc;
		Wnd.hInstance =  chainContext.windowsContext.hInstance;
		Wnd.hIcon = LoadIconW( null, IDI_APPLICATION );
		Wnd.hCursor = LoadCursorW( null, IDC_ARROW );
		Wnd.hbrBackground = cast(HBRUSH)GetStockObject( BLACK_BRUSH );
		Wnd.lpszClassName = cast(LPCSTR)ClassName.toStringz;
		
		ATOM ResultAtom = RegisterClassA(&Wnd);
		if (!ResultAtom) {
			throw new EngineException(true, true, "RegisterClassA() failed!");
		}
		
		/*chainContext.windowsContext.hwnd = CreateWindowA( 
		      cast(LPCSTR)ClassName.toStringz,
		      cast(LPCSTR)ClassName.toStringz,
		      WS_OVERLAPPEDWINDOW | WS_CLIPSIBLINGS | WS_CLIPCHILDREN,//WS_CAPTION | WS_POPUPWINDOW | WS_VISIBLE | WS_CLIPCHILDREN | WS_CLIPSIBLINGS ,
		      0, 0, chainContext.window.width, chainContext.window.height,
		      null, null, chainContext.windowsContext.hInstance, null
		);*/
		int screenWidth = GetSystemMetrics(SM_CXSCREEN);
	int screenHeight = GetSystemMetrics(SM_CYSCREEN);

		
	DWORD dwExStyle = 0;
	DWORD dwStyle = 0;
	
	RECT windowRect;
	//if (fullscreen)
	//{
	//	windowRect.left = (long)0;
	//	windowRect.right = (long)screenWidth;
	//	windowRect.top = (long)0;
	//	windowRect.bottom = (long)screenHeight;
	//}
	//else
	{
		windowRect.left = screenWidth / 2 - chainContext.window.width / 2;
		windowRect.right = chainContext.window.width;
		windowRect.top = screenHeight / 2 - chainContext.window.height / 2;
		windowRect.bottom = chainContext.window.height;
	}

	AdjustWindowRectEx(&windowRect, dwStyle, FALSE, dwExStyle);

		
		chainContext.windowsContext.hwnd = CreateWindowExA(0,
		cast(LPCSTR)ClassName.toStringz,
		cast(LPCSTR)ClassName.toStringz,
		//		WS_OVERLAPPEDWINDOW | WS_VISIBLE | WS_SYSMENU,
		dwStyle | WS_CLIPSIBLINGS | WS_CLIPCHILDREN,
		windowRect.left,
		windowRect.top,
		windowRect.right,
		windowRect.bottom,
		null,
		null,
		chainContext.windowsContext.hInstance,
		null);
		
		if( chainContext.windowsContext.hwnd is null) {
			throw new EngineException(true, true, "Failed to create window!");
		}
		
		int nCmdShow = SW_SHOWDEFAULT;
		ShowWindow(chainContext.windowsContext.hwnd, nCmdShow);
		SetForegroundWindow(chainContext.windowsContext.hwnd);
		SetFocus(chainContext.windowsContext.hwnd);
		
		UpdateWindow(chainContext.windowsContext.hwnd);
		
	}
}

private void destroyWindow(ChainContext chainContext) {
	// TODO
}