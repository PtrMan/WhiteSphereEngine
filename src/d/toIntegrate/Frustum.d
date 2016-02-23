// source/see
// http://www.flipcode.com/archives/Frustum_Culling.shtml

// partialy tested


import std.stdio;


import std.math : abs;

import NumericSpatialVectors;

class FrustumSphere(Type) {
	public SpatialVector!(3,Type) position;
	public Type radius;
}

class FrustumAabb(Type) {
	final @property SpatialVector!(3,Type)[8] vertices() {
    	SpatialVector!(3,Type)[8] result;

    	// TODO TODO TODO

    	return result;
    }

    public final bool containsPoint(SpatialVector!(3,Type)) {
    	// TODO TODO TODO
    	return false;
    }
}

Type planePointDistance(Type)(SpatialVector!(3,Type) planeNormal, Type planeD, SpatialVector!(3,Type) point) {
	return planeNormal.dot(point) + planeD;
}

struct FrustumPlane(Type) {
	enum EnumSideOfPlane {
		FRONT,
		BEHIND
	}

	public SpatialVector!(3,Type) normal;
	public Type distance;

	public final EnumSideOfPlane getSideOfPlane(SpatialVector!(3,Type) position) {
		// fast version, doesn't check for equality
		if( planePointDistance(normal, distance, position) > cast(Type)0 ) {
			return EnumSideOfPlane.FRONT;
		}
		return EnumSideOfPlane.BEHIND;
	}

	public static createByPointOnPlaneAndNormal(SpatialVector!(3,Type) position, SpatialVector!(3,Type) normal) {
		FrustumPlane resultPlane;
		resultPlane.normal = normal.clone();
		resultPlane.distance = -normal.dot(position);
		return resultPlane;
	}
}

struct Frustum(Type) {
	enum EnumFrustumIntersectionResult {
		OUTSIDE, // object to test is fully outside of the frustum
		INTERSECT, // object to test intersects with frustum
		INSIDE
	}

	// tests if a sphere is inside the frustum
	public final pure EnumFrustumIntersectionResult calcContainsForSphere(FrustumSphere!Type sphere) {
		foreach( uint i; 0..planes.length ) {				
			// find the distance to this plane
			Type distance = planes[i].normal.dot(sphere.position) + planes[i].distance;
			
			if( distance < -sphere.radius ) {
				return EnumFrustumIntersectionResult.OUTSIDE;
			}

			if( abs(distance) < sphere.radius ) {
				return EnumFrustumIntersectionResult.INTERSECT;
			}
		}

		return EnumFrustumIntersectionResult.INSIDE;
	}

	// tests if a AABB is within the frustrum
	public final pure EnumFrustumIntersectionResult calcContainsForAabb(FrustumAabb!Type aabb) {
		uint totalInCounter = 0;

		// get the corners of the box into the cornerVertices array
		SpatialVector!(3,Type)[8] cornerVertices = aabb.vertices;

		// test all 8 corners against the 6 sides 
		// if all points are behind 1 specific plane, we are out
		// if we are in with all points, then we are fully in
		foreach( uint p; 0..planes.length ) {
			uint pointInfrontCounter = 8;
			uint inIncrementForPlane = 1;

			foreach( SpatialVector!(3,Type) iterationCornerVertex; cornerVertices ) {
				// test this point against the planes
				if( planes[p].getSideOfPlane(iterationCornerVertex) == FrustumPlane!Type.EnumSideOfPlane.BEHIND) {
					inIncrementForPlane = 0;
					--pointInfrontCounter;
				}
			}

			// were all the points outside of plane p?
			if( pointInfrontCounter == 0 ) {
				return EnumFrustumIntersectionResult.OUTSIDE;
			}

			// check if they were all on the right side of the plane
			totalInCounter += inIncrementForPlane;
		}
		

		// so if totalInCounter is 6, then all are inside the view
		if( totalInCounter == 6 ) {
			return EnumFrustumIntersectionResult.INSIDE;
		}

		// we must be partly in then otherwise
		return EnumFrustumIntersectionResult.INTERSECT;
	}

	protected FrustumPlane!Type[6] planes;
}


void main(string[] args) {
	// unittest for the frustum plane
	FrustumPlane!double testPlane = FrustumPlane!double.createByPointOnPlaneAndNormal(new SpatialVector!(3,double)(-1,0,0), new SpatialVector!(3,double)(1,0,0));
	writeln(testPlane.distance);

	writeln(testPlane.getSideOfPlane(new SpatialVector!(3,double)(0,0,0)) == FrustumPlane!double.EnumSideOfPlane.FRONT);

	/*
	Frustum!double frustum;	

	foreach(uint i;0..5) {
		frustum.planes[i].normal = new SpatialVector3!double(1.0, 0.0, 0.0);
		frustum.planes[i].distance = 0.0;
	}

	FrustumSphere!double frustumSphere = new FrustumSphere!double();
	frustumSphere.position = new SpatialVector3!double(1.0, 0.0, 0.0);
	*/
}
