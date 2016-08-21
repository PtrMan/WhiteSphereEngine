module graphics.vulkan.VulkanResourceWithMemoryDecoration;

import std.stdint;

import helpers.VariableValidator;
import graphics.vulkan.VulkanMemoryAllocator;

// vulkan resource (for example VkImage) with the offset of the bind, size, alignment, memory hint
class VulkanResourceWithMemoryDecoration(Datatype) {
	static struct DerivedInformation {
		uint32_t typeIndex; // type index of the resource as reported by vkGet*MemoryRequirements
	
		VulkanMemoryAllocator.OffsetType offset; // allocated offset in the heap			
		VkDeviceSize allocatedSize; // the real allocated size for this resource
		
		VulkanMemoryAllocator.HintAllocatedSizeType hintAllocatedSize; // real size allocated by the allocator, for an hint of the allocator
		                                                               // the nullable indicates to the allocator which tpye of alloction it was actually
		VulkanMemoryAllocator allocatorForResource; // which allocator was used to allocate the resource
	}
	
	VariableValidator!Datatype resource;
	VariableValidator!DerivedInformation derivedInformation;
}
