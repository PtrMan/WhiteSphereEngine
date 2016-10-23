module EngineEntry;

import graphics.vulkan.GraphicsVulkan;
import common.ResourceDag;
import whiteSphereEngine.graphics.vulkan.VulkanContext;

// defines an entry which does all setup for the engine and gives the control to the engine
//
//


void engineEntry(VulkanContext vulkanContext) {
	ResourceDag resourceDag = new ResourceDag();
	
	GraphicsVulkan graphicsVulkan = new GraphicsVulkan(resourceDag);
	graphicsVulkan.setVulkanContext(vulkanContext);
	
	graphicsVulkan.initialisationEntry();
}