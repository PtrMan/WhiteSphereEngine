module geometry.Pluecker;

// fresh Implementation of pluecker coordinate and test between two lines

// see http://slidegur.com/doc/1106443/plucker-coordinate

import math.NumericSpatialVectors;

struct Coordinate(NumericType) {
	SpatialVector!(3, NumericType) u, v;

	public static Coordinate!NumericType createByPandQ(SpatialVector!(3, NumericType) p, SpatialVector!(3, NumericType) q) {
		Coordinate!NumericType result;

		result.u = p - q;
		result.v = crossProduct(p, q);

		return result;
	}

	// could be optimized but not wirth the time to optimize
	public static Coordinate!NumericType createByVector(SpatialVector!(3, NumericType) p, SpatialVector!(3, NumericType) dir) {
		return Coordinate!NumericType.createByPandQ(p, p + dir);
	}
	
	// could be optimized but not wirth the time to optimize
	public static Coordinate!NumericType createByNegativeVector(SpatialVector!(3, NumericType) p, SpatialVector!(3, NumericType) dir) {
		return Coordinate!NumericType.createByPandQ(p, p - dir);
	}
}

//  see http://slidegur.com/doc/1106443/plucker-coordinate   slide 46
// "inside" if U1.V2 + V1.U2 > 0
public bool checkCcw(NumericType)(Coordinate!NumericType c1, Coordinate!NumericType c2) {
	return dot(c1.u, c2.v) + dot(c1.v, c2.u) > cast(NumericType)0;
}
