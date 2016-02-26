module Exceptions;

class EngineException : Exception {
	// \param fatal causes the exception a termination of the program?
	// \param passToParentThread should the exception be passed to the mainthread or handled by the owned thread?
	public this(bool fatal, bool passToParentThread, string message) {
		super(message);
		this.fatal = fatal;
		this.passToParentThread = passToParentThread;
		this.message = message;
	}
	
	public final @property bool isFatal() {
    	return fatal;
    }
	
	public final @property bool getPassToParentThread() {
		return passToParentThread;
	}
	
	public final @property string getMessage() {
		return message;
	}
	
	
	protected string message;
	protected bool fatal;
	protected bool passToParentThread;
}