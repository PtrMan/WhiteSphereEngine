module geometry.RayPlane;

import math.NumericSpatialVectors;

struct Plane(NumericType) {
	public SpatialVector!(3, NumericType) n;
	public NumericType d;
}

struct Ray(NumericType) {
	public SpatialVector!(3, NumericType) dir;
	public SpatialVector!(3, NumericType) p0;
}


public NumericType calcRayPlaneT(NumericType)(Ray!NumericType ray, Plane!NumericType plane) {
	NumericType t = -(dot(ray.p0, plane.n) + plane.d) / dot(ray.dir, plane.n);
	return t;
}

public Plane!NumericType calcPlaneFromNormalAndPoint(NumericType)(SpatialVector!(3, NumericType) n, SpatialVector!(3, NumericType) p) {
	Plane!NumericType result;
	result.n = n;
	result.d = -dot(n, p);
	return result;
}
