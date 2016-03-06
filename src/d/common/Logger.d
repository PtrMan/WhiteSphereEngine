module common.Logger;

import std.stdio : File, StdioException;

class Logger
{
	private File FileH;
	private bool Opened = false;

	/** \brief open a log file
	 *
	 * \param Name ...
	 * \return ...
	 */
	final bool openFile(string Name)
	{
		// NOTE< should we check for an allready opened file? >

		try
		{
			this.FileH = File(Name, "wa");
		}
		catch( StdioException Exception )
		{
			return false;
		}

		this.Opened = true;

		return true;
	}

	/** \brief ...
	 *
	 */
	final void closeFile()
	{
		if( !this.Opened )
		{
			return;
		}

		this.FileH.close();
	}

	/** \brief ...
	 *
	 * \param Text ...
	 */
	final void log(string Text)
	{
		if( !this.Opened )
		{
			return;
		}

		this.FileH.write(Text ~ "\n");
		this.FileH.flush();
	}
}