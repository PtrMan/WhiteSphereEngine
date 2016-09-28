module graphics.GraphicsObject;

import linopterixed.linear.Vector;
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
