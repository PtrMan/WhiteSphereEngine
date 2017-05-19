module whiteSphereEngine.physics.material.EvaporationHeat;

/+
this is outdated and maybe wrong, we use the formulate from http://www.engineeringtoolbox.com/law-thermodynamics-d_94.html

import std.math : pow;
import std.algorithm.comparison : max;

// TODO <extremly low><figure out compact formula to explain data from  http://www.thermopedia.com/content/1150/  depending on pressure>

// orginal source as the basis of the formula  https://en.wikipedia.org/wiki/Enthalpy_of_vaporization#/media/File:Heat_of_Vaporization_(Benzene%2BAcetone%2BMethanol%2BWater).png
// article                                     https://en.wikipedia.org/wiki/Enthalpy_of_vaporization
// i have experimented with mathematica to get close to the diagram, its not perfect
// Plot[45000 - x*59.8 - 1.0267^((x + 0)*1), {x, 0, 650 - 273}]
// the x is shifted by 273 K to get the melting temperature right
double calcHeatOfVaporizationWater(const double temperatureInKelvin, const double pressure) {
	if( temperatureInKelvin < 273.0 ) {
		return 45000.0;
	}
	const double x = temperatureInKelvin - 273.0; // do shifting
	double result = 45000.0 - x*59.8 - pow(1.0267, x);
	return max(result, 0.0);
}
+/