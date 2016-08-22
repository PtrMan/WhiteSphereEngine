module graphics.AbstractGraphicsEngine;

import graphics;

abstract class AbstractGraphicsEngine {
	GraphicsObject createGraphicsObject(AbstractDecoratedMesh decoratedMesh);
	void disposeGraphicsObject(GraphicsObject graphicsObject);
	AbstractDecoratedMesh createDecoratedMesh(Mesh mesh);
	void disposeDecoratedMesh(AbstractDecoratedMesh decoratedMesh);
}
