module BufferCppBinding;

import core.stdc.stdlib : malloc;

import Buffer : Buffer;

import Vector : Vector;
import Array : Array;

extern (C++) void *createBufferCppBinding() {
	Buffer ptr = new Buffer();
	return cast(void*)ptr;
}

extern (C++) void BufferCppBindingCallconfigure(void *thisPtr, int *typePtr, uint typesLength, int *returnCode) {
	Buffer.EnumConfigureResult calleeReturnCode;
	Array!(Buffer.EnumDatatype, true) types;

	bool calleeSuccess;
	types.resize(typesLength, calleeSuccess);
	if( !calleeSuccess ) {
		*returnCode = Buffer.EnumConfigureResult.OUTOFMEMORY;
		return;
	}

	for( int i = 0; i < typesLength; i++ ) {
		types[i] = cast(Buffer.EnumDatatype)typePtr[i];
	}

	(cast(Buffer)thisPtr).configure(types, calleeReturnCode);
	*returnCode = cast(int)calleeReturnCode;
}

extern (C++) void BufferCppBindingCallsetPolygonCount(void *thisPtr, uint Count, bool *Success) {
	bool CalleeSuccess;
	(cast(Buffer)thisPtr).setPolygonCount(Count, CalleeSuccess);
	*Success = CalleeSuccess;
}


extern (C++) void BufferCppBindingCallsetVertexIndex(void *thisPtr, uint ArrayIndex, uint VertexIndex) {
	(cast(Buffer)thisPtr).setVertexIndex(ArrayIndex, VertexIndex);
}

extern (C++) void BufferCppBindingCallsetVerticesCount(void *thisPtr, uint Count, bool *Success) {
	bool CalleeSuccess;
	(cast(Buffer)thisPtr).setVerticesCount(Count, CalleeSuccess);
	*Success = CalleeSuccess;
}

extern (C++) void BufferCppBindingCallsetPosition(void *thisPtr, uint Index, float *Position) {
	Vector!(3, float, true) PositionIntern = new Vector!(3, float, true)(Position[0], Position[1], Position[2]);
	(cast(Buffer)thisPtr).setPosition(Index, PositionIntern);
}

extern (C++) void BufferCppBindingCallsetData(void *thisPtr, uint Index, uint TypeIndex, float *Data) {
	Vector!(3, float, true) DataIntern;
	DataIntern.X = Data[0];
	DataIntern.Y = Data[1];
	DataIntern.Z = Data[2];
	(cast(Buffer)thisPtr).setData(Index, TypeIndex, DataIntern);
}

extern (C++) void BufferCppBindingCallbindThis(void *thisPtr) {
  	(cast(Buffer)thisPtr).bindThis();
	}

extern (C++) void BufferCppBindingCalldrawThis(void *thisPtr) {
  	(cast(Buffer)thisPtr).drawThis();
	}

extern (C++) void BufferCppBindingCallbindNone(void *thisPtr) {
	(cast(Buffer)thisPtr).bindNone();
}

extern (C++) void BufferCppBindingCalltoModifyState(void *thisPtr, bool *Success) {
	bool CalleeSuccess;
	(cast(Buffer)thisPtr).toModifyState(CalleeSuccess);
	*Success = CalleeSuccess;
}

extern (C++) void BufferCppBindingCalltoBuiltState(void *thisPtr, int *ReturnCode) {
	Buffer.EnumBuildBufferResult ReturnCodeIntern;
	(cast(Buffer)thisPtr).toBuiltState(ReturnCodeIntern);
	*ReturnCode = cast(Buffer.EnumBuildBufferResult)ReturnCodeIntern;
}

extern (C++) void BufferCppBindingCallrelease(void *thisPtr) {
	(cast(Buffer)thisPtr).release();
}


/*
extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall

extern (C++) void BufferCppBindingCall
*/

/* old more C++ ish try
extern (C++) interface BufferCppBindingInterface {
	void construct();
    void configure(int *typePtr, uint typesLength, int *returnCode);
    void setPolygonCount(uint Count, bool *Success);
    void setVertexIndex(uint ArrayIndex, uint VertexIndex);
    void setVerticesCount(uint Count, bool *Success);
    void setPosition(uint Index, float *Position);
    void setData(uint Index, uint TypeIndex, float *Data);
    void bindThis();
    void drawThis();
    void bindNone();
   	void toModifyState(bool *Success);
   	void toBuiltState(int *ReturnCode);
   	void release();
}

class BufferCppBinding : BufferCppBindingInterface {
	public Buffer thisPtr;

	public extern (C++) void construct() {
		//thisPtr.construct();
	}

    public extern (C++) void configure(int *typePtr, uint typesLength, int *returnCode) {
    	Buffer.EnumConfigureResult calleeReturnCode;
    	Array!(Buffer.EnumDatatype, true) types;

    	bool calleeSuccess;
    	types.resize(typesLength, calleeSuccess);
    	if( !calleeSuccess ) {
    		*returnCode = Buffer.EnumConfigureResult.OUTOFMEMORY;
    		return;
    	}

    	for( int i = 0; i < typesLength; i++ ) {
    		types[i] = cast(Buffer.EnumDatatype)typePtr[i];
    	}

    	thisPtr.configure(types, calleeReturnCode);
    	*returnCode = cast(int)calleeReturnCode;
    }

    public extern (C++) void setPolygonCount(uint Count, bool *Success) {
		bool CalleeSuccess;
		thisPtr.setPolygonCount(Count, CalleeSuccess);
		*Success = CalleeSuccess;
    }

    public extern (C++) void setVertexIndex(uint ArrayIndex, uint VertexIndex) {
    	thisPtr.setVertexIndex(ArrayIndex, VertexIndex);
    }

    public extern (C++) void setVerticesCount(uint Count, bool *Success) {
    	bool CalleeSuccess;
    	thisPtr.setVerticesCount(Count, CalleeSuccess);
    	*Success = CalleeSuccess;
    }

    public extern (C++) void setPosition(uint Index, float *Position) {
    	Vector!(3, float, true) PositionIntern;
    	PositionIntern.X = Position[0];
    	PositionIntern.Y = Position[1];
    	PositionIntern.Z = Position[2];
    	thisPtr.setPosition(Index, PositionIntern);
    }

    public extern (C++) void setData(uint Index, uint TypeIndex, float *Data) {
    	Vector!(3, float, true) DataIntern;
    	DataIntern.X = Data[0];
    	DataIntern.Y = Data[1];
    	DataIntern.Z = Data[2];
    	thisPtr.setData(Index, TypeIndex, DataIntern);
    }

    public extern (C++) void bindThis() {
      	thisPtr.bindThis();
   	}

    public extern (C++) void  drawThis() {
      	thisPtr.drawThis();
   	}

    public extern (C++) void bindNone() {
    	thisPtr.bindNone();
   	}

   	public extern (C++) void toModifyState(bool *Success) {
   		bool CalleeSuccess;
   		thisPtr.toModifyState(CalleeSuccess);
   		*Success = CalleeSuccess;
   	}

   	public extern (C++) void toBuiltState(int *ReturnCode) {
   		Buffer.EnumBuildBufferResult ReturnCodeIntern;
   		thisPtr.toBuiltState(ReturnCodeIntern);
   		*ReturnCode = cast(Buffer.EnumBuildBufferResult)ReturnCodeIntern;
   	}

   	public extern (C++) void release() {
   		thisPtr.release();
   	}
}
*/
