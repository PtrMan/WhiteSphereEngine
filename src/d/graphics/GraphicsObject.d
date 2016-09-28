module graphics.GraphicsObject;

import linopterixed.linear.Vector;
import math.VectorAlias;
import graphics.AbstractDecoratedMesh;
import graphics;

class GraphicsObject {
	Vector3p position = Vector3p.make(0,0,0);
	
	AbstractDecoratedMesh decoratedMesh;
	
	final this(AbstractDecoratedMesh decoratedMesh) {
		this.decoratedMesh = decoratedMesh;
	}
}
