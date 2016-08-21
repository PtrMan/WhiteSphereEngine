module graphics.vulkan.VulkanDecoratedMesh;

import graphics.DecoratedMesh;
import graphics.vulkan.VulkanResourceWithMemoryDecoration;

alias DecoratedMesh!(VulkanMeshDecoration) VulkanDecoratedMesh;

class VulkanMeshDecoration {
	// TODO
	
	VulkanResourceWithMemoryDecoration!TypesafeVkBuffer vboPositionBufferResource;
	VulkanResourceWithMemoryDecoration!TypesafeVkBuffer vboIndexBufferResource;
}
