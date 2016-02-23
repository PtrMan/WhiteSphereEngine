/**
 * Halfedge datastructure for painless navigation in a mesh
 *
 *
 */

module HalfedgeMesh;

import Mesh;

class HalfedgeVertex(NumericType) {
	public MeshVertex!NumericType meshVertex;

	public Halfedge!NumericType halfedge;
}

class Halfedge(NumericType) {
	public Halfedge!NumericType
		next,
		previous,
		adjacent; // halfedge in adjacent loop

	public HalfedgeVertex!NumericType origin;

	public HalfedgeEdge!NumericType edge;

	public HalfedgeLoop!NumericType loop;
}

// whole edge of halfedge structure
class HalfedgeEdge(NumericType) {
	public Halfedge!NumericType halfedge;

	public final MeshEdgeStruct calcMeshEdgeStruct() {
		uint orginVertexIndex = halfedge.origin.meshVertex.index;
		uint destinationVertexIndex = halfedge.next.origin.meshVertex.index;
		return MeshEdgeStruct.createCounterclockwise(orginVertexIndex, destinationVertexIndex);
	}

	public final MeshEdge calcMeshEdge() {
		uint orginVertexIndex = halfedge.origin.meshVertex.index;
		uint destinationVertexIndex = halfedge.next.origin.meshVertex.index;
		return MeshEdge.createCounterclockwise(orginVertexIndex, destinationVertexIndex);
	}
}

// a loop/face, points just at one halfedge
class HalfedgeLoop(NumericType) {
	public Halfedge!NumericType halfedge;

	// marking is used for selecting some faces for an action
	public bool marked;

	public MeshFace!NumericType meshFace; // can be null if no correspoding mesh face is avaialbe/created/bound
}

class HalfedgeMesh(NumericType) {
	public HalfedgeLoop!NumericType[] loops;
}
