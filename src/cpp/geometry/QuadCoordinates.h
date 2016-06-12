// THIS DOESN'T MATHEMATICALLY WORK

#pragma once

#include <cmath>

#include "math/Math.h"


// for debugging
#include <iostream>
using namespace std;

// for math see Mathematic document "QuadCoordinates.nb"
/*
template<typename NumericType>
bool calcQuadCoordinatesCalcSHelper(
	NumericType ax, NumericType ay,
	NumericType bx, NumericType by,
	NumericType cx, NumericType cy,
	NumericType dx, NumericType dy,

	NumericType px, NumericType py,


	NumericType &s
) {
	cout << "ay "<< ay<<endl;

	NumericType insideSqrt = static_cast<NumericType>(-4)*(ay*bx - ax*by + by*cx - bx*cy - ay*dx + cy*dx + ax*dy - cx*dy)*(cy*dx - cx*dy - 
			static_cast<NumericType>(2)*cy*px + dy*px + static_cast<NumericType>(2)*cx*py - dx*py) + 
		pow<2>(-(by*cx) + bx*cy + ay*dx - static_cast<NumericType>(2)*cy*dx - ax*dy + static_cast<NumericType>(2)*cx*dy - 
			static_cast<NumericType>(2)*ay*px + by*px + static_cast<NumericType>(2)*cy*px - dy*px + static_cast<NumericType>(2)*ax*py - bx*py -
		 static_cast<NumericType>(2)*cx*py + dx*py);

	cout << insideSqrt << endl;

	if( insideSqrt < static_cast<NumericType>(0) ) {
		cout << "HERE"<< endl;
		return false;
	}

	cout << "HERE2"<< endl;


	cout << "ay "<< ay<<endl;


	cout << "ay "<< ay<<endl;

	NumericType divisor = (static_cast<NumericType>(2.)*(ay*bx - ax*by + by*cx - bx*cy - ay*dx + cy*dx + ax*dy - cx*dy));
	cout << "ay "<< ay<<endl;

	cout << ay<<"*"<<bx<<" - "<<ax<<"*"<<by<<" + "<<by<<"*"<<cx<<" - "<<bx<<"*"<<cy<<" - "<<ay<<"*"<<dx<<" + "<<cy<<"*"<<dx<<" + "<<ax<<"*"<<dy<<" - "<<cx<<"*"<<dy << endl;

	cout << "insideSqrt " << insideSqrt << endl;
	cout << "divisor " << divisor << endl;

	if( divisor == static_cast<NumericType>(0) ) {
		return false;
	}

	s = (by*cx - bx*cy - ay*dx + static_cast<NumericType>(2)*cy*dx + ax*dy - static_cast<NumericType>(2)*cx*dy + static_cast<NumericType>(2)*ay*px - by*px - static_cast<NumericType>(2)*cy*px + dy*px - static_cast<NumericType>(2)*ax*py + bx*py + static_cast<NumericType>(2)*cx*py - dx*py - 
		static_cast<NumericType>(sqrt(insideSqrt)))/divisor;

	cout << "here s= "<<s<<endl;

	return true;
}

// quad is
// A---B
// |   |
// |   |
// C---D
template<typename NumericType>
bool calcQuadCoordinateS(
	VectorSoa<NumericType> a, VectorSoa<NumericType> b,
	VectorSoa<NumericType> c, VectorSoa<NumericType> d,
	VectorSoa<NumericType> position,
	NumericType &s
) {
	bool calleeSuccess;

	cout << "calcQuadCoordinateS: a.y= "<<a.y << endl;

	// first we try to calculate s for the xy plane
	calleeSuccess = calcQuadCoordinatesCalcSHelper<NumericType>(
		a.x, a.y,
		b.x, b.y,
		c.x, c.y,
		d.x, d.y,
		position.x, position.y,
		s
	);
	if( calleeSuccess ) {}
	// else we try with a yz combination
	else if( calcQuadCoordinatesCalcSHelper<NumericType>(
		a.y, a.z,
		b.y, b.z,
		c.y, c.z,
		d.y, d.z,
		position.y, position.z,
		s
	) ) {}
	// else we try it with a xz combination
	else if( calcQuadCoordinatesCalcSHelper<NumericType>(
		a.x, a.z,
		b.x, b.z,
		c.x, c.z,
		d.x, d.z,
		position.x, position.z,
		s
	) ) {}
	else {
		// coordinates are completly messed up so we can find in no 2d project a s, we give up
		// this is extremly unlikely and indicates a real problem

		return false;
	}

	return true;
}
*/

/*
template<typename NumericType>
bool calcQuadCoordinateT(
	NumericType baseTopX, NumericType baseTopY,
	NumericType topDiffX, NumericType topDiffY,
	NumericType baseBottomX, NumericType baseBottomY,
	NumericType bottomDiffX, NumericType bottomDiffY,

	NumericType px, NumericType py,
	NumericType &t
	)
{
	NumericType insideSqrt = pow<2>(baseBottomY*bottomDiffX - baseTopY*bottomDiffX - baseBottomX*bottomDiffY + baseTopX*bottomDiffY) - 4*(-(baseBottomY*bottomDiffX) + baseBottomX*bottomDiffY - bottomDiffY*px + bottomDiffX*py)*(bottomDiffY*topDiffX - bottomDiffX*topDiffY);

	cout << "inside sqrt " << insideSqrt << endl;

	NumericType divisor = (2.*(bottomDiffY*topDiffX - bottomDiffX*topDiffY));

	cout << "divisor " << divisor << endl;

	t = (-(baseBottomY*bottomDiffX) + baseTopY*bottomDiffX + baseBottomX*bottomDiffY - baseTopX*bottomDiffY - sqrt(insideSqrt))/ divisor;

	return true;
}*/