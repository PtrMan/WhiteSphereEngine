module memory.NonGcHandle;

import MemoryAccessor;
import IDisposable : IDisposable;

class NonGcHandle(Type) : IDisposable {
	protected final this(Type* protectedPtr) {
		this.protectedPtr = protectedPtr;
	}
	
	public static NonGcHandle!Type createNotInitialized() {
		Type* ptr = cast(Type*)MemoryAccessor.allocateMemoryNoScanNoMove(Type.sizeof);
		return new NonGcHandle!Type(ptr);
	}
	
	public final void dispose() {
		if( protectedPtr !is null ) {
			MemoryAccessor.freeMemory(protectedPtr);
			protectedPtr = null;
		}
	}
	
	public final @property Type* ptr() {
		return protectedPtr;
	}
	
	public final @property Type value() {
		return *protectedPtr;
	}
	
	protected Type* protectedPtr;
}