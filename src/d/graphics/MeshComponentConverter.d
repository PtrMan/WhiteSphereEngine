module graphics.MeshComponentConverter;

import linopterixed.linear.Vector;
import graphics.ImmutableMeshComponent;

ImmutableMeshComponent toImmutableMeshComponent(SpatialVectorStruct!(4, float)[] vectors) {
	float[4][] translatedVectors;
	translatedVectors.length = vectors.length;
	foreach( i; 0..translatedVectors.length ) {
		foreach( j; 0..4 ) {
			translatedVectors[i][j] = vectors[i][j];
		}
	}
	return ImmutableMeshComponent.makeFloat4(translatedVectors);
}

ImmutableMeshComponent toImmutableMeshComponent(SpatialVectorStruct!(2, float)[] vectors) {
	float[2][] translatedVectors;
	translatedVectors.length = vectors.length;
	foreach( i; 0..translatedVectors.length ) {
		foreach( j; 0..2 ) {
			translatedVectors[i][j] = vectors[i][j];
		}
	}
	return ImmutableMeshComponent.makeFloat2(translatedVectors);
}
