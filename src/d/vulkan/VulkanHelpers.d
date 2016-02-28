module vulkan.VulkanHelpers;

import core.stdc.string : memset;

import api.vulkan.Vulkan;

enum VK_FLAGS_NONE = 0;

void initInstanceCreateInfo(VkInstanceCreateInfo* instanceCreateInfo) {
	memset(instanceCreateInfo, 0, VkInstanceCreateInfo.sizeof);
	instanceCreateInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
}

void initDeviceCreateInfo(VkDeviceCreateInfo* deviceCreateInfo) {
	memset(deviceCreateInfo, 0, VkDeviceCreateInfo.sizeof);
	deviceCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
}

void initDeviceQueueCreateInfo(VkDeviceQueueCreateInfo* deviceQueueCreateInfo) {
	memset(deviceQueueCreateInfo, 0, VkDeviceQueueCreateInfo.sizeof);
	deviceQueueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
}

void initPhysicalDeviceFeatures(VkPhysicalDeviceFeatures* physicalDeviceFeatures) {
	memset(physicalDeviceFeatures, 0, VkPhysicalDeviceFeatures.sizeof);
}

void initCommandPoolCreateInfo(VkCommandPoolCreateInfo* commandPoolCreateInfo) {
	memset(commandPoolCreateInfo, 0, VkCommandPoolCreateInfo.sizeof);
	commandPoolCreateInfo.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
}

void initCommandBufferAllocateInfo(VkCommandBufferAllocateInfo* commandBufferAllocationInfo) {
	memset(commandBufferAllocationInfo, 0, VkCommandBufferAllocateInfo.sizeof);
	commandBufferAllocationInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
}

void initRenderPassCreateInfo(VkRenderPassCreateInfo* renderPassCreateInfo) {
	memset(renderPassCreateInfo, 0, VkRenderPassCreateInfo.sizeof);
	renderPassCreateInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
}

// need to be defined manually because the camel case is a special case
void initDebugReportCallbackCreateInfoEXT(VkDebugReportCallbackCreateInfoEXT* structure) {
	memset(structure, 0, VkDebugReportCallbackCreateInfoEXT.sizeof);
	structure.sType = VK_STRUCTURE_TYPE_DEBUG_REPORT_CREATE_INFO_EXT;
}


// helper for mixin template
private string convertFromCamelCaseToUnderscore(string input) {
	import std.uni : toUpper, isUpper;

	string result;

	foreach( char currentChar; input ) {
		if( isUpper(currentChar) ) {
			result ~= "_";
		}

		result ~= toUpper(currentChar);
	}

	return result;
}


template GenVulkanInitFunction(string functionname) {
    const char[] GenVulkanInitFunction = "void init" ~ functionname ~ "(Vk" ~ functionname ~ "* parameter) {\n" ~
    "memset(parameter, 0, Vk" ~ functionname ~ ".sizeof);\n" ~
    "parameter.sType = VK_STRUCTURE_TYPE" ~ convertFromCamelCaseToUnderscore(functionname) ~ ";\n" ~
    "}\n";
}

mixin(GenVulkanInitFunction!("ApplicationInfo"));
mixin(GenVulkanInitFunction!("BufferCreateInfo"));
mixin(GenVulkanInitFunction!("MemoryAllocateInfo"));
mixin(GenVulkanInitFunction!("DescriptorSetLayoutCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineLayoutCreateInfo"));
mixin(GenVulkanInitFunction!("GraphicsPipelineCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineInputAssemblyStateCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineRasterizationStateCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineColorBlendStateCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineViewportStateCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineDynamicStateCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineMultisampleStateCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineDepthStencilStateCreateInfo"));
mixin(GenVulkanInitFunction!("ShaderModuleCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineVertexInputStateCreateInfo"));
mixin(GenVulkanInitFunction!("PipelineShaderStageCreateInfo"));
mixin(GenVulkanInitFunction!("DescriptorPoolCreateInfo"));
mixin(GenVulkanInitFunction!("DescriptorSetAllocateInfo"));
mixin(GenVulkanInitFunction!("WriteDescriptorSet"));
mixin(GenVulkanInitFunction!("CommandBufferBeginInfo"));
mixin(GenVulkanInitFunction!("RenderPassBeginInfo"));
mixin(GenVulkanInitFunction!("ImageMemoryBarrier"));
mixin(GenVulkanInitFunction!("ImageCreateInfo"));
mixin(GenVulkanInitFunction!("ImageViewCreateInfo"));
mixin(GenVulkanInitFunction!("FramebufferCreateInfo"));
mixin(GenVulkanInitFunction!("SemaphoreCreateInfo"));
mixin(GenVulkanInitFunction!("SubmitInfo"));

bool vulkanSuccess(VkResult result) {
	return result == VK_SUCCESS;
}

VkBool32 vulkanBoolean(bool value) {
	if( value ) {
		return VK_TRUE;
	}
	return VK_FALSE;
}
