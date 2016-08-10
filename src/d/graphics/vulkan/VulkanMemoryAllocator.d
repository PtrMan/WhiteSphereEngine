module graphics.vulkan.VulkanMemoryAllocator;

import std.stdint;
import std.typecons : Nullable;

import Exceptions;
import api.vulkan.Vulkan;
import vulkan.VulkanHelpers;
import graphics.vulkan.VulkanContext;
import common.IDisposable;
import helpers.VariableValidator;
import memory.lowLevel.QuickFitAllocator;
import memory.lowLevel.FirstFitAllocator : FirstFitAllocator;

/**  
 *  Manages graphics memory, does also call to vulkan functions
 *  Is the interface between high level memory requests and managment and low level details
 *  
 *  Doesn't do mapping or binding!
 */
class VulkanMemoryAllocator : IDisposable {
	public static class AllocatorConfiguration {
		public OffsetType initialSize; // in bytes
		public OffsetType linearGrowthRate; // in bytes
		public uint32_t memoryTypeIndex;
	}
	
	// throwed when
	// it has been tried to grow the vulkan memory but vulkan doesn't offer more memory
	// is not fatal because the engine could do GC for the holded resources, do some freeing or other stuff
	public static class OutOfMemoryException : Exception {
		public final this() {
			super("[vulkan] out of memory");
		}
	}
	
	public final this(VulkanContext vulkanContext, VulkanMemoryAllocator.AllocatorConfiguration allocatorConfiguration) {
		this.vulkanContext = vulkanContext;
		this.allocatorConfiguration = allocatorConfiguration;
		
		vulkanInitialAllocation();
		allocatorCreateAllocatorAndInitialAllocation();
	}
	
	public void dispose() {
		allocatorFree();
		vulkanFreeMemory();
	}
	
	public final OffsetType allocate(SizeType size, OffsetType alignment, out HintAllocatedSizeType hintAllocatedSize) {
		bool allocatorOutOfMemory;
		OffsetType allocatedOffset = quickFitAllocator.allocate(size, alignment, allocatorOutOfMemory, hintAllocatedSize);
		if( allocatorOutOfMemory ) {
			// TODO< try to grow vulkan memory and then resize the memory of the firstFitAllocator >
			
			// for now we just throw out of memory
			throw new OutOfMemoryException();
		}
		else {
			return allocatedOffset;
		}
	}
	
	public final void deallocate(OffsetType offset, HintAllocatedSizeType hintAllocatedSize, out bool cantFindAdress) {
		quickFitAllocator.deallocate(offset, cantFindAdress, hintAllocatedSize);
	}
	
	//////////////////
	// allocation
	
	protected final void allocatorCreateAllocatorAndInitialAllocation() {
		firstFitAllocator = new FirstFitAllocatorType();
		
		SizeType minSize = 100;
		SizeType maxSize = 1 << 17;
		quickFitAllocator = new QuickFitAllocatorType(minSize, maxSize);
		quickFitAllocator.setParentAllocator(firstFitAllocator);
		firstFitAllocator.setInitialChunk(0, allocatorConfiguration.initialSize);
	}
	
	// frees the allocator for the memory regions of the managed vulkan device memory
	protected final void allocatorFree() {
		quickFitAllocator = null;
		firstFitAllocator = null;
		// nothing more to do here because its all handled by garbage collection
	}
	
	
	//////////////////
	// vulkan
	
	protected final void vulkanInitialAllocation() {
		VkMemoryAllocateInfo allocateInfo = VkMemoryAllocateInfo.init;
		allocateInfo.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
		allocateInfo.allocationSize = allocatorConfiguration.initialSize;
		allocateInfo.memoryTypeIndex = allocatorConfiguration.memoryTypeIndex;
		
		VkDeviceMemory localDeviceMemory;
		VkResult vulkanResult = vkAllocateMemory(vulkanContext.chosenDevice.logicalDevice, &allocateInfo, null, &localDeviceMemory);
		if( !vulkanResult.vulkanSuccess ) {
			// is not fatal because the application could free unused memory
			throw new EngineException(false, true, "Couldn't allocate initial memory! [vkAllocateMemory]");
		}
		this.protectedDeviceMemory = localDeviceMemory;
	}
	
	protected final void vulkanFreeMemory() {
		assert(protectedDeviceMemory.isValid);
		if( !protectedDeviceMemory.isValid ) {
			return;
		}
		
		vkFreeMemory(vulkanContext.chosenDevice.logicalDevice, protectedDeviceMemory.value, null);
		
		protectedDeviceMemory.invalidate();
	}
	
	public final @property VkDeviceMemory deviceMemory() {
		return protectedDeviceMemory.value;
	}
	
	
	protected VulkanContext vulkanContext;
	protected VulkanMemoryAllocator.AllocatorConfiguration allocatorConfiguration;
	protected VariableValidator!VkDeviceMemory protectedDeviceMemory;
	
	
	protected FirstFitAllocatorType firstFitAllocator; // parent/child allocator, not directly touched
	protected QuickFitAllocatorType quickFitAllocator; 
	
	protected alias FirstFitAllocator!(OffsetType, SizeType) FirstFitAllocatorType;
	protected alias QuickFitAllocator!(OffsetType, FirstFitAllocatorType, SizeType) QuickFitAllocatorType;
	
	public alias QuickFitAllocatorType.HintAllocatedSize HintAllocatedSizeType;
	
	// TODO< alias against vulkan types >
	public alias ulong OffsetType;
	public alias ulong SizeType;
}
