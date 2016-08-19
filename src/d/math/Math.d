module math.Math;

// TODO< remove because of Stackoverflow crap >
// http://stackoverflow.com/questions/16443682/c-power-of-integer-template-meta-programming
T exponentInteger(T)(T base, uint exponent) {
	// (parentheses not required in next line)
    return (exponent == 0) ? 1 : (base * exponentInteger(base, exponent-1));
}

Type powerByInteger(uint power, Type)(Type number) {
  Type result = cast(Type)1;
  foreach( i; 0..power ) {
    result *= number;
  }
  return result;
}
