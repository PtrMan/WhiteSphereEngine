module EngineEntry;

import graphics.vulkan.GraphicsVulkan;
import common.ResourceDag;

// defines an entry which does all setup for the engine and gives the control to the engine
//
//


void engineEntry() {
	ResourceDag resourceDag = new ResourceDag();
	
	GraphicsVulkan graphicsVulkan = new GraphicsVulkan(resourceDag);
	
	graphicsVulkan.initialisationEntry();
}