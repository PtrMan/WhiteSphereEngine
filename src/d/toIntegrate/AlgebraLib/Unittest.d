// is in a seperate file because unittests in the heavily decouped library have no sense

// compile with unittest

module Unittest;

import AlgebraLib.InstructionTranslator;
import AlgebraLib.CompiletimeMatrixDescriptor;
import AlgebraLib.ResultDescriptor;

import std.math;
import std.algorithm;

import std.stdio;

float getMaxDifference(float[] a, float[] b)
{
	float maxDifference;

	maxDifference = std.math.abs(a[0] - b[0]);

	foreach( i; 0..a.length )
	{
		maxDifference = max(maxDifference, std.math.abs(a[i] - b[i]));
	}

	return maxDifference;
}

string generateDSourceForPerformanceTarget(InstructionTranslator.EnumPerformanceTarget performanceTarget)
{
	InstructionTranslator instructionTranslator;

	CompiletimeMatrixDescriptor matrixA;
	CompiletimeMatrixDescriptor matrixB;
	CompiletimeMatrixDescriptor resultMatrix;

	matrixA = new CompiletimeMatrixDescriptor();

	matrixA.alignment = 4;
	matrixA.dimensions = [4, 4];
	matrixA.pointerName = "matrixA";
	matrixA.datatype = CompiletimeMatrixDescriptor.EnumDatatype.FLOAT;

	matrixB = new CompiletimeMatrixDescriptor();

	matrixB.alignment = 4;
	matrixB.dimensions = [4, 4];
	matrixB.pointerName = "matrixB";
	matrixB.datatype = CompiletimeMatrixDescriptor.EnumDatatype.FLOAT;

	resultMatrix = new CompiletimeMatrixDescriptor();

	resultMatrix.alignment = 4;
	resultMatrix.dimensions = [4, 4];
	resultMatrix.pointerName = "resultMatrix";
	resultMatrix.datatype = CompiletimeMatrixDescriptor.EnumDatatype.FLOAT;



	ResultDescriptor result;

	instructionTranslator = new InstructionTranslator(performanceTarget, InstructionTranslator.EnumInstructionSetTarget.DUMMY);

	instructionTranslator.multiplyMatrix(matrixA, matrixB, resultMatrix, result);

	return instructionTranslator.emitDSource();
}

// unittest Matrix multiplication, Extreme speed
unittest
{
	import AlgebraLib.Utilities;

	
	// dynamic arrays to avoid compiletime optimization
	float[] matrixA;
	float[] matrixB;
	float[] resultMatrix;
	float[] rightResultMatrix;

	matrixA = new float[16];
	matrixB = new float[16];
	resultMatrix = new float[16];

	// TODO< initialize >

	matrixA = [
	-0.863664, 0.395179, -0.838635, -0.315353,
	0.019075, -0.834371, 0.405376, -0.851591,
	-0.0874817, 0.760162, -0.650869, -0.0290577, 
	0.228632, -0.790934, 0.412569, 0.186309
	];

	matrixB = [
	-0.781857, -0.3493, 0.799236, 0.0205221,
	0.438053, 0.447842, 0.0234373, -0.793608,
	-0.794847, 0.195374, -0.55925, 0.569059,
	-0.91299, -0.420419, -0.484681, -0.41308
	];

	rightResultMatrix = [
	1.80287, 0.447388, -0.0591574, -0.678308,
	0.074869, 0.0568959, 0.181733, 1.24501,
	0.94526, 0.256044, 0.32598, -0.963446,
	-1.02326, -0.431798, -0.156836, 0.790199
	];
	
	mixin(generateDSourceForPerformanceTarget(InstructionTranslator.EnumPerformanceTarget.EXTREMESPEED));

	// TODO< check >

	writeln(getMaxDifference(resultMatrix, rightResultMatrix));
	
	writeln(resultMatrix);
}
