module memory.NonGcHandle;

import MemoryAccessor;
import common.IDisposable;

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
	
	public final @property Type value(Type newValue) {
		*protectedPtr = newValue;
		return newValue;
	}
	
	protected Type* protectedPtr;
}