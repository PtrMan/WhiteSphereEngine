module AlgebraLib.CompiletimeVector2Ui;

import AlgebraLib.CompiletimeStaticOrVariableValueUi;

/** \brief compile time vector where the fields can either be constant or a variable
 *
 *
 */
package struct CompiletimeVector2Ui
{
	this(CompiletimeStaticOrVariableValueUi x, CompiletimeStaticOrVariableValueUi y)
	{
		this.x = x;
		this.y = y;
	}

	public CompiletimeStaticOrVariableValueUi x;
	public CompiletimeStaticOrVariableValueUi y;
}