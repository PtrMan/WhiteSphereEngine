module graphics.DecoratedMesh;

import graphics.Mesh;
import graphics.AbstractDecoratedMesh;

// mesh with decoration for the specific API implementation
class DecoratedMesh(DecorationType) : AbstractDecoratedMesh {
	DecorationType decoration;
	
	final this(Mesh mesh) {
		super(mesh);
	}
}
