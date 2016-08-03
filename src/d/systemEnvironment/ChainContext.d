module systemEnvironment.ChainContext;

import std.stdint;

import api.vulkan.Vulkan;
import memory.NonGcHandle : NonGcHandle;
import vulkan.VulkanDevice;
import vulkan.QueueManager;
import common.LoggerPipe;
import vulkan.VulkanSwapChain2;
import vulkan.VulkanSurface;
import helpers.VariableValidator;

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
		VulkanSurface surface;
		
		VulkanDevice chosenDevice;
		
		VariableValidator!VkInstance instance;
		
		// TODO< rework to VariableValidator >
		NonGcHandle!VkCommandPool cmdPool;
		
		// TODO< rework to VariableValidator >
		NonGcHandle!VkFormat depthFormatMediumPrecision;
		NonGcHandle!VkFormat depthFormatHighPrecision;
		
		
		
		// prototyping
			VkRenderPass renderPass;

		
		VulkanSwapChain2 swapChain;
		/*
			
			VkCommandBuffer postPresentCmdBuffer;
			VkCommandBuffer setupCmdBuffer;			
			TypedPointerWithLength!VkCommandBuffer drawCmdBuffers;
			TypedPointerWithLength!VkFramebuffer frameBuffers;*/
	}
	
	public Vulkan vulkan;
}