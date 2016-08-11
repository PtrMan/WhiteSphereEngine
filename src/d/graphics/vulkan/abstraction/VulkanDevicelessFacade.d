module graphics.vulkan.abstraction.VulkanDevicelessFacade;

//import core.stdc.stdint;

import Exceptions;
import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;


// Facade for vulkan functionality qhich odesnt need the device
class VulkanDevicelessFacade {
	
	public static void queueSubmit(
		VkQueue queue,
		VkSemaphore[] waitSemaphores,
		VkSemaphore[] signalSemaphores,
		VkCommandBuffer[] commandBuffers,
		VkPipelineStageFlags[] waitDstStageMasks,
		VkFence signalFence = VK_NULL_HANDLE
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
		
		VkResult vulkanResult = vkQueueSubmit(queue, 1, &submitInfo, signalFence);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Queue submit failed! [vkQueueSubmit]");
		}
	}
}
