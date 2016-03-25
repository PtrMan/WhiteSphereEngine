module math.RandomUtility;

NumericType radicalInverse(NumericType)(long n, long baseValue) {
    NumericType Val = cast(NumericType)0.0;
    NumericType InvBase = cast(NumericType)1.0 / cast(NumericType)baseValue;
    NumericType InvBi = InvBase;

    while (n > 0) {
        long Di = (n % baseValue);
        Val += ((float)Di * InvBi);
        n = (int)((float)n * InvBase);
        InvBi *= InvBase;
    }

    return Val;
}
