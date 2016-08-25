module whiteSphereEngine.physics.material.EvaporationHeat;

import std.math : pow;
import std.algorithm.comparison : max;

// orginal source as the basis of the formula
// i have experimented with mathematica to get close to the diagram, its not perfect
// Plot[45000 - x*59.8 - 1.0267^((x + 0)*1), {x, 0, 650 - 273}]
// the x is shifted by 273 K to get the melting temperature right
double calcHeatOfVaporizationWater(const double temperatureInKelvin) {
	if( temperatureInKelvin < 273.0 ) {
		return 45000.0;
	}
	const double x = temperatureInKelvin - 273.0; // do shifting
	double result = 45000.0 - x*59.8 - pow(1.0267, x);
	return max(result, 0.0);
}
