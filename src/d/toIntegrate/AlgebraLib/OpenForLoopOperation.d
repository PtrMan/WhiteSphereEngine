module AlgebraLib.OpenForLoopOperation;

import AlgebraLib.MathematicalOperation;

final package class OpenForLoopOperation : MathematicalOperation
{
	// TODO< asserts for equal dimensions >
	this(string variable, int startValue, int endValue)
	{
		super(MathematicalOperation.EnumInstructionType.OPENFORLOOP);

		this.variable = variable;
		this.startValue = startValue;
		this.endValue = endValue;
	}

	public string variable;
	public int startValue;
	public int endValue;
}
