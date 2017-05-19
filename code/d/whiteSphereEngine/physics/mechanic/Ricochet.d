import std.math : abs, sgn;

// formula is after the graph in the forum post: https://forum.warthunder.com/index.php?/topic/327834-ricochet-mechanics/
double calcRicochetPropability(double penetrationArmorResistanceFactor) {
	const double steepPercentage = 1.0;
	const double steepFactor = steepPercentage/100.0;

	const double x = penetrationArmorResistanceFactor;
	if( x <= 0.88 ) {
		return 0.0;
	}
	else if( x <= 0.89 ) {
		const double xRelative = (x - 0.88) * (1.0/0.01);
		return steepFactor * xRelative;
	}
	else if( x <= 0.91 ) {
		return steepFactor;
	}
	else if( x <= 1.1 ) { // 0.9 to 1.1
		// https://www.wolframalpha.com/input/?i=(1-((0.1-abs(x-1))*(1.0%2F0.1))%5E2)*sgn(x-1)+from+0.9+to+1.1
		const double diffX = (0.1-abs(x-1.0))*(1.0/0.1);

		const double quadraticValueRangeM1P1 = (1.0-diffX*diffX)*sgn(x-1.0); // calculate the value for the x range from 0.9 to 1.1 and in the y range from -1 to 1
		const double quadraticValueRangeZeroP1 = (quadraticValueRangeM1P1+1.0) / 2.0;

		return quadraticValueRangeZeroP1*(1.0-steepFactor*2.0)+steepFactor;
	}
	else if( x <= 1.11 ) {
		return 1.0-steepFactor;
	}
	else if( x <= 1.12 ) {
		const double xRelative = (x - 1.11) * (1.0/0.01);
		return 1.0-steepFactor + (steepFactor * xRelative);
	}
 	else {
		return 1.0;
	}
}
