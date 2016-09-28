module graphics.MeshComponentConverter;

import linopterixed.linear.Vector;
import graphics.ImmutableMeshComponent;

ImmutableMeshComponent toImmutableMeshComponent(SpatialVector!(4, float)[] vectors) {
	float[4][] translatedVectors;
	translatedVectors.length = vectors.length;
	foreach( i; 0..translatedVectors.length ) {
		foreach( j; 0..4 ) {
			translatedVectors[j][i] = vectors[i][j];
		}
	}
	return ImmutableMeshComponent.makeFloat4(translatedVectors);
}
