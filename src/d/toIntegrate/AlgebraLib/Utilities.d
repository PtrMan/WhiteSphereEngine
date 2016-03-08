module AlgebraLib.Utilities;

import std.stdio;


public float vectorScalar(Type...)(Type values)
{
	enum uint LENGTH = values.length;
	enum uint HALFLENGTH = LENGTH/2;

	static if (values.length > 2)
	{
		return values[0]*values[HALFLENGTH] + vectorScalar(values[1..HALFLENGTH], values[HALFLENGTH+1..LENGTH]);
	}
	else
	{
		return values[0]*values[1];
	}
	/*
	mixin("");


	auto vectorA = values[0..values.length/2];
	auto vectorB = values[values.length/2..values.length];

	writeln(vectorA.length);
	writeln(vectorB.length);

	return vectorScalarInner(vectorA, vectorB);
	*/
	

	/*
	static if (values.length > 2)
	{
		return values[0]*values[1] + vectorScalar(values[2..values.length]);
	}
	else
	{
		return values[0]*values[1];
	}*/
}
