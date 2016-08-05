module graphics.vulkan.resourceDag.VulkanResourceDagResource;

import api.vulkan.Vulkan;
import common.ResourceDag;

class VulkanResourceDagResource(ResourceType) : ResourceDag.IResource {
	public alias void function(VkDevice device, ResourceType resource, const(VkAllocationCallbacks*) allocator) DisposalDelegateType;
	
	public final this(VkDevice device, ResourceType resource, const(VkAllocationCallbacks*) allocator, DisposalDelegateType disposaleDelegate) {
		this.protectedDevice = device;
		this.protectedResource = resource;
		this.protectedAllocator = allocator;
		
		this.disposalDelegate = disposalDelegate;
	}
	
	public void dispose() {
		assert(!wasDisposed);
		wasDisposed = true;
		
		disposalDelegate(protectedDevice, protectedResource, protectedAllocator);
	}
	
	public final @property ResourceType resource() {
		assert(!wasDisposed);
		return protectedResource;
	}
	
	protected bool wasDisposed = false;
	
	protected VkDevice protectedDevice;
	protected ResourceType protectedResource;
	protected const(VkAllocationCallbacks*) protectedAllocator;
	
	protected DisposalDelegateType disposalDelegate;
}



void disposeImageView(VkDevice device, VkImageView imageView, const(VkAllocationCallbacks*) allocator) {
	vkDestroyImageView(device, imageView, allocator);
}

void disposeFramebuffer(VkDevice device, VkFramebuffer framebuffer, const(VkAllocationCallbacks*) allocator) {
	vkDestroyFramebuffer(device, framebuffer, allocator);
}

void disposeRenderPass(VkDevice device, VkRenderPass renderPass, const(VkAllocationCallbacks*) allocator) {
	vkDestroyRenderPass(device, renderPass, allocator);
}