module graphics.AbstractGraphicsEngine;

import graphics;

abstract class AbstractGraphicsEngine {
	GraphicsObject createGraphicsObject();
	void disposeGraphicsObject(GraphicsObject graphicsObject);
	AbstractDecoratedMesh createMeshWithDecorationForMesh(Mesh mesh);
	void disposeMeshWithDecoration(AbstractDecoratedMesh decoratedMesh);
}
