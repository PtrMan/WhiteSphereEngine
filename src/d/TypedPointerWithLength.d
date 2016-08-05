module TypedPointerWithLength;

import MemoryAccessor;
import common.IDisposable;

// doesn't support resizing
class TypedPointerWithLength(Type) : IDisposable {
	static import MemoryAccessor;
	
	// length is in elements
	protected final this(Type *ptr, size_t length) {
		this.ptrProtected = ptr;
		this.lengthProtected = length;
	}
	
	public static TypedPointerWithLength allocate(size_t length) {
		Type* ptr = cast(Type*)MemoryAccessor.allocateMemoryNoScanNoMove(length*Type.sizeof);
		return new TypedPointerWithLength!Type(ptr, length);
	}
	
	final public void dispose() {
		if( ptrProtected is null ) {
			return;
		}
		
		MemoryAccessor.freeMemory(ptrProtected);
		
		lengthProtected = 0;
		ptrProtected = null;
	}
	
	public final Type opIndex(size_t index) {
		return ptrProtected[index];
	}
	
	public final @property Type* ptr() {
    	return ptrProtected;
    }
	
	public final @property size_t length() {
		return lengthProtected;
	}
	
	protected Type* ptrProtected = null;
	protected size_t lengthProtected = 0;
}
