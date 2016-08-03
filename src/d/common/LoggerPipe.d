module common.LoggerPipe;

import std.stdio : writeln;

import common.IShutdown;
import common.IPipe;
import common.Logger;

/**  
 *
 * Pipe for logging
 */
class LoggerPipe : IPipe, IShutdown {
	private Logger logger;
	static private string[] levelText = ["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL", "OFF"];

	// NODOC
	final void init() {
		logger = new Logger();

		// NOTE< we throw the return value away, its not that clever >
		logger.openFile("log.txt");
   }

	// SEE IPipe
	final void write(IPipe.EnumLevel level, string functionName, string text = "", string subsystem = "") {
		string message = levelText[cast(size_t)level] ~ " " ~ functionName ~ " " ~ subsystem ~ " " ~ text;

		writeln(message);
		logger.log(message);
	}
	
	final void shutdown() {
		logger.closeFile();
	}
}