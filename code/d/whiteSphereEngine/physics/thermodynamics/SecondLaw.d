module whiteSphereEngine.physics.thermodynamics.SecondLaw;

// helper
private double average(double a, double b) {
	return (a+b) * 0.5;
}

// see http://www.engineeringtoolbox.com/law-thermodynamics-d_94.html
// entropy definition
double calcSpecificEntropy(double specificEnthalpyBefore, double temperatureBeforeInKelvin, double specificEnthalpyAfter, double temperatureAfterInKelvin)
in {
	assert(specificEnthalpyBefore >= 0.0);
	assert(temperatureBeforeInKelvin >= 0.0);

	assert(specificEnthalpyAfter >= 0.0);
	assert(temperatureAfterInKelvin >= 0.0);
}
body {
	return (specificEnthalpyAfter - specificEnthalpyBefore) / average(temperatureBeforeInKelvin, temperatureAfterInKelvin);
}
