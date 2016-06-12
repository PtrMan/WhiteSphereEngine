#pragma once

#include <cmath>

#include "Defines.h"

template<unsigned size, typename NumericType>
struct Vector {
    NumericType ALIGN_16 data[size];

    NumericType dot(Vector &other) {
        return dot(*this, other);
    }

    /*
    Vector(NumericType x, NumericType y, NumericType z) {
        this->x = x;
        this->y = y;
        this->z = z;
    }
    */

    Vector() {
        for( unsigned i = 0; i < size; i++ ) {
            data[i] = static_cast<NumericType>(0);
        }
    }

    Vector operator+(const Vector& other) const {
        Vector result;
        for( unsigned i = 0; i < size; i++ ) {
            result.data[i] = data[i] + other.data[i];
        }
        return result;
    }

    
    Vector operator-(const Vector& other) const {
        Vector result;
        for( unsigned i = 0; i < size; i++ ) {
            result.data[i] = data[i] - other.data[i];
        }
        return result;
    }

    Vector calcNormalized() const {
        NumericType length = calcLength();
        Vector result;
        for( unsigned i = 0; i < size; i++ ) {
            result.data[i] = data[i] / length;
        }
        return result;
    }

    NumericType calcLength() const {
        NumericType temp = data[0]*data[0];

        for( unsigned i = 1; i < size; i++ ) {
            temp += (data[i]*data[i]);
        }

        return sqrt(temp);
    }

    Vector scale(NumericType scalar) const {
        Vector result;
        for( unsigned i = 0; i < size; i++ ) {
            result.data[i] = data[i]*scalar;
        }
        return result;
    }
};

template<unsigned size, typename NumericType>
NumericType& x(Vector<size, NumericType> vector) {
    return vector.data[0];
}

template<unsigned size, typename NumericType>
NumericType& y(Vector<size, NumericType> vector) {
    return vector.data[1];
}

template<unsigned size, typename NumericType>
NumericType& z(Vector<size, NumericType> vector) {
    return vector.data[2];
}

template<typename NumericType>
Vector<3, NumericType> crossProduct(Vector<3, NumericType> a, Vector<3, NumericType> b) {
    Vector<3, NumericType> result;
    result.data[0] = a.data[1] * b.data[2] - a.data[2] * b.data[1];
    result.data[1] = a.data[2] * b.data[0] - a.data[0] * b.data[2];
    result.data[2] = a.data[0] * b.data[1] - a.data[1] * b.data[0];
    return result;
}

template<typename NumericType>
NumericType dot(Vector<3, NumericType> a, Vector<3, NumericType> b) {
    return a.data[0]*b.data[0] + a.data[1]*b.data[1] + a.data[2]*b.data[2];
}
