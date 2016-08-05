module graphics.vulkan.VulkanContext;

//import std.stdint;

import api.vulkan.Vulkan;
import memory.NonGcHandle : NonGcHandle;
import vulkan.VulkanDevice;
import vulkan.QueueManager;

import vulkan.VulkanSwapChain2;
import vulkan.VulkanSurface;
import helpers.VariableValidator;
import graphics.vulkan.VulkanContext;

// all vulkan handles , which are set up from the setup code
class VulkanContext {
	QueueManager queueManager = new QueueManager();
	VulkanSurface surface;
	
	VulkanDevice chosenDevice;
	
	VariableValidator!VkInstance instance;
	
	VariableValidator!VkCommandPool cmdPool;
	
	VariableValidator!VkFormat depthFormatMediumPrecision;
	VariableValidator!VkFormat depthFormatHighPrecision;
	
	VulkanSwapChain2 swapChain;
}
