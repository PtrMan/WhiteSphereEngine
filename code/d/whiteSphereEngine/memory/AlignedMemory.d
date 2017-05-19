module whiteSphereEngine.memory.AlignedMemory;

import core.stdc.stdlib : malloc, realloc, free;

import helpers.alignment;

// thin layer over raw memory for algined memory
struct AlignedMemory(uint alignment) {
	final void allocate(size_t size) {
		assert(rawPtr is null);

		rawPtr = malloc(size+alignment);
		if( rawPtr is null ) {
			throw new Exception("Memory allocation failed!");
		}

		alignedPtr = alignPtr(rawPtr, alignment);
	}

	final void allocate(size_t length, size_t size) {
		allocate(length * size);
	}

	final void resize(size_t newSize) {
		assert(rawPtr !is null);

		void *newPtr = realloc(rawPtr, newSize + alignment);
		if( newPtr is null ) {
			throw new Exception("Memory allocation failed!");
		}

		rawPtr = newPtr;

		alignedPtr = alignPtr(rawPtr, alignment);
	}

	final void free() {
		assert(rawPtr !is null);

		.free(rawPtr);

		rawPtr = null;
		alignedPtr = null;
	}

	final @property Type* ptr(Type)() pure const {
		assert(alignedPtr !is null);

		return cast(Type*)alignedPtr;
	}

	private static void* alignPtr(void *ptr, size_t alignment) {
		return cast(void*)alignAt!size_t(cast(size_t)ptr, alignment);
	}

	private void *rawPtr;
	private void *alignedPtr;
}
