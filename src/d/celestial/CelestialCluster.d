module celestial.CelestialCluster;

import celestial.CelestialObject;

class CelestialCluster {
	Vector3p centerOffset = Vector3p.make(0.0, 0.0, 0.0);

	Vector3p leafPlaneNormal;
	// used to calculate the other vector and calculate the time based offset of the leaf
	Vector3p leafPlaneUpVector = Vector3p.make(0.0, 0.0, 1.0);
  
	// a and b values of the orbit of the leaf
	double leafOrbitA;
	double leafOrbitB;

	double leafOneOrbitTimeInSeconds;
	double leafOrbitTimeOffsetInSeconds;

	bool leafHasNoOrbit = true; // is the orbit deactived?

	CelestialCluster[] subclusters;

	// positions are relative to centerOffset
	CelestialObject leafCelestialObject;
  
	final this() {}
  
	final this(Vector3p centerOffset) {
		this.centerOffset = centerOffset;
	}
  
	/*nonfinal */ ~this() {
	}

	final @property bool isLeaf() const {
		return subclusters.length == 0;
	}
  
	final void unfoldRecursiveForAbsoluteTime(ref CelestialObjectWithPosition[] resultArray, ref Vector3p accumulatedOffset, const double absoluteTime) const {
		if( isLeaf ) {
			CelestialObjectWithPosition leafPositionForAbsoluteTime = calculateLeafPositionForAbsoluteTime(accumulatedOffset, absoluteTime);
			resultArray ~= leafPositionForAbsoluteTime;
		}
		else {
			foreach( iterationCluster; subclusters ) {
				iterationCluster.unfoldRecursiveForAbsoluteTime(resultArray, accumulatedOffset + iterationCluster.centerOffset, absoluteTime);
			}
		}
	}


	// returns null if it is not a leaf, should never happen
	final CelestialObjectWithPosition calculateLeafPositionForAbsoluteTime(const Vector3p accumulatedOffset, double absoluteTime) const {
		if( !isLeaf ) {
			return null;
		}
    
		///UE_LOG(YourLog,Log,TEXT("FCelestialCluster::calculateLeafPositionForAbsoluteTime() entry"));

		Vector3p celestialBodyAbsolutePosition = accumulatedOffset;
    
		if( !leafHasNoOrbit ) {
			const double totalPhase = (leafOrbitTimeOffsetInSeconds + absoluteTime)/leafOneOrbitTimeInSeconds;
			const double rayDirectionX = cos(totalPhase * 2.0*PI);
			const double rayDirectionY = sin(totalPhase * 2.0*PI);
			
			const double orbitRayPositionX = 0.0;
			const double orbitRayPositionY = 0.0;
			
			bool orbitRaySolved;
			float orbitRayT0, orbitRayT1;
			
			// shoot a ray into the ellipse at the (2d orbit) position
			
			EllipseRaySolver::solve(orbitRayPositionX, orbitRayPositionY, rayDirectionX, rayDirectionY, leafOrbitA, leafOrbitB, orbitRaySolved, orbitRayT0, orbitRayT1);
			if( !orbitRaySolved ) {
        		// should never happen
				///UE_LOG(YourLog,Fatal,TEXT("FCelestialCluster::calculateLeafPositionForAbsoluteTime() couldn't solve orbit!"));
			}

			///UE_LOG(YourLog,Log,TEXT("leafPlaneNormal <%f, %f, %f>"), static_cast<float>(leafPlaneNormal(0, 0)), static_cast<float>(leafPlaneNormal(1, 0)), static_cast<float>(leafPlaneNormal(2, 0)));
			///UE_LOG(YourLog,Log,TEXT("leafPlaneUpVector <%f, %f, %f"), static_cast<float>(leafPlaneUpVector(0, 0)), static_cast<float>(leafPlaneUpVector(1, 0)), static_cast<float>(leafPlaneUpVector(2, 0)));

			const double orbitPositionHorizontal = orbitRayPositionX + rayDirectionX * orbitRayT0;
			const double orbitPositionVertical = orbitRayPositionY + rayDirectionY * orbitRayT0;

			const Vector3p planeOffset = Vector3pUtilities::calculatePointOnPlane(leafPlaneUpVector, leafPlaneNormal, Vector3p.make(1.0, 0.0, 0.0), orbitPositionVertical, orbitPositionHorizontal);

			///UE_LOG(YourLog,Log,TEXT("planeOffset <%f, %f, %f>"), static_cast<float>(planeOffset(0, 0)), static_cast<float>(planeOffset(1, 0)), static_cast<float>(planeOffset(2, 0)));

			celestialBodyAbsolutePosition += (centerOffset + planeOffset);

			///UE_LOG(YourLog,Log,TEXT("celestialBodyAbsolutePosition <%f, %f, %f>"), static_cast<float>(celestialBodyAbsolutePosition(0, 0)), static_cast<float>(celestialBodyAbsolutePosition(1, 0)), static_cast<float>(celestialBodyAbsolutePosition(2, 0)));
		}
    
		CelestialObjectWithPosition resultCelestialObjectWithPosition = new FCelestialObjectWithPosition(leafCelestialObject, celestialBodyAbsolutePosition);

		///UE_LOG(YourLog,Log,TEXT("FCelestialCluster::calculateLeafPositionForAbsoluteTime() exit"));

		return resultCelestialObjectWithPosition;    
	}

	final double getMassSumRecursive() const {
		if( isLeaf ) {
			return leafCelestialObject.mass;
		}
    	else {
			double mass = 0;

			foreach( const FCelestialCluster iterationCluster; subclusters ) {
				mass += iterationCluster.getMassSumRecursive();
			}

			return mass;
		}
	}
}
