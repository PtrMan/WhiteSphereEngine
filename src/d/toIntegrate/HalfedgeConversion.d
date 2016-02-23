/**
 * Used to convert betwen a mesh and a Halfedge representation of the same mesh
 *
 */

module HalfedgeConversion;

import std.algorithm.sorting : multisort;
import std.algorithm.mutation : swap;
import MeshManipulation : MeshManipulationUtilities;

// TODO< template >

// makes use of the inverse matching algorithm
public HalfedgeMesh!NumericType convertMeshToHalfedgeMesh(Mesh!NumericType mesh) {
	void inverseMatchingHelper(MeshEdgeWithEdgeAnnotation inputAnnotatedEdges) {
		// sort edge indices
		foreach( MeshEdgeWithEdgeAnnotation iterationEdgeWithAnotation; inputAnnotatedEdges ) {
			if( iterationEdgeWithAnotation.sortedEdgeIndices[0] > iterationEdgeWithAnotation.sortedEdgeIndices[1] ) {
				swap(iterationEdgeWithAnotation.sortedEdgeIndices[0], iterationEdgeWithAnotation.sortedEdgeIndices[1]);
			}
		}

		multiSort!("a.sortedEdgeIndices[0] < b.sortedEdgeIndices[0]", "a.sortedEdgeIndices[1] < b.sortedEdgeIndices[1]", SwapStrategy.unstable)(inputAnnotatedEdges);
	}

	class MeshEdgeWithEdgeAnnotation {
		public uint edgeIndexAnnotation; // is the index of the edge if we enumerate all faces and edges of the faces in the orginal mesh
		public uint[2] sortedEdgeIndices;
	}

	MeshEdge[] calcEdgesOfFacesWithDuplicates(MeshFace!NumericType[] faces) {
		MeshEdge[] calcEdgesOfFace(MeshFace!NumericType face) {
			return MeshManipulationUtilities!NumericType.calcCorespondingEdgesOfClosedVertexChainByVertexIndices(face.verticesIndices);
		}

		MeshEdge[] allEdges;

		foreach( MeshFace!NumericType iterationFace; faces ) {
			allEdges ~= calcEdgesOfFace(iterationFace);
		}

		return allEdges;
	}


	MeshEdge[] allEdgesOfMesh = calcEdgesOfFacesWithDuplicates(mesh.faces);

	// TODO
}
