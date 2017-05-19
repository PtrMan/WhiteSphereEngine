// implementation of torus tests for the hierachical space division mechanism

// checks if the (dot product) of an position is inside the range from 0.0 to 1.0
bool isInside(VectorType)(VectorType orgin, VectorType deltaToNext, VectorType position) {
  float dotResult = dot(position-orgin, deltaToNext);
  return dotResult >= 0 && dotResult <= 1;
}

// projects a point on a plane
// see http://stackoverflow.com/questions/9605556/how-to-project-a-3d-point-to-a-3d-plane
// TODO< this is wrong >
VectorType project(VectorType, ScalarType)(VectorType n, ScalarType d, VectorType point) {
  return point - n.scale(distanceToPlane(n, d, point));
}

ScalarType distanceToPlane(VectorType, ScalarType)(VectorType n, ScalarType d, VectorType point) {
  return dot(n, point) - d;
}

struct Plane {
  Vector3p n;
  double d;
}

struct TorusSegment {
  Vector3p orgin, deltaToNext;
}

struct TorusInformation {
  Plane plane;
  Vector3p center;
  
  double innerRadius, outerRadius;
  
  TorusSegment[] segments;
}

bool nn(TorusInformation torus, Vector3p point, out size_t segmentIndex) {
  Vector3p projectedOnTorusPlane = project(torus.plane.n, torus.plane.d, point);
  Vector3p relativeToTorusCenter = projectedOnTorusPlane - torus.center;
  
  Vector3p relativeToTorusCenterNormalized = relativeToTorusCenter.normalized;
  Vector3p closestPointOnInnerCircles = relativeToTorusCenterNormalized.scale(torus.outerRadius) + torus.center;
  
  
  Vector3p distanceToBiggerCirlce = point - (closestPointOnInnerCircles);
  
  bool inTorus = distanceToBiggerCirlce.magnitude <= torus.innerRadius;
  if( !inTorus ) {
    return false;
  }
  
  // find the segment which includes the point
  foreach( iterationSegmentIndex, iterationTorus; torus.segments ) {
    if( isInside(iterationTorus.orgin, iterationTorus.deltaToNext, closestPointOnInnerCircles) ) {
      segmentIndex = iterationSegmentIndex;
      return true;
    }
  }
  
  return true; 
}


bool inRangeInclusive(double value, double lower, double higher) {
  return value >= lower && value <= higher;
}

