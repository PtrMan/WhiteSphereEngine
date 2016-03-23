module AlgebraLib.InstructionTranslator;

// TODO< remove >
import std.conv;

import AlgebraLib.MathExecutor;
import AlgebraLib.CompiletimeMatrixDescriptor;
import AlgebraLib.ResultDescriptor;
import AlgebraLib.CompiletimeVector2Ui;
import AlgebraLib.CompiletimeStaticOrVariableValueUi;
import AlgebraLib.MathematicalOperationVectorScalarMatrices;

import AlgebraLib.OpenForLoopOperation;
import AlgebraLib.CloseForLoopOperation;
import AlgebraLib.MathematicalOperation;

// debugging
import std.stdio;

/**
 * 
 * translates matrix operation instructions into instructions
 * these instructions can be splited into other instructions down to atomic instructions/function calls
 *
 * only for compiletime
 */
// NOTE< for testing public, actually package >
public class InstructionTranslator {
	// target can be either extreme speed
	// or a tradeoff
	// or a most compact representation of the code
	enum EnumPerformanceTarget {
		EXTREMESPEED,
		TRADEOFF,
		COMPACT
	}

	// is the prefered resulting instructionsetTarget
	enum EnumInstructionSetTarget {
		DUMMY, // No code output, just for testing of the library
		FUNCTIONCALLS, // only function calls to internal methods
		/*FPU,
		SSE1,
		SSE2,
		SSSE3,
		SSE4,
		SSE41,
		AVX,
		AVX2*/
	}

	final public this(EnumPerformanceTarget performanceTarget, EnumInstructionSetTarget instructionSetTarget) {
		this.performanceTarget = performanceTarget;
		this.instructionSetTarget = instructionSetTarget;
	}

	final public void multiplyMatrix(CompiletimeMatrixDescriptor matrixA, CompiletimeMatrixDescriptor matrixB, CompiletimeMatrixDescriptor resultMatrix, ref ResultDescriptor result) {
		MathematicalOperationVectorScalarMatrices scalarOperation;

		result.reset();

		if (
			(matrixA.dimensions[0] != matrixB.dimensions[1]) ||
			(matrixA.dimensions[1] != resultMatrix.dimensions[1]) ||
			(matrixB.dimensions[0] != resultMatrix.dimensions[0])
		) {
			result.errorMessage = "marices " ~ matrixA.pointerName ~ " and " ~ matrixB.pointerName ~ " are of incompatible size for multiplication";
			return;
		}

		// emit instructions for the multiplication of the matrices

		if( performanceTarget == EnumPerformanceTarget.TRADEOFF ) {
			// code gen
			executor.emitOpenForLoop("resultY", 0, matrixA.dimensions[1]);
			
			foreach( resultX; 0..matrixB.dimensions[0] ) {
				executor.emitMathematicalOperation(
					new MathematicalOperationVectorScalarMatrices(
						matrixA,
						CompiletimeVector2Ui(CompiletimeStaticOrVariableValueUi(0), CompiletimeStaticOrVariableValueUi("resultY")),
						[1, 0],

						matrixB,
						CompiletimeVector2Ui(CompiletimeStaticOrVariableValueUi(resultX), CompiletimeStaticOrVariableValueUi(0)),
						[0, 1],

						/* result-> */ resultMatrix,
						CompiletimeVector2Ui(CompiletimeStaticOrVariableValueUi(resultX), CompiletimeStaticOrVariableValueUi("resultY"))
					)
				);
			}
			
			executor.emitCloseForLoop();
		}
		else if( performanceTarget == EnumPerformanceTarget.EXTREMESPEED ) {
			// code gen
			foreach( resultY; 0..matrixA.dimensions[1] )		 {
				foreach( resultX; 0..matrixB.dimensions[0] ) {
					executor.emitMathematicalOperation(
						new MathematicalOperationVectorScalarMatrices(
							matrixA,
							CompiletimeVector2Ui(CompiletimeStaticOrVariableValueUi(0), CompiletimeStaticOrVariableValueUi(resultY)),
							[1, 0],

							matrixB,
							CompiletimeVector2Ui(CompiletimeStaticOrVariableValueUi(resultX), CompiletimeStaticOrVariableValueUi(0)),
							[0, 1],

							/* result-> */ resultMatrix,
							CompiletimeVector2Ui(CompiletimeStaticOrVariableValueUi(resultX), CompiletimeStaticOrVariableValueUi(resultY))
						)
					);
				}
			}
		}
		

		result.success = true;
	}

	// TODO< put this functionality into a own class >

	/** \brief returns the resulting code of all operations
	 *
	 *
	 */
	final public string emitDSource() {
		string resultDString;

		resultDString = "{";

		resultDString ~= "import AlgebraLib.Utilities;\n\n";

		foreach( iterationOperation; executor.operations ) {
			final switch(iterationOperation.type) {
				case MathematicalOperation.EnumInstructionType.VECTORSCALARMATRICES:
				resultDString ~= emitStringForVectorScalarMatrices(cast(MathematicalOperationVectorScalarMatrices) iterationOperation);
				break;

				case MathematicalOperation.EnumInstructionType.OPENFORLOOP:
				resultDString ~= emitStringForOpenForLoop(cast(OpenForLoopOperation) iterationOperation);
				break;

				case MathematicalOperation.EnumInstructionType.CLOSEFORLOOP:
				resultDString ~= emitStringForCloseForLoop(cast(CloseForLoopOperation) iterationOperation);
				break;
			}
		}

		resultDString ~= "}\n";

		return resultDString;
	}

	final private string emitStringForOpenForLoop(OpenForLoopOperation operation) {
		string result;

		result = "foreach(" ~ operation.variable ~ ";" ~ to!string(operation.startValue) ~ ".." ~ to!string(operation.endValue) ~ ")\n";
		result = result ~ "{\n";

		return result;
	}

	final private string emitStringForCloseForLoop(CloseForLoopOperation operation) {
		return "}\n";
	}

	final private string emitStringForVectorScalarMatrices(MathematicalOperationVectorScalarMatrices operation) {
		string getStringForMatrixAccess(CompiletimeMatrixDescriptor matrixDescriptor, CompiletimeVector2Ui index) {
			string stringOfRow, stringOfColumn;
			
			if( index.x.type == CompiletimeStaticOrVariableValueUi.EnumType.VARIABLE ){
				stringOfColumn = index.x.variableName;
			}
			else if( index.x.type == CompiletimeStaticOrVariableValueUi.EnumType.STATIC ) {
				stringOfColumn = to!string(index.x.value);
			}
			else {
				assert(false);
			}
			
			if( index.y.type == CompiletimeStaticOrVariableValueUi.EnumType.VARIABLE ){
				stringOfRow = index.x.variableName;
			}
			else if( index.y.type == CompiletimeStaticOrVariableValueUi.EnumType.STATIC ) {
				stringOfRow = to!string(index.y.value);
			}
			else {
				assert(false);
			}
			
			return matrixDescriptor.pointerName ~ "[" ~ stringOfRow ~ "," ~ stringOfColumn ~ "]";
		}

		string result;

		// TODO< string of datatype >
		
		result = getStringForMatrixAccess(operation.descriptorResult, operation.resultIndex) ~ " = " ~ "AlgebraLib.Utilities.vectorScalar(";

		// input A

		if( operation.directionA == [1, 0] ) {
			assert(operation.startIndexA.x.type == CompiletimeStaticOrVariableValueUi.EnumType.STATIC);

			foreach( indexX; operation.startIndexA.x.value..operation.descriptorMatrixA.dimensions[0] ) {
				result ~= getStringForMatrixAccess(
					operation.descriptorMatrixA,
					CompiletimeVector2Ui(
						CompiletimeStaticOrVariableValueUi(indexX),
						operation.startIndexA.y
					)
				);
				result ~= ", ";
			}
		}
		else if( operation.directionA == [0, 1] ) {
			assert(operation.startIndexA.y.type == CompiletimeStaticOrVariableValueUi.EnumType.STATIC);

			foreach( indexY; operation.startIndexA.y.value..operation.descriptorMatrixA.dimensions[1] ) {
				result ~= getStringForMatrixAccess(
					operation.descriptorMatrixA,
					CompiletimeVector2Ui(
						operation.startIndexA.x,
						CompiletimeStaticOrVariableValueUi(indexY),
					)
				);
				result ~= ", ";
			}
		}
		else {
			assert(false);
		}


		// input B

		if( operation.directionB == [1, 0] ) {
			assert(operation.startIndexB.x.type == CompiletimeStaticOrVariableValueUi.EnumType.STATIC);

			foreach( indexX; operation.startIndexB.x.value..operation.descriptorMatrixB.dimensions[0] ) {
				result ~= getStringForMatrixAccess(
					operation.descriptorMatrixB,
					CompiletimeVector2Ui(
						CompiletimeStaticOrVariableValueUi(indexX),
						operation.startIndexB.y
					)
				);

				if( indexX != operation.descriptorMatrixB.dimensions[0]-1 ) {
					result ~= ", ";
				}
			}
		}
		else if( operation.directionB == [0, 1] ) {
			assert(operation.startIndexB.y.type == CompiletimeStaticOrVariableValueUi.EnumType.STATIC);

			foreach( indexY; operation.startIndexB.y.value..operation.descriptorMatrixB.dimensions[1] ) {
				result ~= getStringForMatrixAccess(
					operation.descriptorMatrixB,
					CompiletimeVector2Ui(
						operation.startIndexB.x,
						CompiletimeStaticOrVariableValueUi(indexY),
					)
				);

				if( indexY != operation.descriptorMatrixB.dimensions[1]-1 ) {
					result ~= ", ";
				}
			}
		}
		else {
			assert(false);
		}

		result ~= ");\n";

		return result;
	}

	private MathExecutor executor;
	private EnumPerformanceTarget performanceTarget;
	private EnumInstructionSetTarget instructionSetTarget;
}
