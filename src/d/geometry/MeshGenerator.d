module geometry.MeshGenerator;

import std.math : sin, cos, PI;

import geometry.Mesh : Mesh, MeshEdge, MeshEdgeStruct, MeshFace, MeshVertex;
import math.NumericSpatialVectors;

class MeshGenerator(NumericType) {
	public static Mesh!NumericType generateYCylinder(NumericType heightY, NumericType sizeX, NumericType sizeZ, uint segments, bool caps = true) {
		Mesh!NumericType resultMesh = new Mesh!NumericType();
		
		MeshVertex!NumericType[] vertices;
		
		for( uint segmentI = 0; segmentI < segments; segmentI++ ) {
			NumericType angleInRad = (cast(NumericType)segmentI/cast(NumericType)segments) * cast(NumericType)(2.0*PI);
			NumericType circleX = cos(angleInRad) * sizeX;
			NumericType circleZ = sin(angleInRad) * sizeZ;
			
			vertices ~= new MeshVertex!NumericType(new SpatialVector!(3, NumericType)(circleX, heightY * cast(NumericType)0.5, circleZ));
		}
		
		for( uint segmentI = 0; segmentI < segments; segmentI++ ) {
			NumericType angleInRad = (cast(NumericType)segmentI/cast(NumericType)segments) * cast(NumericType)(2.0*PI);
			NumericType circleX = cos(angleInRad) * sizeX;
			NumericType circleZ = sin(angleInRad) * sizeZ;
			
			vertices ~= new MeshVertex!NumericType(new SpatialVector!(3, NumericType)(circleX, heightY  * cast(NumericType)-0.5, circleZ));
		}
		
		foreach( MeshVertex!NumericType iterationVertex; vertices ) {
			resultMesh.addVertex(iterationVertex);
		}
		
		
		
		// add side face
		for( uint faceI = 0; faceI < segments; faceI++ ) {
			int startIndex = faceI;
			int endIndex = (faceI+1) % segments;
			
			int vertex0 = endIndex;
			int vertex1 = startIndex;
			int vertex2 = startIndex + segments;
			int vertex3 = endIndex + segments;
			
			resultMesh.addFace(new MeshFace!NumericType([vertex0, vertex1, vertex2, vertex3]));
		}
		
		if( caps ) {
			{
				int[] vertexIndices;
			
				for( int faceI = segments - 1; faceI >= 0; faceI-- ) {
					vertexIndices ~= faceI;
				}
				
				resultMesh.addFace(new MeshFace!NumericType(vertexIndices));
			}
			
			{
				int[] vertexIndices;
			
				for( int faceI = 0; faceI < segments; faceI++ ) {
					vertexIndices ~= (faceI + segments);
				}
				
				resultMesh.addFace(new MeshFace!NumericType(vertexIndices));
			}
		}
		
		return resultMesh;
	}
	
	
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

				MeshVertex!NumericType createdVertex = new MeshVertex!NumericType(new SpatialVector!(3, NumericType)(absoluteX, absoluteY, cast(NumericType)0.0));
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