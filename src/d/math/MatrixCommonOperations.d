module math.MatrixCommonOperations;

import math.Matrix;
import math.GaussElimination : standardGaussElimination;

import AlgebraLib.InstructionTranslator;
import AlgebraLib.CompiletimeMatrixDescriptor;
import AlgebraLib.ResultDescriptor;

public Matrix!(NumericType, size, size) inverse(NumericType, uint size)(Matrix!(NumericType, size, size) input) {
	Matrix!(NumericType, size*2, size) internalMatrix = new Matrix!(NumericType, size*2, size)();
	
	// transfer input to internal matrix
	foreach( row; 0..size ) {
		foreach( column; 0..size ) {
			internalMatrix[row, column] = input[row, column];
		}
	}
	// transfer identity to internal matrix
	foreach( row; 0..size ) {
		foreach( column; 0..size ) {
			internalMatrix[row, column+size] = cast(NumericType)0.0;
		}
	}
	foreach( i; 0..size ) {
		internalMatrix[i, i+size] = cast(NumericType)1.0;
	}
	
	standardGaussElimination(internalMatrix);
	
	Matrix!(NumericType, size, size) result = new Matrix!(NumericType, size, size)();
	// transfer result from matrix to result
	foreach( row; 0..size ) {
		foreach( column; 0..size ) {
			result[row, column] = internalMatrix[row, column+size];
		}
	}
	
	return result;
}

unittest {
	import std.math : abs;
	
	Matrix!(float, 2, 2) toInverseMatrix = new Matrix!(float, 2, 2)();
	toInverseMatrix[0, 0] = 2.0f;
	toInverseMatrix[0, 1] = 1.0f;
	toInverseMatrix[1, 0] = 2.0f;
	toInverseMatrix[1, 1] = 2.0f;
	
	Matrix!(float, 2, 2) inversedMatrix = toInverseMatrix.inverse();
	assert(abs(inversedMatrix[0, 0] - 1.0f) < 0.001f);
	assert(abs(inversedMatrix[0, 1] - -0.5f) < 0.001f);
	assert(abs(inversedMatrix[1, 0] - -1.0f) < 0.001f);
	assert(abs(inversedMatrix[1, 1] - 1.0f) < 0.001f);
}

private string generateDOfMatrixMultiplyForMatrix(uint[] dimensions, string matrixnameA, string matrixnameB, string resultMatrixName) {
	InstructionTranslator instructionTranslator;

	CompiletimeMatrixDescriptor matrixA;
	CompiletimeMatrixDescriptor matrixB;
	CompiletimeMatrixDescriptor resultMatrix;

	matrixA = new CompiletimeMatrixDescriptor();

	//matrixA.alignment = 4;
	matrixA.dimensions = dimensions;
	matrixA.pointerName = matrixnameA;
	//matrixA.datatype = CompiletimeMatrixDescriptor.EnumDatatype.DOUBLE;

	matrixB = new CompiletimeMatrixDescriptor();

	//matrixB.alignment = 4;
	matrixB.dimensions = dimensions;
	matrixB.pointerName = matrixnameB;
	//matrixB.datatype = CompiletimeMatrixDescriptor.EnumDatatype.DOUBLE;

	resultMatrix = new CompiletimeMatrixDescriptor();

	//resultMatrix.alignment = 4;
	resultMatrix.dimensions = dimensions;
	resultMatrix.pointerName = resultMatrixName;
	//resultMatrix.datatype = CompiletimeMatrixDescriptor.EnumDatatype.DOUBLE;

	ResultDescriptor result;

	instructionTranslator = new InstructionTranslator(InstructionTranslator.EnumPerformanceTarget.EXTREMESPEED, InstructionTranslator.EnumInstructionSetTarget.DUMMY);

	instructionTranslator.multiplyMatrix(matrixA, matrixB, resultMatrix, result);

	return instructionTranslator.emitDSource();
}

private string generateDOfMatrixMultiplyForVector(uint[] dimensions, string matrixnameA, string matrixnameB, string resultMatrixName) {
	InstructionTranslator instructionTranslator;

	CompiletimeMatrixDescriptor matrixA;
	CompiletimeMatrixDescriptor matrixB;
	CompiletimeMatrixDescriptor resultMatrix;

	matrixA = new CompiletimeMatrixDescriptor();

	//matrixA.alignment = 4;
	matrixA.dimensions = dimensions;
	matrixA.pointerName = matrixnameA;
	//matrixA.datatype = CompiletimeMatrixDescriptor.EnumDatatype.DOUBLE;

	matrixB = new CompiletimeMatrixDescriptor();

	//matrixB.alignment = 4;
	matrixB.dimensions = [1, dimensions[1]];
	matrixB.pointerName = matrixnameB;
	//matrixB.datatype = CompiletimeMatrixDescriptor.EnumDatatype.DOUBLE;

	resultMatrix = new CompiletimeMatrixDescriptor();

	//resultMatrix.alignment = 4;
	resultMatrix.dimensions = [1, dimensions[1]];
	resultMatrix.pointerName = resultMatrixName;
	//resultMatrix.datatype = CompiletimeMatrixDescriptor.EnumDatatype.DOUBLE;

	ResultDescriptor result;

	instructionTranslator = new InstructionTranslator(InstructionTranslator.EnumPerformanceTarget.EXTREMESPEED, InstructionTranslator.EnumInstructionSetTarget.DUMMY);

	instructionTranslator.multiplyMatrix(matrixA, matrixB, resultMatrix, result);

	return instructionTranslator.emitDSource();
}

private template generateDOfMatrixMultiplyForMatrixTemplate(uint[] dimensions, string matrixnameA, string matrixnameB, string resultMatrixName) {
	const char[] generateDOfMatrixMultiplyForMatrixTemplate = generateDOfMatrixMultiplyForMatrix(dimensions, matrixnameA, matrixnameB, resultMatrixName);
}

private template generateDOfMatrixMultiplyForVectorTemplate(uint[] dimensions, string matrixnameA, string matrixnameB, string resultMatrixName) {
	const char[] generateDOfMatrixMultiplyForVectorTemplate = generateDOfMatrixMultiplyForVector(dimensions, matrixnameA, matrixnameB, resultMatrixName);
}

public void mul(NumericType, uint width, uint height)(Matrix!(NumericType, width, height) a, Matrix!(NumericType, width, height) b, Matrix!(NumericType, width, height) result) {
	mixin(generateDOfMatrixMultiplyForMatrixTemplate!([width, height], "a", "b", "result"));
}

public void mulVector(NumericType, uint width, uint height)(Matrix!(NumericType, width, height) a, Matrix!(NumericType, 1, height) b, Matrix!(NumericType, 1, height) result) {
	mixin(generateDOfMatrixMultiplyForVectorTemplate!([width, height], "a", "b", "result"));
}
	
unittest {
	Matrix!(double, 2, 2) a = new Matrix!(double, 2, 2)();
	Matrix!(double, 2, 2) b = new Matrix!(double, 2, 2)();
	Matrix!(double, 2, 2) result = new Matrix!(double, 2, 2)();
	
	a[0, 0] = 1.0;
	a[0, 1] = 5.0;
	a[1, 0] = -1.0;
	a[1, 1] = 5.0;
	
	b[0, 0] = 0.5;
	b[0, 1] = -0.5;
	b[1, 0] = 0.1;
	b[1, 1] = 0.1;
	
	//mixin(GenStruct!("Foo", "bar"));
	mul(a, b, result);
	
	import std.math : abs;
	
	assert(result[0,0] == 1.0);
	assert(abs(result[0,1]) < 0.00001);
	assert(abs(result[1,0]) < 0.00001);
	assert(result[1,1] == 1.0);
}

unittest {
	Matrix!(double, 2, 2) a = new Matrix!(double, 2, 2)();
	Matrix!(double, 1, 2) b = new Matrix!(double, 1, 2)();
	Matrix!(double, 1, 2) result = new Matrix!(double, 1, 2)();
	
	a[0, 0] = 1.0;
	a[0, 1] = 0.0;
	a[1, 0] = 0.0;
	a[1, 1] = 1.0;
	
	b[0, 0] = 5.0;
	b[1, 0] = 4.0;
	
	mulVector(a, b, result);
	
	assert(result[0, 0] == 5.0);
	assert(result[1, 0] == 4.0);
}
