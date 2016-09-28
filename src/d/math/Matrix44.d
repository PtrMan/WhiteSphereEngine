module math.Matrix44;

import linopterixed.linear.Matrix;

public Matrix!(NumericType, 4, 4) createIdentity(NumericType)() {
	NumericType one = cast(NumericType)1.0;
	NumericType zero = cast(NumericType)0.0;
	
	return new Matrix!(NumericType, 4, 4)([one, zero, zero, zero,  zero, one, zero, zero,  zero, zero, one, zero,  zero, zero, zero, one]);
}

private Matrix!(NumericType, 4, 4) createRotationXInternal(NumericType)(NumericType cosValue, NumericType sinValue) {
	NumericType one = cast(NumericType)1.0;
	NumericType zero = cast(NumericType)0.0;
	
	return new Matrix!(NumericType, 4, 4)([
         one, zero, zero, zero,
         zero,  cosValue, -sinValue, zero,
         zero,  sinValue,  cosValue, zero,
         zero, zero, zero, one
      ]);
}

private Matrix!(NumericType, 4, 4) createRotationYInternal(NumericType)(NumericType cosValue, NumericType sinValue) {
	NumericType one = cast(NumericType)1.0;
	NumericType zero = cast(NumericType)0.0;
	
	return new Matrix!(NumericType, 4, 4)([
       cosValue, zero,  sinValue, zero,
      zero, one, zero, zero,
      -sinValue, zero,  cosValue, zero,
      zero, zero, zero, one
      ]);
}

private Matrix!(NumericType, 4, 4) createRotationZInternal(NumericType)(NumericType cosValue, NumericType sinValue) {
	NumericType one = cast(NumericType)1.0;
	NumericType zero = cast(NumericType)0.0;
	
	return new Matrix!(NumericType, 4, 4)([
		cosValue, -sinValue, zero, zero,
		sinValue,  cosValue, zero, zero,
		zero, zero, one, zero,
		zero, zero, zero, one
	]);
}

import std.math : sin, cos;

public Matrix!(NumericType, 4, 4) createRotationX(NumericType)(NumericType angle) {
	return createRotationXInternal(cos(angle), sin(angle));
}

public Matrix!(NumericType, 4, 4) createRotationY(NumericType)(NumericType angle) {
	return createRotationYInternal(cos(angle), sin(angle));
}

public Matrix!(NumericType, 4, 4) createRotationZ(NumericType)(NumericType angle) {
	return createRotationZInternal(cos(angle), sin(angle));
}


public Matrix!(NumericType, 4, 4) createTranslation(NumericType)(NumericType x, NumericType y, NumericType z) {
	Matrix!(NumericType, 4, 4) result = createIdentity!NumericType();
	result[0, 3] = x;
	result[1, 3] = y;
	result[2, 3] = z;

	return result;
}

public Matrix!(NumericType, 4, 4) createScale(NumericType)(NumericType x, NumericType y, NumericType z) {
	Matrix!(NumericType, 4, 4) result = createIdentity!NumericType();
	result[0, 0] = x;
	result[1, 1] = y;
	result[2, 2] = z;
	return Result;
}
