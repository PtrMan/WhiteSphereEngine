module math.Range;

private bool isInRange(Type)(Type x0, Type x1, Type x) {
	assert(x0 <= x1);

	return x0 < x && x < x1;
}

private bool isInRangeInclusive(Type)(Type x0, Type x1, Type x) {
	assert(x0 <= x1);

	return x0 <= x && x <= x1;
}

enum EnumRangeType {
	INCLUSIVE,
	EXCLUSIVE
}

bool isInRangeEnum(EnumRangeType rangeType, Type)(Type x0, Type x1, Type x) {
	final switch(rangeType) with(EnumRangeType) {
		case INCLUSIVE: return isInRangeInclusive(x0, x1, x);
		case EXCLUSIVE: return isInRange(x0, x1, x);
	}
}
