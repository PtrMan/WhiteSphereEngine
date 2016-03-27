module math.Math;

// http://stackoverflow.com/questions/16443682/c-power-of-integer-template-meta-programming
T exponentInteger(T)(T base, uint exponent) {
	// (parentheses not required in next line)
    return (exponent == 0) ? 1 : (base * exponentInteger(base, exponent-1));
}
