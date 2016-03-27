module celestial.CelestialObjectWithPosition;

import math.NumericSpatialVectors : SpatialVector;
import celestial.CelestialObject;

class CelestialObjectWithPosition {
	SpatialVector!(3, double) position;
	
	CelestialObject celestialObject;
  
  	public final this(CelestialObject parameterCelestialObject, SpatialVector!(3, double) parameterPosition) {
    	position = parameterPosition;
    	celestialObject = parameterCelestialObject;
  	}
}
