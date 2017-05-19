module whiteSphereEngine.geometry.area.AreaSimple;

// the csg operations of the basic shapes are described in a tree structure.
// the children of the nodes are "inside" the node and can change the material/gap

/* uncommented because we dont need this, is just here to illustrate how the algorithms below work
class CarveTreeNode(ContentType) {
	ContentType content;
	CarveTreeNode!ContentType[] children;
}
*/

// calculates the surface of the noode minus the surfaces of the children nodes
// the assumption is that no children intersect each other
// retrives ContentType.surfaceArea
double calcSurfaceWithSubtraction(NodeType)(NodeType node) {
	double remainingSurface;
	const double baseSurface = remainingSurface = node.content.surfaceArea;

	foreach( iterationChildren; node.children ) {
		assert(remainingSurface > 0.0, "negative surface areas are invalid and indicate overlapping area(s)!");

		remainingSurface -= iterationChildren.content.surfaceArea;
	}

	return remainingSurface;
}


// basic functions
import math : PI;

double areaCircle(double radius) {
	return cast(double)PI*radius*radius;
}

// a and b are the diamaters of the axis
double areaEllipse(double a, double b) {
	return areaCircle(1.0) * (a/2.0) * (b/2.0);
}

