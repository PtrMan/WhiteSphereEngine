#include "geometry/RayPlane.h"

#include "geometry/QuadCoordinates.h"


#include <iostream>
using namespace std;

void main() {
	{
		Ray<float> ray;
		Plane<float> plane;

		ray.dir.x = 1.0f;
		ray.dir.y = 0.0f;
		ray.dir.z = 0.0f;
		ray.p0.x = 5.0f;
		ray.p0.y = 0.0f;
		ray.p0.z = 0.0f;

		VectorSoa<float> planeN;
		planeN.x = 1.0f;
		planeN.y = 1.0f;
		planeN.z = 1.0f;

		VectorSoa<float> planeP;
		planeP.x = 0.0f;
		planeP.y = 0.0f;
		planeP.z = 0.0f;

		plane = calcPlaneFromNormalAndPoint(planeN, planeP);


		float planeT = calcRayPlaneT(ray, plane);

		cout << planeT << endl;
	}

	/*
	bool calleeSuccess;
	VectorSoa<float>
		a = VectorSoa<float>(0.01f, 0.04f, 0.0f),
		b = VectorSoa<float>(1.02f, 0.01f, 0.0f),
		c = VectorSoa<float>(0.03f, 1.02f, 0.0f),
		d = VectorSoa<float>(0.04f, 1.03f, 0.0f),
		position = VectorSoa<float>(0.7f, 0.3f, 0.0f);

	float s;
	calleeSuccess = calcQuadCoordinateS(
		a, b,
		c, d,
		position,
		s
	);

	if( calleeSuccess ) {
		cout << "s " << s << endl;
	}
	else {
		cout << "no result" << endl;
	}
	*/

	{
		bool calleeSuccess;

		float t;
		calleeSuccess = calcQuadCoordinateT(
	0.0f, 0.0f,
	1.0f, 0.0f,
	0.0f, 1.0f,
	1.0f, 0.01f,

	0.5f, 0.6f,
	t
	);

		cout << calleeSuccess << endl;
		cout << t << endl;


	}
}
