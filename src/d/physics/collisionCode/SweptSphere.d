module physics.collisionCode.SweptSphere;

import math.NumericSpatialVectors : SpatialVector, magnitudeSquared, magnitude, normalized, dot, scale;
import physics.collisionCode.RayRay;

// relativly fast broadphase collision detection
// by using a swept sphere
// it is a sphere which got "extruded" with an cylinder, at the end is another sphere

// TODO< move into other file >
private NumericType distanceSquared(NumericType)(SpatialVector!(3, NumericType) a, SpatialVector!(3, NumericType) b) {
	return (a-b).magnitudeSquared();
}

private NumericType distance(NumericType)(SpatialVector!(3, NumericType) a, SpatialVector!(3, NumericType) b) {
	return (a-b).magnitude();
}


struct SweptSphere(NumericType) {
	bool isSingular; // if the sweep has a length of 0.0, b is not used
	
	SpatialVector!(3, NumericType) a, b;
	
	SpatialVector!(3, NumericType) cachedDiff; // (b - a)
	SpatialVector!(3, NumericType) cachedDiffNormalized; // (b - a).normalized()
	NumericType cachedAbDistance; // distance between a and b
	
	public final @property NumericType radiusSquared() {
		return radius*radius;
	}
	
	NumericType radius;
	
	public final void update() {
		if( isSingular ) {
			cachedDiff = null;
			cachedDiffNormalized = null;
			cachedAbDistance = cast(NumericType)0.0;
		}
		else {
			cachedDiff = (b - a);
			cachedDiffNormalized = (b - a).normalized();
			cachedAbDistance = (b - a).magnitude();
		}
	}
}

// checks just if the swept sphere collide, not when they collide
public bool collideSweptSpheres(NumericType)(ref SweptSphere!NumericType sweptSphereA, ref SweptSphere!NumericType sweptSphereB) {
	alias SpatialVector!(3, NumericType) VectorType;
	
	NumericType minimalDistanceOfCollisionSquared = (sweptSphereA.radius + sweptSphereB.radius)*(sweptSphereA.radius + sweptSphereB.radius);
	//NumericType minimalDistanceOfCollision = sweptSphereA.radius + sweptSphereB.radius;

	
	// project the position of the singular to the normalized difference
	bool collideSphereWithNonsingular(VectorType singularPosition, ref SweptSphere!NumericType sweptSphereNonSingular) {
		VectorType diff = singularPosition - sweptSphereNonSingular.a;
		NumericType projectedLength = dot(sweptSphereNonSingular.cachedDiffNormalized, diff);
		
		bool projectedPositionIsInsideSweep = projectedLength > cast(NumericType)0.0 && projectedLength < sweptSphereNonSingular.cachedAbDistance;
		if( projectedPositionIsInsideSweep ) {
			VectorType closestPositionOnSweep = sweptSphereNonSingular.a + sweptSphereNonSingular.cachedDiffNormalized.scale(projectedLength);
			NumericType squaredDistance = distanceSquared(singularPosition, closestPositionOnSweep);
			if( squaredDistance < minimalDistanceOfCollisionSquared ) {
				return true;
			}
		}
		
		if( projectedLength < cast(NumericType)0.0 ) {
			// can only collide between the cap sphere at a
			
			NumericType squaredDistance = distanceSquared(singularPosition, sweptSphereNonSingular.a);
			return squaredDistance < minimalDistanceOfCollisionSquared;
		}
		else {
			// can only collide between the cap sphere at b

			NumericType squaredDistance = distanceSquared(singularPosition, sweptSphereNonSingular.b);
			return squaredDistance < minimalDistanceOfCollisionSquared;
		}
	}
	
	bool collideSweptSphereSingularAndNonsignular(ref SweptSphere!NumericType sweptSphereSingular, ref SweptSphere!NumericType sweptSphereNonsingular) {
		// project the position of the singular sweptSphere to the normalized difference
		VectorType singularPosition = sweptSphereSingular.a;		
		return collideSphereWithNonsingular(singularPosition, sweptSphereNonsingular);
	}
	
	if( !sweptSphereA.isSingular && !sweptSphereB.isSingular ) {
		NumericType zero = cast(NumericType)0.0, one = cast(NumericType)1.0;
		
		NumericType at, bt;
		bool valid;
		closestTOfTwoRays!(NumericType, false)(
			sweptSphereA.a, sweptSphereA.cachedDiff,
			sweptSphereB.a, sweptSphereB.cachedDiff, 
			at, bt,
			valid);
		
		// should never happen
		assert( valid );
		if( !valid ) {
			return false;
		}
		
		if( at > zero && at < one ) {
			if( bt > zero && bt < one ) {
				VectorType projectedA = sweptSphereA.a + sweptSphereA.cachedDiff.scale(at);
				VectorType projectedB = sweptSphereB.a + sweptSphereB.cachedDiff.scale(bt);
				
				NumericType squaredDistance = distanceSquared(projectedA, projectedB);
				return squaredDistance < minimalDistanceOfCollisionSquared;
			}
			else if( bt <= zero ) {
				return collideSphereWithNonsingular(sweptSphereB.a, sweptSphereA);
			}
			else { // bt >= one
				return collideSphereWithNonsingular(sweptSphereB.b, sweptSphereA);
			}
		}
		else {
			if( at <= zero ) {
				return collideSphereWithNonsingular(sweptSphereA.a, sweptSphereB);
			}
			else { // bt >= one
				return collideSphereWithNonsingular(sweptSphereA.b, sweptSphereB);
			}
		}
	}
	else if( sweptSphereA.isSingular && !sweptSphereB.isSingular ) {
		return collideSweptSphereSingularAndNonsignular(sweptSphereA, sweptSphereB);
	}
	else if( !sweptSphereA.isSingular && sweptSphereB.isSingular ) {
		return collideSweptSphereSingularAndNonsignular(sweptSphereB, sweptSphereA);
	}
	else { // both are nonsingular
		// test generates to squared sphere check
		return distanceSquared(sweptSphereA.a, sweptSphereB.a) < minimalDistanceOfCollisionSquared;
	}
}

// singular and singular colliding
unittest {
	SweptSphere!double a, b;
	
	a.isSingular = true;
	a.a = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	a.radius = 2.0;
	
	b.isSingular = true;
	b.a = new SpatialVector!(3, double)(2.0, 0.0, 0.0);
	b.radius = 3.0;
	
	assert( true == collideSweptSpheres(a, b) );
	
	b.isSingular = true;
	b.a = new SpatialVector!(3, double)(4.0, 0.0, 0.0);
	b.radius = 3.0;

	assert( true == collideSweptSpheres(a, b) );
}

// singular and singular noncolliding
unittest {
	SweptSphere!double a, b;
	
	a.isSingular = true;
	a.a = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	a.radius = 2.0;
	
	b.isSingular = true;
	b.a = new SpatialVector!(3, double)(5.5, 0.0, 0.0);
	b.radius = 3.0;
	
	assert( false == collideSweptSpheres(a, b) );
}

// nonsingular and singular not colliding middle
unittest {
	SweptSphere!double singular, b;
	
	singular.isSingular = true;
	singular.a = new SpatialVector!(3, double)(1.0, 6.0, 0.0);
	singular.radius = 2.0;
	
	b.isSingular = false;
	b.a = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	b.b = new SpatialVector!(3, double)(2.0, 0.0, 0.0);
	b.radius = 3.0;
	b.update();
	
	// check for twisted order
	assert( false == collideSweptSpheres(singular, b) );
	assert( false == collideSweptSpheres(b, singular) );
}

// nonsingular and singular colliding middle
unittest {
	SweptSphere!double singular, b;
	
	singular.isSingular = true;
	singular.a = new SpatialVector!(3, double)(1.0, 1.0, 0.0);
	singular.radius = 2.0;
	
	b.isSingular = false;
	b.a = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	b.b = new SpatialVector!(3, double)(2.0, 0.0, 0.0);
	b.radius = 3.0;
	b.update();
	
	// check for twisted order
	assert( true == collideSweptSpheres(singular, b) );
	assert( true == collideSweptSpheres(b, singular) );
}

// nonsingular and singular colliding begin
unittest {
	SweptSphere!double singular, b;
	
	singular.isSingular = true;
	singular.a = new SpatialVector!(3, double)(-1.0, 0.0, 0.0);
	singular.radius = 2.0;
	
	b.isSingular = false;
	b.a = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	b.b = new SpatialVector!(3, double)(2.0, 0.0, 0.0);
	b.radius = 3.0;
	b.update();
	
	// check for twisted order
	assert( true == collideSweptSpheres(singular, b) );
	assert( true == collideSweptSpheres(b, singular) );
}

// nonsingular and singular colliding end
unittest {
	SweptSphere!double singular, b;
	
	singular.isSingular = true;
	singular.a = new SpatialVector!(3, double)(3.0, 0.0, 0.0);
	singular.radius = 2.0;
	
	b.isSingular = false;
	b.a = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	b.b = new SpatialVector!(3, double)(2.0, 0.0, 0.0);
	b.radius = 3.0;
	b.update();
	
	// check for twisted order
	assert( true == collideSweptSpheres(singular, b) );
	assert( true == collideSweptSpheres(b, singular) );
}

// singular and singular colliding middle-middle
unittest {
	SweptSphere!double a, b;
	
	a.isSingular = false;
	a.a = new SpatialVector!(3, double)(0.0, 10.0, 0.0);
	a.b = new SpatialVector!(3, double)(10.0, 0.0, 0.0);
	a.radius = 2.0;
	a.update();
	
	
	b.isSingular = false;
	b.a = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	b.b = new SpatialVector!(3, double)(10.0, 10.0, 0.0);
	b.radius = 3.0;
	b.update();
	
	// check for twisted order
	assert( true == collideSweptSpheres(a, b) );
	assert( true == collideSweptSpheres(b, a) );
}


// TODO< more cases, middle-end, middle-begin, begin-begin, end-end, begin-end >

// singular and singular not colliding
unittest {
	SweptSphere!double a, b;
	
	a.isSingular = false;
	a.a = new SpatialVector!(3, double)(0.0, 10.0, 6.0);
	a.b = new SpatialVector!(3, double)(10.0, 0.0, 6.0);
	a.radius = 2.0;
	a.update();
	
	
	b.isSingular = false;
	b.a = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	b.b = new SpatialVector!(3, double)(10.0, 10.0, 0.0);
	b.radius = 3.0;
	b.update();
	
	// check for twisted order
	assert( false == collideSweptSpheres(a, b) );
	assert( false == collideSweptSpheres(b, a) );
}
