module MeshGenerator;

import Mesh : Mesh, MeshEdge, MeshEdgeStruct, MeshFace, MeshVertex;
import NumericSpatialVectors;

class MeshGenerator(NumericType) {

	public static Mesh!NumericType generateYPlane(NumericType sizeX, NumericType sizeY, uint segmentsX, uint segmentsY) {
		// can also be used to add a plane to a mesh

		Mesh!NumericType resultMesh = new Mesh!NumericType();

		MeshVertex!NumericType[] vertices;

		MeshVertex!NumericType getGridVertex(uint x, uint y) {
			return vertices[x + y * (segmentsX+1)];
		}

		foreach( uint pointY; 0..segmentsY+1 ) {
			foreach( uint pointX; 0..segmentsX+1 ) {

				{
					import std.stdio;
					writeln(pointX);
				}

				NumericType relativeX = cast(NumericType)pointX * ( cast(NumericType)1.0/cast(NumericType)segmentsX);
				NumericType relativeY = cast(NumericType)pointY * ( cast(NumericType)1.0/cast(NumericType)segmentsY);

				NumericType absoluteX = relativeX * sizeX;
				NumericType absoluteY = relativeY * sizeY;

				MeshVertex!NumericType createdVertex = new MeshVertex!NumericType();
				createdVertex.position = new SpatialVector!(3, NumericType)(absoluteX, absoluteY, cast(NumericType)0.0);
				vertices ~= createdVertex;
			}
		}

		foreach( MeshVertex!NumericType iterationVertex; vertices ) {
			resultMesh.addVertex(iterationVertex);
		}

		// add faces
		foreach( uint segmentY; 0..segmentsY ) {
			foreach( uint segmentX; 0..segmentsX ) {
				MeshVertex!NumericType vertexTopLeft = getGridVertex(segmentX, segmentY);
				MeshVertex!NumericType vertexTopRight = getGridVertex(segmentX+1, segmentY);
				MeshVertex!NumericType vertexBottomRight = getGridVertex(segmentX+1, segmentY+1);
				MeshVertex!NumericType vertexBottomLeft = getGridVertex(segmentX, segmentY+1);

				resultMesh.addFace(new MeshFace!NumericType([vertexTopLeft.index, vertexBottomLeft.index, vertexBottomRight.index, vertexTopRight.index]));
			}
		}

		return resultMesh;
	}
}