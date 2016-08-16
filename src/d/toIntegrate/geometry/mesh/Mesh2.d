// mesh implementation without the need for GC


// TODO< refactor into own file >

/**
 * requires * the attribute sizeofElement, which returns the size of one element
 *          * the methods allocateMemory, reallocateMemory, freeMemory
 */

package mixin template MemoryArrayMixin() {
	/** \brief expands the Array if needed to fit the count 
	 *
	 * \param Elements number of Elements
	 * \param Success true if successfull
	 */
	final public void expandNeeded(size_t elements, out bool success) nothrow @nogc 
	in {
		assert(sizeofElement != 0);
	}
	body {
		success = false;
		
		if( elements == 0 ) {
			return;
		}
		
		if( elements <= allocatedElementsPrivate ) {
			success = true;
			return;
		}
		// else we are here
		
		if( ptr is null ) {
			ptr = allocateMemory(elements * sizeofElement);
			
			if( ptr is null ) {
				return;
			}
			
			allocatedElementsPrivate = elements;

			// fall through
		}
		else {
			void *newPtr = reallocateMemory(ptr, elements * sizeofElement);
			
			if( newPtr is null ) {
				return;
			}
			
			allocatedElementsPrivate = elements;
			
			// fall through
		}
		
		success = true;
	}

	final public void free() nothrow @nogc {
		if( ptr !is null ) {
			freeMemory(ptr);
			
			allocatedElementsPrivate = 0;
			ptr = null;
		}
	}
	
	final public @property void* unsafePtr() nothrow @nogc
	in {
		assert(ptr !is null);
	}
	body {
		return ptr;
	}
	
	public final @property size_t allocatedElements() nothrow @nogc {
		return allocatedElementsPrivate;
	}
	
	public final @property size_t allocatedElementsSize() nothrow @nogc {
		return allocatedElements * sizeofElement;
	}
	
	
	invariant() {
		if( ptr !is null ) {
			assert(allocatedElementsPrivate != 0);
			assert(sizeofElement != 0);
		}
		else {
			assert(allocatedElementsPrivate == 0);
		}
	}
	

	private void *ptr;
	private size_t allocatedElementsPrivate;
}

import core.stdc.stdlib : malloc, realloc, free;
import core.stdc.string : memcpy;

struct HeapMemoryArray(Type) {
	mixin MemoryArrayMixin;
	
	public final ~this() {
		free();
	}
	
	final Type* opIndex(size_t index) nothrow @nogc
	in {
		assert(index < allocatedElements);
		assert(ptr !is null);
	}
	body {
		return cast(Type*)( cast(size_t)ptr + Index * sizeofElement );
	}
	
	final public HeapMemoryArray!Type opOpAssign(string op)(Type rhs) {
        static if (op == "~") {
        	bool calleeSuccess;
            expandNeeded(usedElements+1, calleeSuccess);
            if( !calleeSuccess ) {
				throw new Exception("Expand failed!");
			}
            memcpy(this[usedElements], &rhs, Type.sizeof);
            usedElements++;
        }
        else {
            static assert(0, "Operator "~op~" not implemented");
        }

        return this;
    }
	
	// copies the content of the source to this object
	public final void copyFrom(HeapMemoryArray!Type* source) {
		bool calleeSuccess;
		expandNeeded(source.allocatedElements, calleeSuccess);
		if( !calleeSuccess ) {
			throw new Exception("Copy failed!");
		}
		memcpy(unsafePtr, source.unsafePtr, source.allocatedElementsSize);
		
		usedElements = source.usedElements;
	}
	
	public final @property size_t length() {
		return usedElements;
	}
	
	
	protected size_t usedElements = 0;
	
	invariant() {
		if( ptr !is null ) {
			assert(usedElements <= allocatedElementsPrivate);
		}
		else {
			assert(usedElements == 0);
		}
	}
	
	/////
	// all methods and properties for MemoryArrayMixin
	private final @property size_t sizeofElement() nothrow @nogc const {
		return Type.sizeof;
	}
	
	private final void* allocateMemory(size_t size) nothrow @nogc {
		return malloc(size);
	}
	
	private final void* reallocateMemory(void* ptr, size_t size) nothrow @nogc {
		return realloc(ptr, size);
	}
	
	private final void freeMemory(void* ptr) nothrow @nogc {
		.free(ptr);
	}
}





import math.NumericSpatialVectors;

struct MeshVertex(NumericType, VertexDecorationType) {
	public VertexDecorationType decoration;
	public SpatialVectorStruct!(3, NumericType) position;
	
	// must match to index in mesh
	// can be -1 if it wasn't allocated
	public int index = -1;
}

/+ uncommented because its not used
package mixin template MeshEdgeTemplate() {
	public final @property uint[2] verticeIndicesCounterclockwise() {
		return protectedVerticeIndicesCounterclockwise;
	}
	
	public final @property uint[2] verticeIndicesClockwise() {
		uint[2] result;
		result[0] = protectedVerticeIndicesCounterclockwise[1];
		result[1] = protectedVerticeIndicesCounterclockwise[0];
		return result;
	}

	// must match to index in mesh
	// can be -1 if it wasn't allocated
	//public int index = -1;

	protected uint[2] protectedVerticeIndicesCounterclockwise;

	//uncommented because im not sure if we need this
	// mixin Refcount;

	
}


struct MeshEdgeStruct {
	mixin MeshEdgeTemplate;

	public static MeshEdgeStruct createCounterclockwise(uint verticeIndicesCounterclockwise0, uint verticeIndicesCounterclockwise1) {
		MeshEdgeStruct result;
		result.protectedVerticeIndicesCounterclockwise[0] = verticeIndicesCounterclockwise0;
		result.protectedVerticeIndicesCounterclockwise[1] = verticeIndicesCounterclockwise1;
		return result;
	}
	
	public static MeshEdgeStruct createClockwise(uint verticeIndicesClockwise0, uint verticeIndicesClockwise1) {
		MeshEdgeStruct result;
		result.protectedVerticeIndicesCounterclockwise[0] = verticeIndicesClockwise1;
		result.protectedVerticeIndicesCounterclockwise[1] = verticeIndicesClockwise0;
		return result;
	}

	public final @property MeshEdgeStruct reversedEdge() {
		MeshEdgeStruct result;
		result.protectedVerticeIndicesCounterclockwise[0] = protectedVerticeIndicesCounterclockwise[1];
		result.protectedVerticeIndicesCounterclockwise[1] = protectedVerticeIndicesCounterclockwise[0];
		return result;
	}
}
+/


struct MeshFaceStruct(MeshFaceDecorationType) {
	public final void init() {
		// initialize all to -2 which means that the indices are not used
		foreach( i; 0..verticesIndices.length ) {
			verticesIndices[i] = -2;
		}
	}
	
	public final this(ArraySize)(int[ArraySize] vertexIndices) if (ArraySize <= 4) {
		init();
		
		foreach( i, iterationVertexIndex; vertexIndices ) {
			assert(iterationVertexIndex >= 0);
			verticesIndices[i] = iterationVertexIndex;
		}
	}
	
	// -2 means that the index is not used
	public int[4] verticesIndices;
	
	public MeshFaceDecorationType decoration;
}

struct MeshStruct(MeshFaceDecorationType, VertexDecorationType, NumericType) {
	public alias MeshVertex!(NumericType, VertexDecorationType) MeshVertexType;
	public alias MeshFaceStruct!MeshFaceDecorationType MeshFaceType;
	
	public HeapMemoryArray!MeshFaceType faces;
	public HeapMemoryArray!MeshVertexType vertices;
	
	public final ~this() {
	}
	
	public final void addFace(MeshFaceType face) {
		faces ~= face;
	}
	
	public final void addVertex(MeshVertexType vertex) {
		assert(vertex.index == -1);

		vertex.index = vertices.length;
		vertices ~= vertex;
	}
	
	// TODO< disable copy >
}

// just for testing
void main() {
	MeshStruct!(int, int, float) mesh;
}
