#pragma once

#include "math/Vector.h"

template<typename NumericType>
struct Plane {
	Vector<3, NumericType> n;
	NumericType d;

	Plane() {}
};

template<typename NumericType>
struct Ray {
	Vector<3, NumericType> dir, p0;

	Vector<3, NumericType> calcPositionByT(NumericType t) const {
		return p0 + dir.scale(t);
	}
};

template<typename NumericType>
NumericType calcRayPlaneT(Ray<NumericType> ray, Plane<NumericType> plane) {
	NumericType t = -(dot(ray.p0, plane.n) + plane.d) / dot(ray.dir, plane.n);
	return t;
}

template<typename NumericType>
Plane<NumericType> calcPlaneFromNormalAndPoint(Vector<3, NumericType> n, Vector<3, NumericType> p) {
	Plane<NumericType> result;
	result.n = n;
	result.d = -dot(n, p);
	return result;
}

template<typename NumericType>
NumericType calcPointDistanceToPlane(Plane<NumericType> plane, Vector<3, NumericType> point) {
	return dot(plane.n, point) + plane.d;
}

template<typename NumericType>
bool calcSideOfPlaneOfPointNonInclusive(Plane<NumericType> plane, Vector<3, NumericType> point) {
	return calcPointDistanceToPlane(plane, point) > static_cast<NumericType>(0);
}
