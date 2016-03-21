module geometry.MeshConverter;

import geometry.Mesh : Mesh, MeshEdge, MeshEdgeStruct, MeshFace, MeshVertex;
import math.NumericSpatialVectors;

public Mesh!NumericTypeB convert(NumericTypeA, NumericTypeB)(Mesh!NumericTypeA source) {
	Mesh!NumericTypeB destination = new Mesh!NumericTypeB();
	
	foreach( MeshFace!NumericTypeA iterationFace; source.faces ) {
		destination.addFace(new MeshFace!NumericTypeB(iterationFace.verticesIndices));
	}
	
	foreach( MeshVertex!NumericTypeA iterationVertex; source.vertices ) {
		SpatialVector!(3, NumericTypeB) convertedVector = new SpatialVector!(3, NumericTypeB)(cast(NumericTypeB)iterationVertex.position.x, cast(NumericTypeB)iterationVertex.position.y, cast(NumericTypeB)iterationVertex.position.z);
		destination.addVertex(new MeshVertex!NumericTypeB(convertedVector));
	}
	
	return destination;
}