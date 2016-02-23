module BoxMullerTransform;

import std.random : Random, uniform;
import std.math : sqrt, log, sin, cos, PI;

// random number generator which generates two independent gaussian distributed numbers
// https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform

void generate(ScalarType)(Random random, out ScalarType z0, out ScalarType z1) {
	ScalarType u1 = uniform(cast(ScalarType)0, cast(ScalarType)1, random);
	ScalarType u2 = uniform(cast(ScalarType)0, cast(ScalarType)1, random);

	ScalarType scale = sqrt(cast(ScalarType)(-2.0)*log(u1));

	z0 = scale * cos(cast(ScalarType)(2.0 * PI) * u2);
	z1 = scale * sin(cast(ScalarType)(2.0 * PI) * u2);
}

ScalarType generateSingleGaussian(ScalarType)(Random random, ScalarType sigma, ScalarType mu) {
	ScalarType z0, z1;
	generate(random, z0, z1);
	return z0 * sigma + mu;
}

void generateDualGaussian(ScalarType)(Random random, ScalarType sigma, ScalarType mu, out ScalarType result0, out ScalarType result1) {
	ScalarType z0, z1;
	generate(random, z0, z1);
	result0 = z0 * sigma + mu;
	result1 = z1 * sigma + mu;
}
