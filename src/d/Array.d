module Array;

import MemoryAccessor;

template Array(Type, bool Movable) {
	struct Array {
		final void resize(uint newsize, out bool success) nothrow {
			success = false;
			void *newPtr = MemoryAccessor.reallocateMemoryNoScanNoMove(ptr, newsize*Type.sizeof);
			if( newPtr is null ) {
				return;
			}
			allocatedLength = newsize;

			ptr = cast(Type*)newPtr;

			success = true;
		}

		@property uint length() {
			return allocatedLength;
		}

		void opIndexAssign(Type value, size_t index) nothrow {
			if( index < allocatedLength ) {
				(cast(Type*)ptr)[index] = value;
			}
		}

		Type opIndex(size_t index) nothrow {
			if( index < allocatedLength ) {
				return (cast(Type*)ptr)[index];
			}

			// else we don't have any choice
			return (cast(Type*)ptr)[0];
		}

		int opApply(int delegate(Type) dg) {
			int result = 0;

	        for (size_t i = 0; i < this.length; i++) {
	            result = dg(this[i]);
	        }
	        
        	return result;
	    }

		protected Type *ptr = null;
		protected uint allocatedLength = 0;
	}
}