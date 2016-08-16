module graphics.MeshComponentConverter;

import math.NumericSpatialVectors;
import graphics.ImmutableMeshComponent;

ImmutableMeshComponent toImmutableMeshComponent(SpatialVector!(4, float)[] vectors) {
	float[4][] translatedVectors;
	translatedVectors.length = vectors.length;
	foreach( i; 0..translatedVectors.length ) {
		foreach( j; 0..4 ) {
			translatedVectors[j][i] = vectors[i].data[j];
		}
	}
	return ImmutableMeshComponent.makeFloat4(translatedVectors);
}
