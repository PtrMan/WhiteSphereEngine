module math.Range;

bool isInRange(float x0, float x1, float x) {
	assert(x0 <= x1);

	return x0 < x && x < x1;
}

bool isInRangeInclusive(float x0, float x1, float x) {
	assert(x0 <= x1);

	return x0 <= x && x <= x1;
}
