import AlgebraLib.InstructionTranslator;
import AlgebraLib.CompiletimeMatrixDescriptor;
import AlgebraLib.ResultDescriptor;

import std.stdio;

void main(string[] arguments)
{
	InstructionTranslator instructionTranslator;

	CompiletimeMatrixDescriptor matrixA;
	CompiletimeMatrixDescriptor matrixB;
	CompiletimeMatrixDescriptor resultMatrix;

	matrixA = new CompiletimeMatrixDescriptor();

	//matrixA.alignment = 4;
	matrixA.dimensions = [4, 4];
	matrixA.pointerName = "matrixA";
	//matrixA.datatype = CompiletimeMatrixDescriptor.EnumDatatype.FLOAT;

	matrixB = new CompiletimeMatrixDescriptor();

	//matrixB.alignment = 4;
	matrixB.dimensions = [4, 4];
	matrixB.pointerName = "matrixB";
	//matrixB.datatype = CompiletimeMatrixDescriptor.EnumDatatype.FLOAT;

	resultMatrix = new CompiletimeMatrixDescriptor();

	//resultMatrix.alignment = 4;
	resultMatrix.dimensions = [4, 4];
	resultMatrix.pointerName = "resultMatrix";
	//resultMatrix.datatype = CompiletimeMatrixDescriptor.EnumDatatype.FLOAT;



	ResultDescriptor result;

	instructionTranslator = new InstructionTranslator(InstructionTranslator.EnumPerformanceTarget.EXTREMESPEED, InstructionTranslator.EnumInstructionSetTarget.DUMMY);

	instructionTranslator.multiplyMatrix(matrixA, matrixB, resultMatrix, result);

	writeln(result.success);

	writeln(instructionTranslator.emitDSource());
}