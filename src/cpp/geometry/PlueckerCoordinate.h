#pragma once

#include "math/Vector.h"

template<typename NumericType>
struct PlueckerCoordinate {
	Vector<3, NumericType> u, v;

	static PlueckerCoordinate<NumericType> createByPandQ(Vector<3, NumericType> p, Vector<3, NumericType> q) {
		PlueckerCoordinate<NumericType> result;

		result.u = p - q;
		result.v = crossProduct(p, q);

		return result;
	}

	// could be optimized but not wirth the time to optimize
	static PlueckerCoordinate<NumericType> createByVector(Vector<3, NumericType> p, Vector<3, NumericType> dir) {
		return PlueckerCoordinate<NumericType>.createByPandQ(p, p + dir);
	}
	
	// could be optimized but not wirth the time to optimize
	static PlueckerCoordinate<NumericType> createByNegativeVector(Vector<3, NumericType> p, Vector<3, NumericType> dir) {
		return PlueckerCoordinate<NumericType>.createByPandQ(p, p - dir);
	}
};

//  see http://slidegur.com/doc/1106443/plucker-coordinate   slide 46
// "inside" if U1.V2 + V1.U2 > 0
template<typename NumericType>
bool checkCcw(PlueckerCoordinate<NumericType> c1, PlueckerCoordinate<NumericType> c2) {
	return dot(c1.u, c2.v) + dot(c1.v, c2.u) > static_cast<NumericType>(0);
}
