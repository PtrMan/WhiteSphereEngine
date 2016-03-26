module geometry.Mesh;

import math.NumericSpatialVectors;

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
	
	public this(SpatialVector!(3, NumericType) position) {
		this.position = position;
	}

	public SpatialVector!(3, NumericType) position;

	public HelperAttributes helperAttributes;

	// index and refcounts dont get cloned
	public final MeshVertex!NumericType clone() {
		MeshVertex!NumericType cloned = new MeshVertex!NumericType(position.clone());
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

class DefaultFace(NumericType) {
	public final this(int[] vertexIndices) {
		meshFace = new  MeshFace!NumericType(vertexIndices);
	}
	
	public MeshFace!NumericType meshFace;
}

import math.Matrix;
import math.MatrixCommonOperations;

class Mesh(TemplateNumericType, TemplateFaceType = DefaultFace!TemplateNumericType) {
	public alias TemplateFaceType FaceType;
	public alias TemplateNumericType NumericType;
	
	// TODO< overwork >
	public MeshVertex!TemplateNumericType[] vertices;
	//public Edge[] edges;
	public FaceType[] faces;

	public final void addFace(FaceType face) {
		faces ~= face;
	}

	public final void addVertex(MeshVertex!TemplateNumericType vertex) {
		assert(vertex.index == -1);

		vertex.index = vertices.length;
		vertices ~= vertex;
	}
	
	public final void recalculateNormals() {
		foreach( iterationFace; faces ) {
			int vertexIndex0 = iterationFace.meshFace.verticesIndices[0];
			int vertexIndex1 = iterationFace.meshFace.verticesIndices[1];
			int vertexIndex2 = iterationFace.meshFace.verticesIndices[$-1];
			
			SpatialVector!(3, TemplateNumericType) vertexPosition0 = vertices[vertexIndex0].position;
			SpatialVector!(3, TemplateNumericType) vertexPosition1 = vertices[vertexIndex1].position;
			SpatialVector!(3, TemplateNumericType) vertexPosition2 = vertices[vertexIndex2].position;
			
			SpatialVector!(3, TemplateNumericType) a = vertexPosition1 - vertexPosition0;
			SpatialVector!(3, TemplateNumericType) b = vertexPosition2 - vertexPosition0;
			
			SpatialVector!(3, TemplateNumericType) unnormalizedNormal = crossProduct(a, b);
			iterationFace.meshFace.normalizedNormal = unnormalizedNormal.normalized();
		}
	}
	
	public final void transformVertices(Matrix!(NumericType, 4, 4) matrix) {
		Matrix!(TemplateNumericType, 1, 4) resultPositionAsMatrix = new Matrix!(TemplateNumericType, 1, 4)();
		Matrix!(TemplateNumericType, 1, 4) positionAsMatrix = new Matrix!(TemplateNumericType, 1, 4)();
		
		foreach( iterationVertex; vertices ) {
			positionAsMatrix[0, 0] = iterationVertex.position.x;
			positionAsMatrix[1, 0] = iterationVertex.position.y;
			positionAsMatrix[2, 0] = iterationVertex.position.z;
			positionAsMatrix[3, 0] = cast(NumericType)1.0;
			
			mulVector!(TemplateNumericType, 4, 4)(matrix, positionAsMatrix, resultPositionAsMatrix);
			
			iterationVertex.position.x = resultPositionAsMatrix[0, 0];
			iterationVertex.position.y = resultPositionAsMatrix[1, 0];
			iterationVertex.position.z = resultPositionAsMatrix[2, 0];
		}
	}
}
