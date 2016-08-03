module vulkan.VulkanSurface;

version(Win32) {
	import core.sys.windows.windows;
}

import api.vulkan.Vulkan;
import helpers.VariableValidator;

class VulkanSurface {
	private VariableValidator!VkSurfaceKHR privateSurface;
	
	public final @property VariableValidator!VkSurfaceKHR surface() {
		return surface;
	}
	
	public final this() {
		surface.invalidate();
	}
	
	public final VkResult createSurface(
		VariableValidator!VkInstance instance,
		
		// for windows
		HINSTANCE platformHandle, HWND platformWindow
	) {
		VkResult vulkanResult;
		VkSurfaceKHR surface;
		
		assert(!this.surface.isValid);
		
		// Create surface depending on OS
		version(Win32) {
		VkWin32SurfaceCreateInfoKHR surfaceCreateInfo;
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
		
		this.privateSurface = surface;
		
		return vulkanResult;
	}
	
	public final void destroySurface(VariableValidator!VkInstance instance) {
		vkDestroySurfaceKHR(instance.value, privateSurface.value, null);
		
		privateSurface.invalidate();
	}
}