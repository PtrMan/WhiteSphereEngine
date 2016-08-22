module graphics.AbstractDecoratedMesh;

import graphics;

// used to abstract away the mesh decorations from the different renderers for the different APIs
abstract class AbstractDecoratedMesh {
	Mesh decoratedMesh;
	
	final this(Mesh mesh) {
		this.decoratedMesh = mesh;
	}
}
