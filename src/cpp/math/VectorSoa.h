#pragma once

/**
 * Structure of array version of vector
 * used for code which may later get SIMD easily to any width
 */
template<typename NumericType>
struct VectorSoa {
    NumericType x, y, z;

    NumericType dot(VectorSoa &other) {
        return dot(*this, other);
    }

    VectorSoa(NumericType x, NumericType y, NumericType z) {
        this->x = x;
        this->y = y;
        this->z = z;
    }

    VectorSoa() : x(static_cast<NumericType>(0)), y(static_cast<NumericType>(0)), z(static_cast<NumericType>(0)) {}

    VectorSoa operator+(const VectorSoa& other) {
        VectorSoa result;
        result.x = x + other.x;
        result.y = y + other.y;
        result.z = z + other.z;
        return result;
    }

    VectorSoa operator-(const VectorSoa& other) {
        VectorSoa result;
        result.x = x - other.x;
        result.y = y - other.y;
        result.z = z - other.z;
        return result;
    }
};

template<typename NumericType>
VectorSoa<NumericType> crossProduct(VectorSoa<NumericType> a, VectorSoa<NumericType> b) {
	VectorSoa<NumericType> result;
	result.x = a.data[1] * b.data[2] - a.data[2] * b.data[1];
	result.y = a.data[2] * b.data[0] - a.data[0] * b.data[2];
	result.z = a.data[0] * b.data[1] - a.data[1] * b.data[0];
	return result;
}

template<typename NumericType>
NumericType dot(VectorSoa<NumericType> a, VectorSoa<NumericType> b) {
	return a.x*b.x + a.y*b.y + a.z*b.z;
}
