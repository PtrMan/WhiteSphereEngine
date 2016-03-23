module AlgebraLib.MathExecutor;

import AlgebraLib.MathematicalOperation;
import AlgebraLib.OpenForLoopOperation;
import AlgebraLib.CloseForLoopOperation;

/**
 * used only at compile time!
 *
 *
 */
package struct MathExecutor
{
	public MathematicalOperation[] operations;

	/**
     * emits a instruction which should be optimized / executed / converted to code
	 */
	final public void emitMathematicalOperation(MathematicalOperation operation)
	{
		// we just queue it up because otimizing it now has no sense
		operations ~= operation;
	}

	/**
	 * emits a begin of a for loop
	 * 
     */
	final public void emitOpenForLoop(string variable, int startValue, int endValue)
	{
		operations ~= new OpenForLoopOperation(variable, startValue, endValue);
	}

	/**
	 * emits a ending of a for loop
	 *
	 */
	final public void emitCloseForLoop()
	{
		operations ~= new CloseForLoopOperation();
	}
}
