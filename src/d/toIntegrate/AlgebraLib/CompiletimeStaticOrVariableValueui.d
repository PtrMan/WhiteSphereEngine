module AlgebraLib.CompiletimeStaticOrVariableValueUi;

package struct CompiletimeStaticOrVariableValueUi
{
	public enum EnumType
	{
		VARIABLE,
		STATIC
	}

	this(string variableName)
	{
		this.type = EnumType.VARIABLE;
		this.variableName = variableName;
	}

	this(uint value)
	{
		this.type = EnumType.STATIC;
		this.value = value;
	}

	public EnumType type;
	public string variableName;
	public uint value;
}
