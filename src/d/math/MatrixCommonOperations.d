module math.MatrixCommonOperations;

import math.Matrix;

import AlgebraLib.InstructionTranslator;
import AlgebraLib.CompiletimeMatrixDescriptor;
import AlgebraLib.ResultDescriptor;

private string generateDOfMatrixMultiply(uint[] dimensions, string matrixnameA, string matrixnameB, string resultMatrixName) {
	InstructionTranslator instructionTranslator;

	CompiletimeMatrixDescriptor matrixA;
	CompiletimeMatrixDescriptor matrixB;
	CompiletimeMatrixDescriptor resultMatrix;

	matrixA = new CompiletimeMatrixDescriptor();

	matrixA.alignment = 4;
	matrixA.dimensions = dimensions;
	matrixA.pointerName = matrixnameA;
	matrixA.datatype = CompiletimeMatrixDescriptor.EnumDatatype.DOUBLE;

	matrixB = new CompiletimeMatrixDescriptor();

	matrixB.alignment = 4;
	matrixB.dimensions = dimensions;
	matrixB.pointerName = matrixnameB;
	matrixB.datatype = CompiletimeMatrixDescriptor.EnumDatatype.DOUBLE;

	resultMatrix = new CompiletimeMatrixDescriptor();

	resultMatrix.alignment = 4;
	resultMatrix.dimensions = dimensions;
	resultMatrix.pointerName = resultMatrixName;
	resultMatrix.datatype = CompiletimeMatrixDescriptor.EnumDatatype.DOUBLE;

	ResultDescriptor result;

	instructionTranslator = new InstructionTranslator(InstructionTranslator.EnumPerformanceTarget.EXTREMESPEED, InstructionTranslator.EnumInstructionSetTarget.DUMMY);

	instructionTranslator.multiplyMatrix(matrixA, matrixB, resultMatrix, result);

	return instructionTranslator.emitDSource();
}

private template generateDOfMatrixMultiplyTemplate(uint[] dimensions, string matrixnameA, string matrixnameB, string resultMatrixName) {
	const char[] generateDOfMatrixMultiplyTemplate = generateDOfMatrixMultiply(dimensions, matrixnameA, matrixnameB, resultMatrixName);
}

public void mul(uint width, uint height)(Matrix!(double, width, height) a, Matrix!(double, width, height) b, Matrix!(double, width, height) result) {
	mixin(generateDOfMatrixMultiplyTemplate!([width, height], "a", "b", "result"));
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
