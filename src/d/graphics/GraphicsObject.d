module graphics.GraphicsObject;

import math.NumericSpatialVectors;
import math.VectorAlias;
import graphics.AbstractDecoratedMesh;
import graphics;

class GraphicsObject {
	Vector3p position = new Vector3p;
	
	AbstractDecoratedMesh decoratedMesh;
	
	final this(AbstractDecoratedMesh decoratedMesh) {
		this.decoratedMesh = decoratedMesh;
	}
}
