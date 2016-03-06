module common.LoggerPipe;

import std.stdio : writeln;

import common.IPipe;
import common.Logger;

/**  
 *
 * Pipe for logging
 */
class LoggerPipe : IPipe
{
   private Logger mLogger;
   static private string[] LevelText = ["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL", "OFF"];

   // NODOC
   final void init()
   {
      this.mLogger = new Logger();

      // NOTE< we throw the return value away, its not that clever >
      this.mLogger.openFile("log.txt");
   }

   // SEE IPipe
   final void write(IPipe.EnumLevel Level, string FunctionName, string Text = "", string Subsystem = "")
   {
      string Message;

      Message = LoggerPipe.LevelText[cast(uint)Level] ~ " " ~ FunctionName ~ " " ~ Subsystem ~ " " ~ Text;

      writeln(Message);
      this.mLogger.log(Message);
   }
}