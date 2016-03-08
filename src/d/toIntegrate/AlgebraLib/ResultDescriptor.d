module AlgebraLib.ResultDescriptor;

/** \brief contains the result of a request
 *
 *
 */
package struct ResultDescriptor
{
	bool success; // \brief was the last request/operation successfull
	string errorMessage;

	public void reset()
	{
		success = false;
		errorMessage = "RESET";
	}
}
