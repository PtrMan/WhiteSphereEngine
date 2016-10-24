module whiteSphereEngine.graphics.vulkan.abstraction.VulkanLevel1Abstraction;

import api.vulkan.Vulkan;

import linopterixed.linear.Vector;
import math.VectorAlias;

import common.ResourceDag;

import graphics.vulkan.VulkanTypesAndEnums;
import graphics.vulkan.abstraction.VulkanDeviceFacade;
import graphics.vulkan.resourceDag.VulkanResourceDagResource;

// Is an abstraction layer over layer0
// which introduces the useage of the resource-dag and the allocator and the device facade
struct VulkanLevel1Abstraction {
	// API abstraction for the creation of a framebuffer
	ResourceDag.ResourceNode createFramebuffer(ResourceDag.ResourceNode renderPassResourceNode, TypesafeVkImageView[] attachments, Vector2ui framebufferExtent, string usage = "") {
		VulkanDeviceFacade.CreateFramebufferArguments createFramebufferArguments = VulkanDeviceFacade.CreateFramebufferArguments.init;
		with(createFramebufferArguments) {
			flags = 0;
			renderPass = (cast(VulkanResourceDagResource!TypesafeVkRenderPass)renderPassResourceNode.resource).resource;
			width = framebufferExtent.x;
			height = framebufferExtent.y;
		}
		createFramebufferArguments.attachments = attachments;
		

		TypesafeVkFramebuffer createdFramebuffer = vkDevFacade.createFramebuffer(createFramebufferArguments, allocator);
		
		VulkanResourceDagResource!TypesafeVkFramebuffer framebufferDagResource = new VulkanResourceDagResource!TypesafeVkFramebuffer(vkDevFacade, createdFramebuffer, allocator, &disposeFramebuffer);
		ResourceDag.ResourceNode framebufferResourceNode = resourceDag.createNode(framebufferDagResource, "framebuffer " ~ usage);
		return framebufferResourceNode;
	}

	VulkanDeviceFacade vkDevFacade;
	ResourceDag resourceDag;

	VkAllocationCallbacks *allocator = null;
}
