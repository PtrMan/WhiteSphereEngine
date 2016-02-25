module MemoryAccessor;

/**
 * The style of memory allocation depends on if we use the GC or not
 * 
 * This is just a thin layer around manual memory managment
 */

import Defines;

static if( MEMORY_TYPE == EnumMemoryType.GC ) {
   import core.memory;
}
else {
   import core.stdc.stdlib : malloc, realloc, free;
}

void *allocateMemoryNoScanNoMove(size_t size) nothrow {
	static if( MEMORY_TYPE == EnumMemoryType.GC ) {
       return GC.malloc(size, GC.BlkAttr.NO_SCAN | GC.BlkAttr.NO_MOVE);
    }
    else {
       return malloc(size);
    }
}

void *reallocateMemoryNoScanNoMove(void *ptr, size_t size) nothrow {
	static if( MEMORY_TYPE == EnumMemoryType.GC ) {
       return GC.realloc(ptr, size, GC.BlkAttr.NO_SCAN | GC.BlkAttr.NO_MOVE);
    }
    else {
       return realloc(ptr, size);
    }
}

void freeMemory(void *ptr) nothrow {
	static if( MEMORY_TYPE == EnumMemoryType.GC ) {
       GC.free(ptr);
    }
    else {
       free(ptr);
    }
}
