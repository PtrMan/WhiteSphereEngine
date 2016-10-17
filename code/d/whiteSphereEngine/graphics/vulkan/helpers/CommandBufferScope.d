module whiteSphereEngine.graphics.vulkan.helpers.CommandBufferScope;

import Exceptions;
import api.vulkan.Vulkan;
import graphics.vulkan.VulkanTypesAndEnums;
import vulkan.VulkanHelpers;

alias void delegate(TypesafeVkCommandBuffer commandBuffer) InvokeExcecuteCommandBufferBodyDelegateType;

// small little helper/utility which invokes the delegate encapsulated in a vkBeginCommandBuffer/vkEndCommandBuffer
void commandBufferScope(TypesafeVkCommandBuffer commandBuffer, InvokeExcecuteCommandBufferBodyDelegateType invoke) {
	VkCommandBufferBeginInfo commandBufferBeginInfo = VkCommandBufferBeginInfo.init;
	with(commandBufferBeginInfo) {
		sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
		flags = VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT;
		pInheritanceInfo = null;
	}

	vkBeginCommandBuffer(cast(VkCommandBuffer)commandBuffer, &commandBufferBeginInfo);
	scope(success) {
		if( !vkEndCommandBuffer(cast(VkCommandBuffer)commandBuffer).vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't record command buffer [vkEndCommandBuffer]");
		}
	}

	invoke(commandBuffer);
}
