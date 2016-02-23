module ErrorStack;

import memory.NonHeapStack : NonHeapStack;

class ErrorStack {
	public enum EnumState {
		NORMAL = 0,
		RECOVERABLE, // a recoverable error
		FATAL // not recoverable, push and pop don't have any effect!
	}

	struct Element {
		string File;
		uint Line;
	}

	this() {
		stack.initialize();
	}

	public final void push(string File, uint Line) nothrow {
		if( StateProtected == EnumState.FATAL ) {
			return;
		}

		bool calleeSuccess;
		//stack.push(Element(File, Line), calleeSuccess);
		// we can't push the stack in the situation of a out of memory situation because we would execute an infinite loop, we just bail out
	}

	public final void pop() nothrow {
		if( StateProtected == EnumState.FATAL ) {
			return;
		}

		stack.pop();
	}

	public final setFatalError(string Message, string[] Submessages, string File, uint Line) nothrow {
		MessageProtected = Message;
		SubmessagesProtected = Submessages;

		push(File, Line);

		StateProtected = EnumState.FATAL;
	}

	public final setRecoverableError(string Message, string[] Submessages, string File, uint Line) nothrow {
		MessageProtected = Message;
		SubmessagesProtected = Submessages;

		push(File, Line);

		StateProtected = EnumState.RECOVERABLE;
	}

	public final @property bool inFatalState() nothrow {
		return StateProtected == EnumState.FATAL;
	}

	public final @property bool inRecoverableState() nothrow {
		return StateProtected == EnumState.RECOVERABLE;
	}

	public final @property bool inNormalState() nothrow {
		return StateProtected == EnumState.NORMAL;
	}

	public final @property string Message() nothrow {
		return MessageProtected;
	}

	public final @property string[] Submessages() nothrow {
		return SubmessagesProtected;
	}

	// if it is once in errorstate it can't recover!
	protected EnumState StateProtected = EnumState.NORMAL;
	protected string MessageProtected;
	protected string[] SubmessagesProtected;

	protected NonHeapStack!(Element, false) stack;
}