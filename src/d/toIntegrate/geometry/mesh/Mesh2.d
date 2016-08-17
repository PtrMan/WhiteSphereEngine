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
	

	private void* ptr;
	private size_t allocatedElementsPrivate;
}

import core.stdc.stdlib : malloc, realloc, free;
import core.stdc.string : memcpy;

struct HeapMemoryArray(Type) {
	mixin MemoryArrayMixin;
	
	public final ~this() {
		free();
	}
	
	final public Type* at(size_t index) nothrow @nogc
	in {
		assert(index < allocatedElements);
		assert(ptr !is null);
	}
	body {
		return cast(Type*)( cast(size_t)ptr + index * sizeofElement );
	}
	
	final ref Type opIndex(size_t index) nothrow @nogc {
		return *at(index);
	}
	
	final public HeapMemoryArray!Type opOpAssign(string op)(Type rhs) {
		static if (op == "~") {
			bool calleeSuccess;
			expandNeeded(usedElements+1, calleeSuccess);
			if( !calleeSuccess ) {
				throw new Exception("Expand failed!");
			}
			memcpy(at(usedElements), &rhs, Type.sizeof);
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
	
	public final int opApply(int delegate(ref Type) dg){
		int result = 0;
		foreach( i; 0..length ) {
			result = dg(this[i]);
			if(result) {
				break;
			}
		}
		
		return result;
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
	
	/* uncommented because todo
	public final MeshStruct!(MeshFaceDecorationType, VertexDecorationType, NumericType)* cloneAsMemory() {
		// TODO
	}
	*/
	
	// TODO< disable copy >
}

// untested
void blastFaces(MeshFaceDecorationType, VertexDecorationType, NumericType)(
	ref MeshStruct!(MeshFaceDecorationType, VertexDecorationType, NumericType) mesh,
	ref HeapMemoryArray!int faceIndices
) {
	foreach( faceIndex; faceIndices ) {
		assert(faceIndex >= 0 && faceIndex < mesh.faces.length);
		
		assert(mesh.faces[cast(size_t)faceIndex].decoration.enabled, "Face for blasting must have been enabled first!");
		mesh.faces[cast(size_t)faceIndex].decoration.enabled = false;
	}
}

// disables all faces and enables only the to be enabled ones
// untested
void enableOnlyFaces(MeshFaceDecorationType, VertexDecorationType, NumericType)(
	ref MeshStruct!(MeshFaceDecorationType, VertexDecorationType, NumericType) mesh,
	ref HeapMemoryArray!int faceIndices
) {
	foreach( iterationFace; mesh.faces ) {
		iterationFace.decoration.enabled = false;
	}
	
	foreach( faceIndex; faceIndices ) {
		assert(faceIndex >= 0 && faceIndex < mesh.faces.length);
		
		mesh.faces[cast(size_t)faceIndex].decoration.enabled = true;
	}
}



// TODO TODO TODO< refactor the remapping as a component and do an unittest for it >
/**
 * the remapping algorithm works as follows:
 * - maintain a list of indices, to indicate from which index we have to take the element if we rebuild the new list
 * - build a lookuptable where the new index can be looked up by the old index
 */
/**
 * MemoryType must provide the static methods:
 * * allocate
 *
 * The returned objects returned by allocate must have the methods
 * * free
 * * removeAt
 * the property
 * * length
 */
auto remappingAlgorithm(MemoryType)(size_t numberOfElements, bool delegate(size_t index) checkIfToBeRemoved) {
	auto remapIndexArray = MemoryType.allocate(numberOfElements);
	scope(exit) remapIndexArray.free();
	
	// fill remap index map
	foreach( i; 0..numberOfElements ) {
		remapIndexArray[i] = i;
	}
	
	// remove the indices where the test tells that the elment was removed
	foreach( i; 0..numberOfElements ) {
		if( checkIfToBeRemoved(i) ) {
			remapIndexArray.removeAt(i);
		}
	}
	
	// build the actual remap map
	auto remapMap = MemoryType.allocate(numberOfElements);
	
	foreach( i; 0..remapIndexArray.length ) {
		remapMap[remapIndexArray[i]] = i;
	}
	
	return remapMap;
}

unittest {
	static class MemoryType {
		public final this(size_t size) {
			arr.length = size;
		}
		
		public final void free() {
			// nothing to do because its GC'ed
		}
		
		public final @property size_t length() {
			return arr.length;
		}
		
		public final void removeAt(size_t index) {
			import std.algorithm.mutation : remove;
			remove(arr, index);
			arr.length--;
		}
		
		public final ref int opIndex(size_t index) @nogc {
			return arr[index];
		}
		
		
		public int[] arr;
	}
	
	static class Memory {
		public static MemoryType allocate(size_t size) {
			return new MemoryType(size);
		}
	}
	
	{ // test the case that nothing got removed
		bool checkIfToBeRemoved(size_t index) {
			return false;
		}
	
		MemoryType remappedLookup = remappingAlgorithm!Memory(cast(size_t)3, &checkIfToBeRemoved);
		// check that it shouldn't have changed anything
		foreach( i; 0..3 ) {
			assert( remappedLookup[i] == i );
		}
	}
	
	{ // check the case that one element in the middle got removed
		bool checkIfToBeRemoved2(size_t index) {
			return index == 1;
		}
	
		MemoryType remappedLookup = remappingAlgorithm!Memory(3, &checkIfToBeRemoved2);
		
		// check the following
		// the array before was [0 1 2]
		// we removed the 2nd element so the result is
		//                      [0 2]
		// so the remapping array should be
		//                      [0 ? 1]  (we find element 0 at 0, and element 2 at index 1
		
		// check that it shouldn't have changed anything
		assert( remappedLookup[0] == 0 );
		assert( remappedLookup[2] == 1 );
	}
}


// creates a new mesh with only enabled faces and only used vertices
// untested
MeshStruct!(MeshFaceDecorationType, VertexDecorationType, NumericType)* 
cleanup(MeshFaceDecorationType, VertexDecorationType, NumericType)
( ref MeshStruct!(MeshFaceDecorationType, VertexDecorationType, NumericType) mesh ) {
	// is used by the remapping algorithm as an array
	static struct RemappingMemory {
		public int* array;
		public int numberOfElements;
		
		public final void free() {
			assert( array !is null );
			.free(array);
			array = null;
		}
		
		public final @property size_t length() {
			return cast(size_t)numberOfElements;
		}
		
		public final void removeAt(size_t index) {
			assert( index < numberOfElements );
			
			// remove this index
			foreach( j; index..numberOfElements-1 ) {
				array[j] = array[j+1];
			}
			
			// decrement size
			assert(numberOfElements > 0);
			numberOfElements--;
		}
		
		public final ref int opIndex(size_t index) @nogc {
			return array[index];
		}

	}
	
	// allocates memory for the use in the remapping algorithm
	static struct RemappingMemoryAllocator {
		public static RemappingMemory allocate(size_t numberOfElements) {
			RemappingMemory resultMemory;
			resultMemory.array = cast(int*)malloc(int.sizeof * numberOfElements);
			if( resultMemory.array is null ) {
				throw new Exception("Out of memory");
			}
			resultMemory.numberOfElements = numberOfElements;
			
			return resultMemory;
		}
	}
	
	alias MeshStruct!(MeshFaceDecorationType, VertexDecorationType, NumericType) MeshType;
	
	MeshType* result = cast(MeshType*)malloc(MeshType.sizeof);
	*result = MeshType.init;

	{ // clean up faces by only copying active faces
		foreach( iterationFace; mesh.faces ) {
			if( iterationFace.decoration.enabled ) {
				result.faces ~= iterationFace;
			}
		}
	}
	
	{ // clean up vertices
		// reset ref counting of vertices in sourceMesh
		foreach( iterationVertex; mesh.vertices ) {
			iterationVertex.decoration.resetReferenceCounter();
		}
		
		// count references of vertices
		foreach( iterationFace; result.faces ) {
			foreach( iterationVertexIndex; iterationFace.verticesIndices ) {
				if( iterationVertexIndex == -1 || iterationVertexIndex == -2 ) { // check for special values
					continue;
				}
				mesh.vertices[iterationVertexIndex].decoration.incrementReferenceCounter();
			}
		}
		
		
		{ // remap vertex indices in result-mesh and copy vertices
			
			// this funcion is called by the remapping algorithm and checks if an
			// vertex has to be removed/remapped,
			// this can only be the case if its not referenced
			bool checkIfVertexHasToGetRemoved(size_t index) {
				return !mesh.vertices[index].decoration.isReferenced;
			}
			
			RemappingMemory remapMap = remappingAlgorithm!RemappingMemoryAllocator(mesh.vertices.length, &checkIfVertexHasToGetRemoved);
			scope(exit) remapMap.free();
			
			
			int remapVertexIndex(int vertexIndex) {
				assert(vertexIndex >= 0 && vertexIndex < mesh.vertices.length);
				return remapMap[vertexIndex];
			}
			
			// actual remapping
			foreach( iterationFace; result.faces ) {
				foreach( i; 0..iterationFace.verticesIndices.length ) {
					int iterationVertexIndex = iterationFace.verticesIndices[i];
					
					bool isSpecial = iterationVertexIndex == -1 || iterationVertexIndex == -2;
					if( isSpecial ) {
						// dont touch bcause its an special value
						continue;
					}
					
					iterationFace.verticesIndices[i] = remapVertexIndex(iterationFace.verticesIndices[i]);
				}
			}
			
			// copy (remapped) vertices
			foreach( i; 0..remapMap.length ) {
				result.vertices ~= mesh.vertices[remapMap[i]];
			}
		}
	}
	
	return result;
}



void recalculateNormals(MeshFaceDecorationType, VertexDecorationType, NumericType)(
	ref MeshStruct!(MeshFaceDecorationType, VertexDecorationType, NumericType) mesh
) {
	alias SpatialVectorStruct!(3, NumericType) VectorType;
	
	foreach( iterationFace; mesh.faces ) {
		int vertexIndex0 = iterationFace.verticesIndices[0];
		int vertexIndex1 = iterationFace.verticesIndices[1];
		int vertexIndex2 = iterationFace.verticesIndices[$-1];
		assert(vertexIndex0 != -2 && vertexIndex1 != -2 && vertexIndex2 != -2, "Vertex indices have to be set!");
		
		VectorType vertexPosition0 = vertices[vertexIndex0].position;
		VectorType vertexPosition1 = vertices[vertexIndex1].position;
		VectorType vertexPosition2 = vertices[vertexIndex2].position;
		
		VectorType a = vertexPosition1 - vertexPosition0;
		VectorType b = vertexPosition2 - vertexPosition0;
		
		VectorType unnormalizedNormal = crossProduct(a, b);
		iterationFace.decoration.normalizedNormal = unnormalizedNormal.normalized();
	}
}

import RefCountingMixin;

struct DefaultMeshFaceDecoration(NumericType) {
	private alias SpatialVectorStruct!(3, NumericType) VectorType;
	
	public VectorType normalizedNormal;
	
	public bool enabled = true;
}

struct DefaultVertexDecoration {
	mixin Refcount; // for reference counting for checking if an vertex is in use
}


// just for testing if it compiles
void main() {
	alias MeshStruct!(DefaultMeshFaceDecoration!float, DefaultVertexDecoration, float) MeshType;
	
	MeshType mesh;
	
	HeapMemoryArray!int facesToBlast;
	facesToBlast ~= 0;
	
	mesh.blastFaces(facesToBlast);
	
	MeshType* cleanedUp = mesh.cleanup();
}
