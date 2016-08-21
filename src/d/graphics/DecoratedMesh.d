module graphics.DecoratedMesh;

import graphics.AbstractDecoratedMesh;

// mesh with decoration for the specific API implementation
class DecoratedMesh(DecorationType) : AbstractDecoratedMesh {
	DecorationType decoration;
}
