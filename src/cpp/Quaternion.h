#pragma once

#include <cmath>

#include "math/Vector.h"

template<typename T>
struct Quaternion {
	Vector<3, T> v;
    T w;

    // from the book "Math Primer for Graphics and Game Development"
    // page 252
	Quaternion mul(Quaternion &other) {
		Quaternion result;
        result.w = w*other.w - dot(v, other.v);
        result.v = other.v.scale(w) + v.scale(other.w) + crossProduct(v, other.v);
		return result;
	}

    // http://mathworld.wolfram.com/QuaternionConjugate.html
	Quaternion conjugate() {
		Quaternion result;
		result.w = w;
		result.v = -v;
		return result;
    }

    // https://wiki.delphigl.com/index.php/Quaternion
    Quaternion scale(T scalar) {
    	Quaternion result;
		result.w = w * scalar;
		result.v = v * scalar;
		return result;
    }

    // from the book "Math Primer for Graphics and Game Development"
    // page 250
    T magnitude() {
    	return sqrt(w*w + v.squaredLength());
    }

    // https://wiki.delphigl.com/index.php/Quaternion
    Quaternion inverse() {
        T mag = magnitude();
        mag = mag * mag;

        // TODO< catch error >
        //if (mag == 0.0) return null;
        
        return conjugate().scale(static_cast<T>(1.0) / mag);
    }

    // from the book "Math Primer for Graphics and Game Development"
    // page 284
    Matrix<3, 3, T> getRotationMatrix() {
        T x = x(v), y = y(v), z = z(v);

        Matrix<3, 3, T> matrix;

        // matrix is  x y
        matrix.at(0, 0) = static_cast<NumericType>(1) - static_cast<NumericType>(2)*pow<2>(y) - static_cast<NumericType>(2)*pow<2>(z);
        matrix.at(1, 0) = static_cast<NumericType>(2)*x*y + static_cast<NumericType>(2)*w*z;
        matrix.at(2, 0) = static_cast<NumericType>(2)*x*z - static_cast<NumericType>(2)*w*y;

        matrix.at(0, 1) = static_cast<NumericType>(2)*x*y - static_cast<NumericType>(2)*w*z;
        matrix.at(1, 1) = static_cast<NumericType>(1) - static_cast<NumericType>(2)*pow<2>(x) - static_cast<NumericType>(2)*pow<2>(z);
        matrix.at(2, 1) = static_cast<NumericType>(2)*y*z + static_cast<NumericType>(2)*w*x;

        matrix.at(0, 2) = static_cast<NumericType>(2)*x*z + static_cast<NumericType>(2)*w*y;
        matrix.at(1, 2) = static_cast<NumericType>(2)*y*z - static_cast<NumericType>(2)*w*x;
        matrix.at(2, 2) = static_cast<NumericType>(1) - static_cast<NumericType>(2)*pow<2>(x) - static_cast<NumericType>(2)*pow<2>(y);

        return matrix;
    }

    // TODO< constructor by axis and angle, explained here https://www.youtube.com/watch?v=WN3_d_QcJZE (TODO, search exact position) >

    // TODO< lerp >

    // TODO< dot product from book "Math Primer for Graphics and Game Development" >
};
