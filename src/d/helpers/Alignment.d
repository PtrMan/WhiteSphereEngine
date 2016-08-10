module helpers.Alignment;

// works for nonpower of two too
Type alignAt(Type)(Type value, Type alignment) {
	return ((value/alignment) + (((value % alignment) != 0) ? 1 : 0)) * alignment;
}

unittest {
	assert(alignAt!size_t(0, 4) == 0);
	assert(alignAt!size_t(1, 4) == 4);
	assert(alignAt!size_t(3, 4) == 4);
	assert(alignAt!size_t(4, 4) == 4);
	assert(alignAt!size_t(5, 4) == 8);	
}
