module graphics.vulkan.abstraction.VulkanDeviceFacade;

import core.stdc.stdint;

import Exceptions;
import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import graphics.vulkan.VulkanTypesAndEnums;

// hides the device handle and exposes a thin wrapper around the vulkan functions
// * throws also exceptions if an function didn't return VK_SUCCESS
// * simplifies names by overloads for images, etc
// * TODO< static methods which construct default structures, for exmple for the parameters of image creation >
class VulkanDeviceFacade {
	public final this(VkDevice device) {
		this.protectedDevice = device;
	}
	
	public final void getMemoryRequirements(TypesafeVkImage image, out VkMemoryRequirements memRequirements) {
		VkMemoryRequirements internalMemRequirements; // local value to avoid troubles with pointers
		vkGetImageMemoryRequirements(device, cast(VkImage)image, &internalMemRequirements);
		memRequirements = internalMemRequirements;
	}
	
	public final void getMemoryRequirements(TypesafeVkBuffer buffer, out VkMemoryRequirements memRequirements) {
		VkMemoryRequirements internalMemRequirements; // local value to avoid troubles with pointers
		vkGetBufferMemoryRequirements(device, cast(VkBuffer)buffer, &internalMemRequirements);
		memRequirements = internalMemRequirements;
	}

	
	public final void bind(TypesafeVkImage image, VkDeviceMemory memory, VkDeviceSize memoryOffset) {
		VkResult result = vkBindImageMemory(device, cast(VkImage)image, memory, memoryOffset);
		if( !result.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't bind memory! [vkBindImageMemory]");
		}
	}
	
	public final TypesafeVkSemaphore createSemaphore(const VkAllocationCallbacks* allocator = null) {
		VkSemaphore rawSemaphore;
		const VkSemaphoreCreateInfo semaphoreCreateInfo = {
			VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,    // sType
			null,                                       // pNext
			0                                           // flags
		};
		
		VkResult result = vkCreateSemaphore(device, &semaphoreCreateInfo, allocator, &rawSemaphore);
		if( !result.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create semaphore! [vkCreateSemaphore]");
		}
		
		return cast(TypesafeVkSemaphore)rawSemaphore;
	}
	
	public final void destroySemaphore(TypesafeVkSemaphore semaphore, const VkAllocationCallbacks* allocator = null) {
		TypesafeVkSemaphore[1] semaphores = [semaphore];
		destroySemaphores(semaphores, allocator);
	}
	
	// meta function
	public final void destroySemaphores(TypesafeVkSemaphore[] semaphores, const VkAllocationCallbacks* allocator = null) {
		foreach( iterationSemaphore; semaphores ) {
			vkDestroySemaphore(device, cast(VkSemaphore)iterationSemaphore, allocator);
		}
	}
	
	public static struct CreateBufferArguments {
		VkBufferCreateFlags flags = 0;
		VkDeviceSize size;
		VkBufferUsageFlags usage;
		VkSharingMode sharingMode = VK_SHARING_MODE_EXCLUSIVE;
		uint32_t[] queueFamilyIndices;
	}
	
	public final TypesafeVkBuffer createBuffer(CreateBufferArguments arguments, const VkAllocationCallbacks* allocator = null) {
		VkBuffer rawBuffer;
		
		VkBufferCreateInfo createInfo = VkBufferCreateInfo.init;
		with(createInfo) {
			sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
			flags = arguments.flags;
			size = arguments.size;
			usage = arguments.usage;
			sharingMode = arguments.sharingMode;
			queueFamilyIndexCount = arguments.queueFamilyIndices.length;
			pQueueFamilyIndices = cast(immutable(uint)*)arguments.queueFamilyIndices.ptr;
		}
		
		VkResult result = vkCreateBuffer(device, &createInfo, allocator, &rawBuffer);
		if( !result.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create buffer! [vkCreateBuffer]");
		}
		return cast(TypesafeVkBuffer)rawBuffer;
	}
	
	public final void destroyBuffer(TypesafeVkBuffer buffer, const VkAllocationCallbacks* allocator = null) {
		TypesafeVkBuffer[1] buffers = [buffer];
		destroyBuffers(buffers, allocator);
	}
	
	// meta function
	public final void destroyBuffers(TypesafeVkBuffer[] buffers, const VkAllocationCallbacks* allocator = null) {
		foreach( iterationBuffer; buffers ) {
			vkDestroyBuffer(device, cast(VkBuffer)iterationBuffer, allocator);
		}
	}
	
	
	// TODO< create image >
	
	public final void destroyImage(TypesafeVkImage image, const VkAllocationCallbacks* allocator = null) {
		TypesafeVkImage[1] images = [image];
		destroyImages(images, allocator);
	}
	
	public final void destroyImages(TypesafeVkImage[] images, const VkAllocationCallbacks* allocator = null) {
		foreach( iterationImage; images ) {
			vkDestroyImage(device, cast(VkImage)iterationImage, allocator);
		}
	}
	
	public final TypesafeVkFence createFence(VkFenceCreateFlags flags = 0, const VkAllocationCallbacks* allocator = null) {
		VkFence rawFence;
		
		VkFenceCreateInfo fenceCreateInfo = VkFenceCreateInfo.init;
		fenceCreateInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
		fenceCreateInfo.flags = flags;
		
		VkResult vulkanResult = vkCreateFence(device, &fenceCreateInfo, allocator, &rawFence);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't create fence [vkCreateFence]!");
		}
		return cast(TypesafeVkFence)rawFence;
	}
	
	public final void destroyFence(TypesafeVkFence fence, const VkAllocationCallbacks* allocator = null) {
		TypesafeVkFence[1] fences = [fence];
		destroyFences(fences, allocator);
	}
	
	public final void destroyFences(TypesafeVkFence[] fences, const VkAllocationCallbacks* allocator = null) {
		foreach( iterationFence; fences ) {
			vkDestroyFence(device, cast(VkFence)iterationFence, allocator);
		}
		
	}
	
	// meta function
	public final void fenceWaitAndReset(TypesafeVkFence fence) {
		VkFence rawFence = cast(VkFence)fence;
		VkResult vulkanResult = vkWaitForFences(protectedDevice, 1, &rawFence, VK_TRUE, UINT64_MAX);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Wait for fences failed! [vkWaitForFences]");
		}
		
		vulkanResult = vkResetFences(protectedDevice, 1, &rawFence);
		if( !vulkanSuccess(vulkanResult) ) {
			throw new EngineException(true, true, "Fence reset failed! [vkResetFrences]");
		}
	}
	
	
	public final TypesafeVkCommandBuffer[] allocateCommandBuffers(TypesafeVkCommandPool pool, size_t count, VkCommandBufferLevel level = VK_COMMAND_BUFFER_LEVEL_PRIMARY) {
		
		VkCommandBuffer[] rawCommandBuffers;
		rawCommandBuffers.length = count;
		
		VkCommandBufferAllocateInfo commandBufferAllocateInfo = VkCommandBufferAllocateInfo.init;
		with(commandBufferAllocateInfo) {
			sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
			commandPool = cast(VkCommandPool)pool;
			commandBufferCount = cast(uint32_t)count;
		}
		commandBufferAllocateInfo.level = level;// outside because of variablename
		
		VkResult vulkanResult = vkAllocateCommandBuffers(device, &commandBufferAllocateInfo, rawCommandBuffers.ptr);
		if( !vulkanResult.vulkanSuccess ) {
			throw new EngineException(true, true, "Couldn't allocate command buffers [vkAllocateCommandBuffers]");
		}
		
		// translate to typesafe values
		TypesafeVkCommandBuffer[] commandBuffers;
		commandBuffers.length = rawCommandBuffers.length;
		foreach( i; 0..commandBuffers.length ) {
			commandBuffers[i] = cast(TypesafeVkCommandBuffer)rawCommandBuffers[i];
		}
		
		return commandBuffers;
	}
	
	public final TypesafeVkCommandBuffer allocateCommandBuffer(TypesafeVkCommandPool pool, VkCommandBufferLevel level = VK_COMMAND_BUFFER_LEVEL_PRIMARY) {
		TypesafeVkCommandBuffer[] commandBuffers = allocateCommandBuffers(pool, 1, level);
		return commandBuffers[0];
	}
	
	public final void freeCommandBuffer(TypesafeVkCommandBuffer commandBuffer, TypesafeVkCommandPool commandPool) {
		TypesafeVkCommandBuffer[1] commandBuffers = [commandBuffer];
		freeCommandBuffers(commandBuffers, commandPool);
	}
	
	public final void freeCommandBuffers(TypesafeVkCommandBuffer[] commandBuffers, TypesafeVkCommandPool commandPool) {
		static assert( TypesafeVkCommandBuffer.sizeof == VkCommandBuffer.sizeof ); // sizes have to be identical for array cheatery
		vkFreeCommandBuffers(device, cast(VkCommandPool)commandPool, commandBuffers.length, cast(VkCommandBuffer*)commandBuffers.ptr);
	}
	
	public final @property device() {
		return protectedDevice;
	}
	
	protected VkDevice protectedDevice;
}