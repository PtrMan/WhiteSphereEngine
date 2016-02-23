module RandomUtility;

// result range is [0.0, 1.0)
double radicalInverse(long N, long BaseValue) {
	double Val = 0.0f;
	double InvBase = 1.0 / cast(double)BaseValue;
	double InvBi = InvBase;

	while (N > 0) {
		long Di = (N % BaseValue);
		Val += (cast(double)Di * InvBi);
		N = cast(long)(cast(double)N * InvBase);
		InvBi *= InvBase;
	}

	return Val;
}
