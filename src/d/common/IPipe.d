module common.IPipe;

/** \brief Abstract interface for a pipe for messages
 *
 */

interface IPipe
{
   enum EnumLevel
   {
      TRACE = 0,
      DEBUG,
      INFO,
      WARN,
      ERROR,
      FATAL,
      OFF
   }
   
   /**
    * \brief ...
    */
   void init();

   /** \brief write a message to the pipe
    *
    * \param Level debug level
    * \param FunctionName name of the function
    * \param Text ...
    * \param Subsystem name of the subsystem
    */
   void write(EnumLevel Level, string FunctionName, string Text = "", string Subsystem = "");
}