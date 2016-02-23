module MeshManipulation;

import HalfedgeMesh;
import Mesh : Mesh, MeshEdge, MeshEdgeStruct, MeshFace, MeshVertex;
import NumericSpatialVectors;


class MeshManipulationExtrude(NumericType) {
	// TODO - actual extrusion/moving of face
	//      - blasting old face(s) out
	
	// for testing public

	// the sidewall and the extruded top are not connected
	// this simplifies and generalizes the algorithm
	// ...
	// The resulting vertices have to get fused with another operation at an appropriate time

	// only the parameters must be in the halfedge datastructure, not the whole mesh
	// doesnt modify the toExtrudeToBlastedFaces
	public static final void extrudeWithoutBlastingFaces(Mesh!NumericType mesh, HalfedgeLoop!NumericType[] toExtrudeToBlastedFaces, NumericType normalDistance) {
		import IDictionary : IDictionary;
		import ListDictionary : ListDictionary;


		MeshVertex!NumericType[] cloneAndAddVerticesToMesh(MeshVertex!NumericType[] originalVertices) {
			MeshVertex!NumericType[] clonedVertices;

			foreach( MeshVertex!NumericType iterationVertex; originalVertices ) {
				MeshVertex!NumericType clonedVertex = iterationVertex.clone();
				mesh.addVertex(clonedVertex);
				clonedVertices ~= clonedVertex;
			}

			return clonedVertices;
		}

		void moveVerticesAfterDelta(MeshVertex!NumericType[] vertices) {
			foreach( MeshVertex!NumericType iterationVertex; vertices ) {
				assert( iterationVertex.helperAttributes !is null );
				iterationVertex.position += iterationVertex.helperAttributes.moveDelta;
			}
		}


		// todo< move into MeshManipulationUtilities >
		void freeHelperAttributesFromVertices(MeshVertex!NumericType[] vertices) {
			foreach( MeshVertex!NumericType iterationVertex; vertices ) {
				iterationVertex.helperAttributes = null;
			}
		}

		void freeHelperAttributesFromVerticesOfFace(Mesh!NumericType mesh, MeshFace!NumericType face) {
			foreach( uint iterationVertexIndex; face.verticesIndices ) {
				mesh.vertices[iterationVertexIndex].helperAttributes = null;
			}
		}

		// TODO< move into MeshManipulationUtilities >
		void freeHelperAttributesFromVerticesOfFaces(Mesh!NumericType mesh, MeshFace!NumericType[] faces) {
			foreach( MeshFace!NumericType iterationFace; faces ) {
				freeHelperAttributesFromVerticesOfFace(mesh, iterationFace);
			}
		}


		// TODO< move into MeshManipulationUtilities >
		void cloneVerticesOfFacesAndAddToMesh(IDictionary!(uint, uint) clonedVertexLookup, Mesh!NumericType mesh, MeshFace!NumericType[] faces) {
			foreach( MeshFace!NumericType iterationFace; faces ) {
				foreach( uint iterationVertexIndex; iterationFace.verticesIndices ) {
					if( !clonedVertexLookup.contains(iterationVertexIndex) ) {
						MeshVertex!NumericType toCloneVertex = mesh.vertices[iterationVertexIndex];
						MeshVertex!NumericType clonedVertex = toCloneVertex.clone();
						mesh.addVertex(clonedVertex);

						clonedVertexLookup.add(iterationVertexIndex, clonedVertex.index);
					}
				}
			}
		}

		// TODO< move into MeshManipulationUtilities >
		MeshFace!NumericType[] cloneFacesAndAddToMesh(IDictionary!(uint, uint) clonedVertexLookup, Mesh!NumericType mesh, MeshFace!NumericType[] faces) {
			uint[] lookupCorespondingClonedVerticesForVertexIndices(uint[] vertexIndices) {
				uint[] result;

				foreach( uint iterationVertexIndex; vertexIndices ) {
					assert(clonedVertexLookup.contains(iterationVertexIndex));
					result ~= clonedVertexLookup.get(iterationVertexIndex);
				}

				return result;
			}

			MeshFace!NumericType[] clonedFaces;

			foreach( MeshFace!NumericType iterationFace; faces ) {
				clonedFaces ~= new MeshFace!NumericType(lookupCorespondingClonedVerticesForVertexIndices(iterationFace.verticesIndices));
			}

			return clonedFaces;
		}

		// extract mesh faces from toExtrudeToBlastedFaces and calculate the delta of the extrusion/motion
		/**
		 * We don't change the mesh in this stage because we need to build the sidewall(s).
		 * in this process we work with halfedges without easy information of the coresponding meshedge of the extruded surface(s)
		 */
		MeshFace!NumericType[] toExtrudeToBlastedFacesAsMeshFaces = MeshManipulationUtilities!NumericType.getMeshFacesOfLoops(toExtrudeToBlastedFaces);
		// TODO< see TODO of calculateDeltaOfMoveOfFacesInDirectionOfNormal >
		MeshManipulationUtilities!NumericType.calculateDeltaOfMoveOfFacesInDirectionOfNormal(mesh, toExtrudeToBlastedFacesAsMeshFaces, normalDistance);
		scope(exit) freeHelperAttributesFromVerticesOfFaces(mesh, toExtrudeToBlastedFacesAsMeshFaces);
		
		// loop which adds sidewalls for all boundary vertex chains/edges
		for(;;) {
			bool foundOuterLoop;
			HalfedgeEdge!NumericType[] currentOuterLoopOfToExtrudeSurface = HalfedgeUtilities!NumericType.getRemainingConnectedOuterLoopOfNotMarkedLoops(toExtrudeToBlastedFaces, foundOuterLoop);

			if( !foundOuterLoop ) {
				break;
			}

			// creation of new moved moved sidewall Vertices and translation  of edges in MeshEdge[] extrudedMeshEdges
			//  get the vertices of the sidewalls
			MeshVertex!NumericType[] toExtrudeVertices = MeshManipulationUtilities!NumericType.getMeshVerticesOfHalfedgeEdgechain(currentOuterLoopOfToExtrudeSurface);
			//  clone the vertices (1:1 with HelperAttributes) because we shouldn't move the original vertices
			MeshVertex!NumericType[] clonedtoExtrudeVertices = cloneAndAddVerticesToMesh(toExtrudeVertices);
			//   make sure that we free the helper attributes from the cloned vertices
			scope(exit) freeHelperAttributesFromVertices(clonedtoExtrudeVertices);

			//  move vertices
			moveVerticesAfterDelta(clonedtoExtrudeVertices);
			//  get coresponding edges of (cloned) vertice chain
			MeshEdge[] extrudedMeshEdges = MeshManipulationUtilities!NumericType.calcCorespondingEdgesOfClosedVertexChain(clonedtoExtrudeVertices);

			// we extract the meshedges from currentOuterLoopOfToExtrudeSurface
			MeshEdge[] currentOuterLoopOfToExtrudeSurfaceAsMeshEdges = MeshManipulationUtilities!NumericType.convertHalfedgeEdgesToMeshEdges(currentOuterLoopOfToExtrudeSurface);

			// and finally we add the sidewalls
			addSideWallFacesForEdgeloops(mesh, extrudedMeshEdges, currentOuterLoopOfToExtrudeSurfaceAsMeshEdges);
		}
		
		/**
		// TODO , actual moing, extrusion of toExtrudeToBlastedFaces to  HalfedgeLoop!NumericType[] toExtrudeCreatedRealFaces
		*/
		// now we clone the faces we have to move for this we have to
		IDictionary!(uint, uint) clonedVertexLookup = new ListDictionary!(uint, uint)();
		//  clone the actual vertices
		cloneVerticesOfFacesAndAddToMesh(clonedVertexLookup, mesh, toExtrudeToBlastedFacesAsMeshFaces);
		//  clone the faces
		MeshFace!NumericType[] toMoveFaces = cloneFacesAndAddToMesh(clonedVertexLookup, mesh, toExtrudeToBlastedFacesAsMeshFaces);
		scope(exit) freeHelperAttributesFromVerticesOfFaces(mesh, toMoveFaces);

		//  move the vertices of the clones
		// TODO< actually move cloned vertices >
	}


	/**
	 * creates edges between edgeloops and creates faces with correct edge orientation and adds it to the mesh
	 *
	 */
	private static final void addSideWallFacesForEdgeloops(Mesh!NumericType mesh, MeshEdge[] edgesA, MeshEdge[] edgesB) {
		MeshEdge[] brideEdges = MeshManipulationUtilities!NumericType.createBridgeEdgesBetweenEdgesForClosedLoops(edgesA, edgesB);

		void createAndAddFaceForBridgeEdgesIndices(uint currentIndex, uint nextIndex) {
			MeshEdgeStruct reversedBEdge = edgesB[currentIndex].reversedEdge;
			MeshEdgeStruct reversedBridgeEdge = brideEdges[currentIndex].reversedEdge;

			//mesh.addEdge(reversedBEdge);
			//mesh.addEdge(reversedBridgeEdge);

			MeshFace!NumericType createdFace = new MeshFace!NumericType([
				edgesA[currentIndex].verticeIndicesCounterclockwise[0],
				brideEdges[nextIndex].verticeIndicesCounterclockwise[0],
				reversedBEdge.verticeIndicesCounterclockwise[0],
				reversedBridgeEdge.verticeIndicesCounterclockwise[0]]
			);
			mesh.addFace(createdFace);
		}

		for( uint faceI = 0; faceI < brideEdges.length-1; faceI++ ) {
			/*
			MeshEdge reversedBEdge = edgesB[faceI].reversedEdge;
			MeshEdge reversedBridgeEdge = brideEdges[faceI].reversedEdge;

			mesh.addEdge(reversedBEdge);
			mesh.addEdge(reversedBridgeEdge);

			MeshFace!NumericType createdFace = new MeshFace!NumericType([
				edgesA[faceI].verticeIndicesCounterclockwise[0],
				brideEdges[faceI+1].verticeIndicesCounterclockwise[0],
				reversedBEdge.verticeIndicesCounterclockwise[0],
				reversedBridgeEdge.verticeIndicesCounterclockwise[0]]
			);
			mesh.addFace(createdFace);
			*/
			createAndAddFaceForBridgeEdgesIndices(faceI, faceI+1);
		}

		// create the last face
		{
			/*
			MeshEdge reversedBEdge = edgesB[edgesA.length-1].reversedEdge;
			MeshEdge reversedBridgeEdge = brideEdges[edgesA.length-1].reversedEdge;

			mesh.addEdge(reversedBEdge);
			mesh.addEdge(reversedBridgeEdge);

			MeshFace!NumericType createdFace = new MeshFace!NumericType([
				edgesA[edgesA.length-1].verticeIndicesCounterclockwise[0],
				brideEdges[0].verticeIndicesCounterclockwise[0],
				reversedBEdge.verticeIndicesCounterclockwise[0],
				reversedBridgeEdge.verticeIndicesCounterclockwise[0]]
			);
			mesh.addFace(createdFace);
			*/
			createAndAddFaceForBridgeEdgesIndices(edgesA.length-1, 0);
		}
	}
}

class MeshManipulationUtilities(NumericType) {
	/**
	 *                          counterClockwise ---> 
	 *
     *  edgesACounterlockwise   A-----+-----+-----
     *                          .     .     .
     *  result                  .     .     .
     *                          V     V     V
     *  edgesBCounterclockwise  B-----+-----+-----
	 */
	public static final MeshEdge[] createBridgeEdgesBetweenEdgesForClosedLoops(MeshEdge[] edgesACounterlockwise, MeshEdge[] edgesBCounterclockwise) {
		assert(edgesACounterlockwise.length == edgesBCounterclockwise.length);

		MeshEdge[] resultEdges;

		for( uint i = 0; i < edgesACounterlockwise.length; i++ ) {
			resultEdges ~= MeshEdge.createCounterclockwise(edgesACounterlockwise[i].verticeIndicesCounterclockwise[0], edgesBCounterclockwise[i].verticeIndicesCounterclockwise[0]);
		}

		return resultEdges;
	}


	public static final MeshEdge[] convertHalfedgeEdgesToMeshEdges(HalfedgeEdge!NumericType[] halfedgeEdges) {
		MeshEdge[] meshedgesResult;

		foreach( HalfedgeEdge!NumericType iterationHalfedgeEdge; halfedgeEdges ) {
			meshedgesResult ~= iterationHalfedgeEdge.calcMeshEdge();
		}

		return meshedgesResult;
	}

	// TODO< generalize this to handle transformation matrices like in houdini >
	// does store the delta into the attribute of the vertices
	public static final void calculateDeltaOfMoveOfFacesInDirectionOfNormal(Mesh!NumericType mesh, MeshFace!NumericType[] faces, NumericType normalDistance) {
		void freeAllVertexAttributesOfFace(MeshFace!NumericType face) {
			foreach( uint vertexIndex; face.verticesIndices ) {
				mesh.vertices[vertexIndex].helperAttributes = null;
			}
		}

		// TODO shouldn't be function local
		void freeAllVertexAttributesOfFaces(MeshFace!NumericType[] faces) {
			foreach( MeshFace!NumericType iterationFace; faces ) {
				freeAllVertexAttributesOfFace(iterationFace);
			}
		}


		void createVertexAttributesIfNotPresentOfFace(MeshFace!NumericType face) {
			foreach( uint vertexIndex; face.verticesIndices ) {
				if( mesh.vertices[vertexIndex].helperAttributes is null ) {
					mesh.vertices[vertexIndex].helperAttributes = new MeshVertex!NumericType.HelperAttributes();
				}
			}
		}

		// TODO shouldn't be function local
		void createVertexAttributesIfNotPresentOfFaces(MeshFace!NumericType[] faces) {
			foreach( MeshFace!NumericType iterationFace; faces ) {
				createVertexAttributesIfNotPresentOfFace(iterationFace);
			}
		}


		void initializeRequiredFieldsForDeltaOfFace(MeshFace!NumericType face) {
			foreach( uint vertexIndex; face.verticesIndices ) {
				if( mesh.vertices[vertexIndex].helperAttributes.moveDelta is null ) {
					mesh.vertices[vertexIndex].helperAttributes.moveDelta = new SpatialVector!(3, NumericType)(0.0, 0.0, 0.0);
				}
			}
		}

		// function local helper
		void inititalizeRequiredFieldsForDelta() {
			foreach( MeshFace!NumericType iterationFace; faces ) {
				initializeRequiredFieldsForDeltaOfFace(iterationFace);
			}
		}


		freeAllVertexAttributesOfFaces(faces);
		createVertexAttributesIfNotPresentOfFaces(faces);
		inititalizeRequiredFieldsForDelta();

		// move all vertices of all faces and store the delta into the vertex attributes
		//  we do this by summing all moving deltas
		foreach( MeshFace!NumericType face; faces ) {
			foreach( uint iterationVertexIndex; face.verticesIndices ) {
				mesh.vertices[iterationVertexIndex].helperAttributes.neightborCounter++;
				mesh.vertices[iterationVertexIndex].helperAttributes.moveDelta += face.normalizedNormal.scale(normalDistance);
			}
		}

		//  and we divide it by the neighborCounter
		foreach( MeshVertex!NumericType iterationVertex; mesh.vertices ) {
			if( iterationVertex.helperAttributes !is null ) {
				assert(iterationVertex.helperAttributes.moveDelta !is null);

				iterationVertex.helperAttributes.moveDelta.scale(cast(NumericType)1.0 / cast(NumericType)iterationVertex.helperAttributes.neightborCounter);
			}
		}
	}


	// helper for conversion
	public static final MeshFace!NumericType[] getMeshFacesOfLoops(HalfedgeLoop!NumericType[] halfedgeLoops) {
		MeshFace!NumericType[] result;

		foreach( HalfedgeLoop!NumericType iterationLoop; halfedgeLoops ) {
			assert(iterationLoop.meshFace !is null);
			result ~= iterationLoop.meshFace;
		}

		return result;
	}

	// returns the associated MeshVertices of a halfedge edgechain
	public static final MeshVertex!NumericType[] getMeshVerticesOfHalfedgeEdgechain(HalfedgeEdge!NumericType[] edgechain) {
		MeshVertex!NumericType[] result;

		foreach( HalfedgeEdge!NumericType iterationEdge; edgechain ) {
			assert(iterationEdge.halfedge.origin.meshVertex !is null);
			result ~= iterationEdge.halfedge.origin.meshVertex;
		}

		return result;
	}

	public static final MeshEdge[] calcCorespondingEdgesOfClosedVertexChain(MeshVertex!NumericType[] vertexChain) {
		int[] getVertexIndices(MeshVertex!NumericType[] vertices) {
			int[] vertexIndices;

			foreach( MeshVertex!NumericType iterationVertex; vertices ) {
				vertexIndices ~= iterationVertex.index;
			}

			return vertexIndices;
		}

		return calcCorespondingEdgesOfClosedVertexChainByVertexIndices(getVertexIndices(vertexChain));
	}

	public static final MeshEdge[] calcCorespondingEdgesOfClosedVertexChainByVertexIndices(int[] vertexIndices) {
		assert(vertexIndices.length >= 2);

		MeshEdge[] result;

		foreach( vertexI; 0..vertexIndices.length-1 ) {
			result ~= MeshEdge.createCounterclockwise(vertexIndices[vertexI], vertexIndices[vertexI+1]);
		}

		// to close it
		result ~= MeshEdge.createCounterclockwise(vertexIndices[vertexIndices.length-1], vertexIndices[0]);

		return result;
	}

}

class HalfedgeUtilities(NumericType) {
	// for a correct functioning the loops which don't have any borders must be already marked!
	public static final HalfedgeEdge!NumericType[] getRemainingConnectedOuterLoopOfNotMarkedLoops(HalfedgeLoop!NumericType[] loops, out bool foundOuterLoop) {
		foundOuterLoop = false;

		HalfedgeEdge!NumericType[] resultFoundOuterLoop;

		HalfedgeLoop!NumericType startHalfedgeLoop;
		for( uint inputLoopIndex = 0; inputLoopIndex < loops.length; inputLoopIndex++ ) {
			if( !loops[inputLoopIndex].marked ) {
				startHalfedgeLoop = loops[inputLoopIndex];
				foundOuterLoop = true;
				break;
			}
		}

		if( !foundOuterLoop ) {
			return [];
		}

		// we are here if it found a not jet marked loop
		Halfedge!NumericType startHalfedge = startHalfedgeLoop.halfedge;

		Halfedge!NumericType currentIterationHalfedge = startHalfedge;

		for(;;) {
			currentIterationHalfedge.loop.marked = true;

			resultFoundOuterLoop ~= currentIterationHalfedge.edge;

			// NOTE< we don't handle the cornercase with many next corner halfedges!
			currentIterationHalfedge = getNextCornerHalfedge(currentIterationHalfedge);

			if( currentIterationHalfedge is startHalfedge ) {
				break;
			}
		}

		return resultFoundOuterLoop;
	}

	/**
     * corner halfedges don't have a adjacent pointer
     * 
     * this simply searches the next halfedge which doesn't have an adjacent pointer
     *
     * doesn't handle weird cornercases like
     *
     *  . . . \
     * loop A  \
     * . . . .  \
     *   --------*---------
     *           | . . . . 
     *           |  loop B
     *           | . . . .
	 */
	public static final Halfedge!NumericType getNextCornerHalfedge(Halfedge!NumericType entry) {
		Halfedge!NumericType candidateHalfedge = entry;

		for(;;) {
			if( candidateHalfedge.adjacent is null ) {
				return candidateHalfedge;
			}
			else {
				// this is true if we start for some reason in a Halfedge which is not on the border
				assert(candidateHalfedge.adjacent !is entry);

				candidateHalfedge = candidateHalfedge.adjacent.next;
			}
		}
	}
}

// testing

void main() {
	import std.stdio;
	import MeshMathematicaDebug;
	import MeshGenerator : MeshGenerator;

	Mesh!float mesh;

	HalfedgeLoop!float[] toExtrudeToBlastedFaces; // TODO< fill >

	mesh = MeshGenerator!float.generateYPlane(5.0f, 5.0f, 3, 3);

	string mathematicaMesh = MeshMathematicaDebug.calcMathematicaFormOfMesh(mesh);
	writeln(mathematicaMesh);

	// TODO
	//MeshManipulationExtrude!float.extrudeWithoutBlastingFaces(mesh, toExtrudeToBlastedFaces, 1.0f);
}
