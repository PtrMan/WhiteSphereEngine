import Queue;

import std.stdio;

void main(string[] args) {
	{
		QueueNonConcurrentGcArray!uint queue = new QueueNonConcurrentGcArray!uint();

		queue.insert(42);
		queue.insert(13);

		bool peekSucceeded;
		uint readElement;
		queue.peek(peekSucceeded, readElement);
		writeln(readElement);

		queue.peek(peekSucceeded, readElement);
		writeln(readElement);

	}


	{
		QueueConcurrentBlockingGcArray!uint queue = new QueueConcurrentBlockingGcArray!uint();

		queue.insert(42);
		queue.insert(13);

		bool peekSucceeded;
		uint readElement;
		queue.peek(peekSucceeded, readElement);
		writeln(readElement);

		queue.peek(peekSucceeded, readElement);
		writeln(readElement);
	}

}
