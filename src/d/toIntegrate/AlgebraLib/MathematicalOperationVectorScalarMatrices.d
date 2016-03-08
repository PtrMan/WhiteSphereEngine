module AlgebraLib.MathematicalOperationVectorScalarMatrices;

import AlgebraLib.CompiletimeVector2Ui;
import AlgebraLib.CompiletimeMatrixDescriptor;
import AlgebraLib.MathematicalOperation;

final package class MathematicalOperationVectorScalarMatrices : MathematicalOperation
{
	// TODO< asserts for equal dimensions >
	this(
		CompiletimeMatrixDescriptor descriptorMatrixA,
		CompiletimeVector2Ui startIndexA,
		uint[2] directionA,
		CompiletimeMatrixDescriptor descriptorMatrixB,
		CompiletimeVector2Ui startIndexB,
		uint[2] directionB,
		CompiletimeMatrixDescriptor descriptorResult,
		CompiletimeVector2Ui resultIndex)
	{
		super(MathematicalOperation.EnumInstructionType.VECTORSCALARMATRICES);

		this.descriptorMatrixA = descriptorMatrixA;
		this.descriptorMatrixB = descriptorMatrixB;

		this.startIndexA = startIndexA;
		this.startIndexB = startIndexB;

		this.directionA = directionA;
		this.directionB = directionB;

		this.descriptorResult = descriptorResult;
		this.resultIndex = resultIndex;
	}

	public CompiletimeMatrixDescriptor descriptorMatrixA;
	public CompiletimeMatrixDescriptor descriptorMatrixB;

	public CompiletimeVector2Ui startIndexA;
	public CompiletimeVector2Ui startIndexB;

	public uint[2] directionA;
	public uint[2] directionB;

	public CompiletimeMatrixDescriptor descriptorResult;
	public CompiletimeVector2Ui resultIndex;
}