module geometry.MeshConverter;

import geometry.Mesh : Mesh, MeshEdge, MeshEdgeStruct, MeshFace, MeshVertex;
import math.NumericSpatialVectors;

public MeshTypeDestination convert(MeshTypeSource, MeshTypeDestination)(MeshTypeSource source) {
	MeshTypeDestination destination = new MeshTypeDestination();
	
	foreach( iterationFace; source.faces ) {
		destination.addFace(new destination.FaceType(iterationFace.meshFace.verticesIndices));
	}
	
	foreach( iterationVertex; source.vertices ) {
		SpatialVector!(3, destination.NumericType) convertedVector = new SpatialVector!(3, destination.NumericType)(cast(MeshTypeDestination.NumericType)iterationVertex.position.x, cast(MeshTypeDestination.NumericType)iterationVertex.position.y, cast(MeshTypeDestination.NumericType)iterationVertex.position.z);
		destination.addVertex(new MeshVertex!(destination.NumericType)(convertedVector));
	}
	
	return destination;
}