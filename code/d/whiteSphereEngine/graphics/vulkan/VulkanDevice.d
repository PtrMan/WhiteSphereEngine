module whiteSphereEngine.graphics.vulkan.VulkanDevice;

import api.vulkan.Vulkan;

// helps to keep record of the physical properties of the device(s)
class VulkanDevice {
	VkDevice logicalDevice = null;

	// TODO< check if we do this like this in the OpenGL implementation and rewrite this code here if we allocate memory not over the GC
	VkPhysicalDevice physicalDevice;

	VkPhysicalDeviceMemoryProperties* physicalDeviceMemoryProperties = null;

	// TODO< check if we do this like this in the OpenGL implementation and rewrite this code here if we allocate memory not over the GC
	VkPhysicalDeviceProperties physicalDeviceProperties;
	// TODO< check if we do this like this in the OpenGL implementation and rewrite this code here if we allocate memory not over the GC
	VkQueueFamilyProperties[] queueFamilyProperties;
}
