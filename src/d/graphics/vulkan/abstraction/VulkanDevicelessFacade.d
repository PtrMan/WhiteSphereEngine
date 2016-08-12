module graphics.vulkan.abstraction.VulkanDevicelessFacade;

//import core.stdc.stdint;

import Exceptions;
import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import graphics.vulkan.VulkanTypesAndEnums;

// Facade for vulkan functionality qhich odesnt need the device
class VulkanDevicelessFacade {
	
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
