module graphics.vulkan.abstraction.VulkanDevicelessFacade;

import core.stdc.stdint;
import std.string : toStringz;

import Exceptions;
import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import graphics.vulkan.VulkanTypesAndEnums;
import math.NumericSpatialVectors;


// Facade for vulkan functionality qhich odesnt need the device
class VulkanDevicelessFacade {
	public static makeVkViewport(SpatialVector!(2, float) size, float minDepth = 0.0f, float maxDepth = 1.0f, SpatialVector!(2, float) position = new SpatialVector!(2, float)(0.0f, 0.0f)) {
		VkViewport viewport;
		with( viewport ) {
			x = position.x;
			y = position.y;
			width = size.x;
			height = size.y;
		}
		viewport.minDepth = minDepth;
		viewport.maxDepth = maxDepth;
		return viewport;
	}
	
	public static makeVkOffset2D(int x, int y) {
		VkOffset2D result;
		result.x = cast(int32_t)x;
		result.y = cast(int32_t)y;
		return result;
	}
	
	public static makeVkExtent2D(int width, int height) {
		VkExtent2D result;
		result.width = cast(int32_t)width;
		result.height = cast(int32_t)height;
		return result;
	}
	
	public static VkPipelineShaderStageCreateInfo makeVkPipelineShaderStageCreateInfo(VkShaderModule shaderModule, VkShaderStageFlagBits stage, string name, VkPipelineShaderStageCreateFlags flags = 0, VkSpecializationInfo* specializationInfo = null) {
		VkPipelineShaderStageCreateInfo result = VkPipelineShaderStageCreateInfo.init;
		result.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
		result.flags = flags;
		result.stage = stage;
		result.module_ = shaderModule;
		result.pName = name.toStringz;
		result.pSpecializationInfo = cast(immutable(VkSpecializationInfo)*)specializationInfo;
		return result;
	}
	
	
	public static void queueSubmit(
		TypesafeVkQueue queue,
		TypesafeVkSemaphore[] waitSemaphores,
		TypesafeVkSemaphore[] signalSemaphores,
		TypesafeVkCommandBuffer[] commandBuffers,
		VkPipelineStageFlags[] waitDstStageMasks,
		TypesafeVkFence signalFence = cast(TypesafeVkFence)VK_NULL_HANDLE
	) {
		assert(waitDstStageMasks.length == waitSemaphores.length);
		
		VkSubmitInfo submitInfo = VkSubmitInfo.init;
		with (submitInfo) {
			sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
			waitSemaphoreCount = waitSemaphores.length;
			pWaitSemaphores = cast(const(immutable(VkSemaphore)*))waitSemaphores.ptr;
			pWaitDstStageMask = cast(immutable(VkPipelineStageFlags)*)waitDstStageMasks.ptr;
			commandBufferCount = commandBuffers.length;
			pCommandBuffers = cast(immutable(VkCommandBuffer_T*)*)commandBuffers.ptr;
			signalSemaphoreCount = signalSemaphores.length;
			pSignalSemaphores = cast(const(immutable(VkSemaphore)*))signalSemaphores.ptr;
		}
		
		VkResult vulkanResult = vkQueueSubmit(cast(VkQueue)queue, 1, &submitInfo, cast(VkFence)signalFence);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Queue submit failed! [vkQueueSubmit]");
		}
	}
}
