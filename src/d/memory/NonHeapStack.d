module memory.NonHeapStack;

import MemoryBlock;

template NonHeapStack(Type, bool freeAccess) {
	struct NonHeapStack {
		public final void initialize() {
			memory.configure(Type.sizeof);
		}

		public final push(Type element, bool success) nothrow {
			memory.expandNeeded(numberOfElementsOnStack+1, success);
			if( !success ) {
				return;
			}

			*(cast(Type*)memory[numberOfElementsOnStack]) = element;

			numberOfElementsOnStack++;
		}

		final public void pop() nothrow {
			if( numberOfElementsOnStack == 0 ) {
				return;
			}

			numberOfElementsOnStack--;
		}

		@property final Type top() nothrow {
			return *(cast(Type*)memory[numberOfElementsOnStack-1]);
		}

		static if(freeAccess) {
			// TODO< accessor brace operators with assert for out of range>
		}

		private uint numberOfElementsOnStack = 0;
		private MemoryBlock memory;
	}
}