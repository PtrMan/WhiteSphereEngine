#pragma once

#include "math/Vector.h"

// from http://gamedev.stackexchange.com/a/23745/29278
// Compute barycentric coordinates (u, v, w) for
// point p with respect to triangle (a, b, c)
template<typename NumericType>
void calcBarycentricCoordinates(Vector<3, NumericType> p, Vector<3, NumericType> a, Vector<3, NumericType> b, Vector<3, NumericType> c, NumericType &u, NumericType &v, NumericType &w) {
    Vector<3, NumericType> v0 = b - a, v1 = c - a, v2 = p - a;
    NumericType d00 = dot(v0, v0);
    NumericType d01 = dot(v0, v1);
    NumericType d11 = dot(v1, v1);
    NumericType d20 = dot(v2, v0);
    NumericType d21 = dot(v2, v1);
    NumericType denom = d00 * d11 - d01 * d01;
    v = (d11 * d20 - d01 * d21) / denom;
    w = (d00 * d21 - d01 * d20) / denom;
    u = static_cast<NumericType>(1) - v - w;
}
