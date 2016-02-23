// for debugging the generated meshes with mathematica

module MeshMathematicaDebug;

import std.format : format;
import Mesh : Mesh, MeshEdge, MeshEdgeStruct, MeshFace, MeshVertex;

public string calcMathematicaFormOfMesh(Mesh!float mesh) {
	string result = "Graphics3D[Polygon[{";

	uint faceI = 0;
	foreach( MeshFace!float iterationFace; mesh.faces ) {
		result ~= "{";

		uint vertexI = 0;
		foreach( uint iterationVertexIndex; iterationFace.verticesIndices ) {
			result ~= calcMathematicaFormOfVertex(mesh.vertices[iterationVertexIndex]);

			if( vertexI != iterationFace.verticesIndices.length-1 ) {
				result ~= ",";
			}

			vertexI++;
		}

		result ~= "}";

		if( faceI != mesh.faces.length-1 ) {
			result ~= ",";
		}

		faceI++;
	}

	result ~= "}]]";

	return result;
}

private string calcMathematicaFormOfVertex(MeshVertex!float vertex) {
	return "{" ~ format("%s,%s,%s", vertex.position.x, vertex.position.y, vertex.position.z) ~ "}";
}
