module graphics.vulkan.GraphicsVulkanAbstractGraphicsEngineAdapter;

import graphics;
import graphics.vulkan.GraphicsVulkan;

// TODO< refactor our still crappy GraphicsVulkan "engine" into parts and use it from here >
/**
 * This is an hack to abstract the functionality of our proto graphics engine into a common interface.
 * 
 * The actual usage of this is to delegate the tasks to the part of the graphics engine which is responsible for the task.
 * Every graphics engine (vulkan, opengl, ...) can do a different thing in here.
 *
 */
class GraphicsVulkanAbstractGraphicsEngineAdapter : AbstractGraphicsEngine {
	GraphicsObject createGraphicsObject() {
		assert(false, "TODO");
	}
	
	void disposeGraphicsObject(GraphicsObject graphicsObject) {
		assert(false, "TODO");
	}
	
	AbstractDecoratedMesh createMeshWithDecorationForMesh(Mesh mesh)  {
		assert(false, "TODO");
	}
	
	void disposeMeshWithDecoration(AbstractDecoratedMesh decoratedMesh) {
		assert(false, "TODO");
	}
	
	final this(GraphicsVulkan graphicsVulkan) {
		this.graphicsVulkan = graphicsVulkan;
	}
	
	protected GraphicsVulkan graphicsVulkan;
}