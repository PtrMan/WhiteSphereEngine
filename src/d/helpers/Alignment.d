module helpers.Alignment;

// works for nonpower of two too
size_t alignAt(size_t value, size_t alignment) {
	return ((value/alignment) + (((value % alignment) != 0) ? 1 : 0)) * alignment;
}

unittest {
	assert(alignAt(0, 4) == 0);
	assert(alignAt(1, 4) == 4);
	assert(alignAt(3, 4) == 4);
	assert(alignAt(4, 4) == 4);
	assert(alignAt(5, 4) == 8);	
}
