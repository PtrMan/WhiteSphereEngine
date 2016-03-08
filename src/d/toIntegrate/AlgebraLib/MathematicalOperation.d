module AlgebraLib.MathematicalOperation;

/**
 * Base class for all Math-Operations which are collected/transformed/executed by the MathExecutor
 *
 * used only at compile time!
 */
abstract package class MathematicalOperation
{
	public enum EnumInstructionType
	{
		VECTORSCALARMATRICES,
		OPENFORLOOP,
		CLOSEFORLOOP
	}

	this(EnumInstructionType type)
	{
		this.type = type;
	}

	public EnumInstructionType type;
}