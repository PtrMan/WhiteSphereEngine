module graphics.vulkan.resourceDag.VulkanResourceDagResource;

import api.vulkan.Vulkan;
import common.ResourceDag;
import graphics.vulkan.abstraction.VulkanDeviceFacade;
import graphics.vulkan.VulkanTypesAndEnums;


class VulkanResourceDagResource(ResourceType) : ResourceDag.IResource {
	public alias void function(VulkanDeviceFacade vkDevFacade, ResourceType resource, const(VkAllocationCallbacks*) allocator) DisposalDelegateType;
	
	public final this(VulkanDeviceFacade vkDevFacade, ResourceType resource, const(VkAllocationCallbacks*) allocator, DisposalDelegateType disposalDelegate) {
		assert(disposalDelegate !is null);

		this.protectedVkDevFacade = vkDevFacade;
		this.protectedResource = resource;
		this.protectedAllocator = allocator;

		this.disposalDelegate = disposalDelegate;
	}
	
	public void dispose() {
		assert(!wasDisposed);
		wasDisposed = true;
		
		disposalDelegate(protectedVkDevFacade, protectedResource, protectedAllocator);
	}
	
	public final @property ResourceType resource() {
		assert(!wasDisposed);
		return protectedResource;
	}
	
	protected bool wasDisposed = false;
	
	protected VulkanDeviceFacade protectedVkDevFacade;
	protected ResourceType protectedResource;
	protected const(VkAllocationCallbacks*) protectedAllocator;
	
	protected DisposalDelegateType disposalDelegate;
}



void disposeImageView(VulkanDeviceFacade vkDevFacade, TypesafeVkImageView imageView, const(VkAllocationCallbacks*) allocator) {
	vkDevFacade.destroyImageView(imageView, allocator);
}

void disposeSampler(VulkanDeviceFacade vkDevFacade, TypesafeVkSampler sampler, const(VkAllocationCallbacks*) allocator) {
	vkDevFacade.destroySampler(sampler, allocator);
}

void disposeDescriptorSetLayout(VulkanDeviceFacade vkDevFacade, TypesafeVkDescriptorSetLayout descriptorSetLayout, const(VkAllocationCallbacks*) allocator) {
	vkDevFacade.destroyDescriptorSetLayout(descriptorSetLayout, allocator);
}

void disposeFramebuffer(VulkanDeviceFacade vkDevFacade, TypesafeVkFramebuffer framebuffer, const(VkAllocationCallbacks*) allocator) {
	vkDevFacade.destroyFramebuffer(framebuffer, allocator);
}

void disposeRenderPass(VulkanDeviceFacade vkDevFacade, TypesafeVkRenderPass renderPass, const(VkAllocationCallbacks*) allocator) {
	vkDevFacade.destroyRenderPass(renderPass, allocator);
}

void disposePipelineLayout(VulkanDeviceFacade vkDevFacade, TypesafeVkPipelineLayout pipelineLayout, const(VkAllocationCallbacks*) allocator) {
	vkDevFacade.destroyPipelineLayout(pipelineLayout, allocator);
}

/*
void disposeShaderModule(VulkanDeviceFacade vkDevFacade, TypesafeVkShaderModule shaderModule, const(VkAllocationCallbacks*) allocator) {
	vkDevFacade.destroyShaderModule(shaderModule, allocator);
}
*/

void disposePipeline(VulkanDeviceFacade vkDevFacade, TypesafeVkPipeline pipeline, const(VkAllocationCallbacks*) allocator) {
	vkDevFacade.disposePipeline(pipeline, allocator);
}
