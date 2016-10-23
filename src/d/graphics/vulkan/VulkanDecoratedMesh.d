module graphics.vulkan.VulkanDecoratedMesh;

import graphics.vulkan.VulkanTypesAndEnums;
import graphics.vulkan.abstraction.VulkanDeviceFacade;
import whiteSphereEngine.graphics.vulkan.VulkanContext;
import graphics.DecoratedMesh;
import graphics.vulkan.VulkanResourceWithMemoryDecoration;
import graphics.vulkan.VulkanMemoryAllocator;

alias DecoratedMesh!(VulkanMeshDecoration) VulkanDecoratedMesh;

class VulkanMeshDecoration {
	VulkanResourceWithMemoryDecoration!TypesafeVkBuffer[] vbosOfBuffers;
	VulkanResourceWithMemoryDecoration!TypesafeVkBuffer vboIndexBufferResource;
	
	final void dispose(VulkanDeviceFacade vkDevFacade, VulkanContext vulkanContext) {
		freeVulkanResourceWithMemory(vkDevFacade, vulkanContext, vboIndexBufferResource);
		
		foreach( iterationVboOfBuffer; vbosOfBuffers ) {
			freeVulkanResourceWithMemory(vkDevFacade, vulkanContext, iterationVboOfBuffer);
		}
		vbosOfBuffers.length = 0;
	}
	
	final private static void freeVulkanResourceWithMemory(VulkanDeviceFacade vkDevFacade, VulkanContext vulkanContext, ref VulkanResourceWithMemoryDecoration!TypesafeVkBuffer vbo) {
		vkDevFacade.destroyBuffer(vbo.resource.value);
		
		
		VulkanMemoryAllocator vulkanMemoryAllocator = vulkanContext.retriveByTypeIndex(vbo.derivedInformation.value.typeIndex);
		
		bool cantFindAdress;
		vulkanMemoryAllocator.deallocate(vbo.derivedInformation.value.offset, vbo.derivedInformation.value.hintAllocatedSize, /*out*/cantFindAdress);
		assert( !cantFindAdress );
		
		vbo = null;
	}
}
