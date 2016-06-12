#pragma once

#include "math/Vector.h"

// helper
template<bool orientation, unsigned NumberOfPoints, unsigned size, typename NumericType>
bool directionHelper(Vector<size, NumericType> (&convexPoints)[NumberOfPoints], Vector<size, NumericType> point, Vector<size, NumericType> normal, unsigned indexA, unsigned indexB) {
    Vector<size, NumericType>
        a = convexPoints[indexA],
        b = convexPoints[indexB];

    Vector<size, NumericType>
        affineSegment = b - a,
        affinePoint = point - a;

    Vector<size, NumericType> crossResult = crossProduct(affineSegment, normal);
    NumericType dotResult = dot(crossResult, affinePoint);

    if( (dotResult >= static_cast<NumericType>(0)) != orientation ) {
        return false;
    }
    return true;
}

// own algorithm
// maybe a bit slower than http://stackoverflow.com/a/1119673/388614
// but it generalizes to any? number of dimensions
// further it works not just on a plane, and if the point lies on the edge its counted as inside
template<bool orientation, unsigned NumberOfPoints, unsigned size, typename NumericType>
bool insideConvexPolygonFixedArray(Vector<size, NumericType> (&convexPoints)[NumberOfPoints], Vector<size, NumericType> point, Vector<size, NumericType> normal) {
    for( unsigned n = 0; n < NumberOfPoints-1; n++ ) {
        if( !directionHelper<orientation>(convexPoints, point, normal, n, n+1) ) {
            return false;
        }
    }

    if( !directionHelper<orientation>(convexPoints, point, normal, NumberOfPoints-1, 0) ) {
        return false;
    }
    
    return true;
}
