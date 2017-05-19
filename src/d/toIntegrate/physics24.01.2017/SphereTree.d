// tree of spheres for a fast collision test and geomatrical queries
// inspired by https://www.reddit.com/r/gamedev/comments/4vzo47/how_should_i_implement_physics_in_my_mmo_server/d62xya8/

struct Sphere {
	Position relativePosition; // relative position to parent
	double radius;
}

struct Position {
	static Position make(double x, double y, double z) {
		Position result;
		result.x = x;
		result.y = y;
		result.z = z;
		return result;
	}

	double x,y,z;
}

struct SphereTreeElement {
	final @property bool isLeaf() {
		return children.length == 0;
	}

	Sphere sphere;
	SphereTreeElement*[] children;
}

bool checkInsideForChildrenRecursive(Position position, SphereTreeElement *sphereTreeElement) {
	// we have to check all other spheres because one point can be included by many spheres

	foreach( SphereTreeElement* iterationChildren; sphereTreeElement.children ) {
		Position relativePosition = Position.make(position.x - sphereTreeElement.sphere.relativePosition.x, position.y - sphereTreeElement.sphere.relativePosition.y, position.z - sphereTreeElement.sphere.relativePosition.z);

		if( checkInsideNoRelative(iterationChildren.sphere, relativePosition ) ) {
			return checkInsideForChildrenRecursive(relativePosition, iterationChildren);
		}
	}

	return false;
}

import std.math : abs;

bool checkInsideNoRelative(Sphere sphere, Position position) {
	double
		xdiff = /*sphere.relativePosition.x - because not relative */position.x,
		ydiff = /*sphere.relativePosition.y - because not relative */position.y,
		zdiff = /*sphere.relativePosition.z - because not relative */position.z,

		xdiffAbs = abs(xdiff),
		ydiffAbs = abs(ydiff),
		zdiffAbs = abs(zdiff);

	if( fastInside(xdiffAbs, ydiffAbs, zdiffAbs, sphere.radius) ) {
		return xdiff*xdiff + ydiff*ydiff + zdiff*zdiff < sphere.radius*sphere.radius;
	}
	else {
		return false;
	}
}

import std.algorithm.comparison : max;

// like an AABB test, x,y,z have already to be absolute
bool fastInside(double x, double y, double z, double maxDiff) {
	return max(x, y, z) < maxDiff;
}