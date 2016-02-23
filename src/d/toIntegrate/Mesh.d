module Mesh;

import NumericSpatialVectors;

mixin template Refcount() {
	public uint referenceCounter;

	public final void resetReferenceCounter() {
		referenceCounter = 0;
	}

	public final void incrementReferenceCounter() {
		referenceCounter++;
	}
}

mixin template InvalidableIndex() {
	public int index = -1; // negative if not valid/allocated

	public final @property bool isIndexValid() {
		return index >= 0;
	}
}

class MeshVertex(NumericType) {
	static public class HelperAttributes {
		public uint neightborCounter;

		public SpatialVector!(3, NumericType) moveDelta;

		public final HelperAttributes clone() {
			HelperAttributes cloned = new HelperAttributes();
			cloned.neightborCounter = neightborCounter;
			cloned.moveDelta = moveDelta.clone();
			return cloned;
		}
	}

	public SpatialVector!(3, NumericType) position;

	public HelperAttributes helperAttributes;

	// index and refcounts dont get cloned
	public final MeshVertex!NumericType clone() {
		MeshVertex!NumericType cloned = new MeshVertex!NumericType();
		cloned.position = position.clone();
		if( helperAttributes !is null ) {
			cloned.helperAttributes = helperAttributes.clone();
		}
		return cloned;
	}


	mixin Refcount;
	mixin InvalidableIndex;
}

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

	//private this(uint[2] verticeIndicesCounterclockwise) {
	//	this.protectedVerticeIndicesCounterclockwise = verticeIndicesCounterclockwise;
	//}

	protected uint[2] protectedVerticeIndicesCounterclockwise;

	mixin Refcount;

	
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

class MeshEdge {
	mixin MeshEdgeTemplate;

	private this() {
	}

	public static MeshEdge createCounterclockwise(uint verticeIndicesCounterclockwise0, uint verticeIndicesCounterclockwise1) {
		MeshEdge result = new MeshEdge();
		result.protectedVerticeIndicesCounterclockwise[0] = verticeIndicesCounterclockwise0;
		result.protectedVerticeIndicesCounterclockwise[1] = verticeIndicesCounterclockwise1;
		return result;
	}
	
	public static MeshEdge createClockwise(uint verticeIndicesClockwise0, uint verticeIndicesClockwise1) {
		MeshEdge result = new MeshEdge();
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


class MeshFace(NumericType) {
	public this(int[] vertexIndices) {
		foreach( int iterationVertexIndex; vertexIndices ) {
			assert(iterationVertexIndex >= 0);
		}

		this.verticesIndices = vertexIndices;
	}

	// TODO< rename to vertexIndices >
	public int[] verticesIndices;

	public bool normalValid = false;
	public SpatialVector!(3, NumericType) normalizedNormal;

	// marking is used for selecting some faces for an action
	public bool marked;

	mixin Refcount;
	mixin InvalidableIndex;
}

class Mesh(NumericType) {
	// TODO< overwork >
	public MeshVertex!NumericType[] vertices;
	//public Edge[] edges;
	public MeshFace!NumericType[] faces;

	public final void addFace(MeshFace!NumericType face) {
		faces ~= face;
	}

	public final void addVertex(MeshVertex!NumericType vertex) {
		assert(vertex.index == -1);

		vertex.index = vertices.length;
		vertices ~= vertex;
	}
}