#include "Solver4thOrder.h"

bool solve4thOrderForRealDouble(double a, double b, double c, double d, double e, double (&solutions)[4]) {
	return solve4thOrderForReal(a, b, c, d, e, solutions);
}

#include "geometry/Barycentric.h"
#include "geometry/ConvexTest.h"

// A--D  |
// |  |  | t  [0, 1]
// B--C  V

bool checkIfInsideCcwQuadAndCalculateT(Vector<3, float> (&convexPoints)[4], Vector<3, float> &point, Vector<3, float> &normal, float &t) {
	Vector<3, float> convexPointsForTriangleA[3], convexPointsForTriangleB[3];

	convexPointsForTriangleA[0] = convexPoints[0];
	convexPointsForTriangleA[1] = convexPoints[1];
	convexPointsForTriangleA[2] = convexPoints[2];

	convexPointsForTriangleB[0] = convexPoints[2];
	convexPointsForTriangleB[1] = convexPoints[3];
	convexPointsForTriangleB[2] = convexPoints[0];

	if( insideConvexPolygonFixedArray<true>(convexPointsForTriangleA, point, normal) ) {
		float tempU, tempV, tempW;
		calcBarycentricCoordinates(point, convexPoints[0], convexPoints[1], convexPoints[2], tempU, tempV, tempW);
		t = tempU;
		return true;
	}
	else if( insideConvexPolygonFixedArray<true>(convexPointsForTriangleB, point, normal) ) {
		float tempU, tempV, tempW;
		calcBarycentricCoordinates(point, convexPoints[3], convexPoints[0], convexPoints[2], tempU, tempV, tempW);
		t = tempW;
		return true;
	}
	else {
		return false;
	}
}

#include "misc/Distincthalfspaces.h"


extern bool isUsed(unsigned i);

void setAndIcrementTest1(Distincthalfspaces<2, 6> &halfspaces, bool &existsPotentialCrossings, unsigned bitmaskForPotentialCrossings) {
  for( unsigned i = 0; i < 6; i++ ) {
    if( isUsed(i) ) {
      halfspaces.setAndIncrement(i);
    }
  }
  
  existsPotentialCrossings = halfspaces.existsPotentialCrossing();

  bitmaskForPotentialCrossings = halfspaces.getBitmaskForPotentialCrossings();
}


#include "geometry/RayPlane.h"

#include "Defines.h"


// helper
// points are counterclockwise
// drops points beyond index 2 because they are not relevant
template<unsigned NumberOfPoints, typename NumericType>
Plane<NumericType> calcPlaneByNPoints(Vector<3, NumericType> (&points)[NumberOfPoints]) {
	Vector<3, NumericType> ALIGN_16
		a = points[0],
		b = points[1],
		c = points[2],
		ba = b - a,
		ca = c - a;
	return calcPlaneFromNormalAndPoint(a, crossProduct(ba, ca).calcNormalized());
}


/*
 * calculates all (six) planes of a volumetric convex quader and 
 *
 * for a sweeped quad against a quad the quad <0 1 2 3> is sweeped to <4 5 6 7>
 */

// points:
//    0----3
//   /|   /|
//  / |  / |
// 1----2  |
// |  | |  |
// |  4-|--7
// | /  | /
// |/   |/
// 5----6

// planes

//   top [4]
//    d
// a      c

//    b

//   bottom [5]
template<typename NumericType>
void calcPlanePoints(const Vector<3, NumericType> (&volumetricConvexPoints)[8], Vector<3, NumericType> ALIGN_16 (&resultPlaneVertices)[6][4]) {
	// we go around the side surface quads and put it into the array of the sides with 4 points each
	for( unsigned sideIndex = 0; sideIndex < 4; sideIndex++ ) {
		resultPlaneVertices[sideIndex][0] = volumetricConvexPoints[sideIndex];
		resultPlaneVertices[sideIndex][1] = volumetricConvexPoints[4+sideIndex];
		resultPlaneVertices[sideIndex][2] = volumetricConvexPoints[4 + ((1+sideIndex) % 4)];
		resultPlaneVertices[sideIndex][3] = volumetricConvexPoints[(1+sideIndex) % 4];
	}

	Vector<3, NumericType> ALIGN_16 verticesTop[4], verticesBottom[4];
	verticesTop[0] = volumetricConvexPoints[0];
	verticesTop[1] = volumetricConvexPoints[1];
	verticesTop[2] = volumetricConvexPoints[2];
	verticesTop[3] = volumetricConvexPoints[3];

	for( unsigned vertexIndex = 0; vertexIndex < 4; vertexIndex++ ) {
		resultPlaneVertices[4][vertexIndex] = verticesTop[vertexIndex];
	}

	verticesBottom[0] = volumetricConvexPoints[4];
	verticesBottom[1] = volumetricConvexPoints[7];
	verticesBottom[2] = volumetricConvexPoints[6];
	verticesBottom[3] = volumetricConvexPoints[5];

	for( unsigned vertexIndex = 0; vertexIndex < 4; vertexIndex++ ) {
		resultPlaneVertices[5][vertexIndex] = verticesBottom[vertexIndex];
	}
}

template<typename NumericType>
void calcPlanesOfVolumetricQuad(const Vector<3, NumericType> ALIGN_16 (&planeVertices)[6][4], Plane<NumericType> (&resultPlanes)[6]) {
	for( unsigned sideIndex = 0; sideIndex < 6; sideIndex++ ) {
		// TODO< debug if we are right here with the indices >
		resultPlanes[sideIndex] = calcPlaneByNPoints<4>(planeVertices[sideIndex]);
	}
}


// checks for potential collision possibilities against a (convex) Quad
template<typename NumericType>
void calcPotentialCrossingsForPlanesAgainstQuad(Plane<NumericType> (&planes)[6], const Vector<3, NumericType> (&quadPoints)[4], bool &existsPotentialCrossings, unsigned &bitmaskForPotentialCrossings) {
	// now we calculate the sides of all points of all 6 halfspaces/planes and store them into bitfields

	Distincthalfspaces<4, 6> halfspace;

	for( unsigned quadPointIndex = 0; quadPointIndex < 4; quadPointIndex++ ) {
		for( unsigned planeIndex = 0; planeIndex < 6; planeIndex++ ) {
			bool sideOfPlaneOfPoint = calcSideOfPlaneOfPointNonInclusive(planes[planeIndex], quadPoints[quadPointIndex]);
			if( sideOfPlaneOfPoint ) {
				halfspace.setAndIncrement(planeIndex);
			}
		}
	}
	


	// use distinct halfspaces to figure out which halfspaces have to be tested

	existsPotentialCrossings = halfspace.existsPotentialCrossing();

  	bitmaskForPotentialCrossings = halfspace.getBitmaskForPotentialCrossings();
}

void calcPotentialCrossingsForVolumetricQuadAgainstQuad(const Vector<3, float> (&volumetricConvexPoints)[8], const Vector<3, float> (&quadPoints)[4], bool &existsPotentialCrossings, unsigned &bitmaskForPotentialCrossings) {
	Plane<float> planes[6];

	calcPlanesOfVolumetricQuad(volumetricConvexPoints, planes);
	calcPotentialCrossingsForPlanesAgainstQuad(planes, quadPoints, existsPotentialCrossings, bitmaskForPotentialCrossings);
}

// intersects rays against the enabled surfaces (by the bitmaskForPotentialCrossings) of the Volumetric quad
// it doesn't check if
//  - all the checks are required (calcPotentialCrossingsForPlanesAgainstQuad() return existsPotentialCrossings for this)
//  - the intersection positions are in the planes
// it doesn't clear the array intersectionsEnabled, because bitmaskForPotentialCrossings governs a large part of the tests
void calcPossibleRayIntersectionsOfVolumetricQuad(const Plane<float> (&planes)[6], const Vector<3, float> (&quadPoints)[4], const unsigned bitmaskForPotentialCrossings, Vector<3, float> (&intersectionPositions)[6][4], bool (&intersectionsEnabled)[6][4]) {
	Ray<float> ALIGN_16 raysForTestShape[4];
	// the rays go from one point to the next around the testshape
	for( unsigned rayIndex = 0; rayIndex < 4; rayIndex++ ) {
		raysForTestShape[rayIndex].p0 = quadPoints[rayIndex];
		raysForTestShape[rayIndex].dir = quadPoints[(rayIndex+1) % 4] - quadPoints[rayIndex];
	}

	for( unsigned rayIndex = 0; rayIndex < 4; rayIndex++ ) {
		for( unsigned planeIndex = 0; planeIndex < 6; planeIndex++ ) {
			if( bitmaskForPotentialCrossings & (1 << planeIndex) ) {

				// calculate intersection positions 
				float intersectionT = calcRayPlaneT(raysForTestShape[rayIndex], planes[planeIndex]);
				bool didIntersectInRange = static_cast<float>(0) <= intersectionT && intersectionT <= static_cast<float>(1);
				intersectionsEnabled[planeIndex][rayIndex] = didIntersectInRange;
				intersectionPositions[planeIndex][rayIndex] = raysForTestShape[rayIndex].calcPositionByT(didIntersectInRange);
			}
		}
	}
}


// calculates the times of the intersection positions, and searches the earlierst time
void calcFirstIntersectionPositionAndTimeOnlyIfPotentialCrossingExists(const Vector<3, float> (&volumetricConvexPoints)[8], const Plane<float> (&planes)[6], const Vector<3, float> (&quadPoints)[4], const bool existsPotentialCrossings, const unsigned bitmaskForPotentialCrossings,
	// result
	bool &foundIntersection, float &earlierstIntersectionTime, Vector<3, float> &earlierstIntersectionPosition
) {
	// reset values because it is pissible that no intersections are found
	foundIntersection = false;
	earlierstIntersectionTime = 0.0f;

	if( !existsPotentialCrossings ) {
		return;
	}

	Vector<3, NumericType> ALIGN_16 planeVertices[6][4];
	calcPlanePoints(volumetricConvexPoints, planeVertices);


	Vector<3, float> ALIGN_16 (intersectionPositions)[6][4];
	bool (intersectionsEnabled)[6][4];
	calcPossibleRayIntersectionsOfVolumetricQuad(planes, quadPoints, bitmaskForPotentialCrossings, intersectionPositions, intersectionsEnabled);


	

	for( unsigned planeIndex = 0; planeIndex < 6; planeIndex++ ) {
		bool crossingPossibleForPlane = bitmaskForPotentialCrossings & (1 << planeIndex);
		if( !crossingPossibleForPlane ) {
			continue;
		}

		// if the crossing is possible we look for the intersections and if they intersect we calculate the time
		for( unsigned rayIndex = 0; rayIndex < 4; rayIndex++ ) {
			if( !intersectionsEnabled[planeIndex][rayIndex] ) {
				continue;
			}


			// now we calculate if the intersection is in the plane and we calculate the time
			
			// DONE< recalculate the planes outside of the loop >

			// calculate t
			Vector<3, NumericType> intersectionPosition = intersectionPositions[planeIndex][rayIndex];
			Vector<3, float> planeNormal = planes[planeIndex].n;
			float t;
			bool isInside = checkIfInsideCcwQuadAndCalculateT(planeVertices[planeIndex], intersectionPosition, planeNormal, t);
			if( !isInside ) {
				continue;
			}
			
			// if we are here then there is a collision

			// compare t
			// TODO< what do we do if t is equal? >
			if( foundIntersection ) {
				if( t < earlierstIntersectionTime ) {
					earlierstIntersectionTime = t;
					foundIntersection = true;
					earlierstIntersectionPosition = intersectionPosition;
				}
			}
			else {
				earlierstIntersectionTime = t;
				foundIntersection = true;
				earlierstIntersectionPosition = intersectionPosition;
			}
		}
	}
}


// TODO< function which checks for the points of the quad if they lie inside the volume and calculates the time of them and returns the eralierst time


// TODO< function which combines the two times to the earliert one >


