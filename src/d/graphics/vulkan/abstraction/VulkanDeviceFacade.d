module graphics.vulkan.abstraction.VulkanDeviceFacade;

import core.stdc.stdint;

import Exceptions;
import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;

// hides the device handle and exposes a thin wrapper around the vulkan functions
// * throws also exceptions if an function didn't return VK_SUCCESS
// * simplifies names by overloads for images, etc
// * TODO< static methods which construct default structures, for exmple for the parameters of image creation >
class VulkanDeviceFacade {
	public final this(VkDevice device) {
		this.protectedDevice = device;
	}
	
	public final void getMemoryRequirements(VkImage image, out VkMemoryRequirements memRequirements) {
		VkMemoryRequirements internalMemRequirements; // local value to avoid troubles with pointers
		vkGetImageMemoryRequirements(device, image, &internalMemRequirements);
		memRequirements = internalMemRequirements;
	}
	
	public final void bindMemory(VkImage image, VkDeviceMemory memory, VkDeviceSize memoryOffset) {
		VkResult result = vkBindImageMemory(device, image, memory, memoryOffset);
		if( !result.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't bind memory! [vkBindImageMemory]");
		}
	}
	
	// meta function
	public final void fenceWaitAndReset(VkFence fence) {
		VkResult vulkanResult = vkWaitForFences(protectedDevice, 1, &fence, VK_TRUE, UINT64_MAX);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Wait for fences failed! [vkWaitForFences]");
		}
		
		vulkanResult = vkResetFences(protectedDevice, 1, &fence);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Fence reset failed! [vkResetFrences]");
		}

	}
	
	public final @property device() {
		return protectedDevice;
	}
	
	protected VkDevice protectedDevice;
}