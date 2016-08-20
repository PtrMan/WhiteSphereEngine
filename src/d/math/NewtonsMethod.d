module math.NewtonsMethod;

// https://en.wikipedia.org/wiki/Newton%27s_method
Type newtonsMethod(Type)(Type delegate(Type value) f, Type delegate(Type value) fDerivative, Type accuracy, size_t maxRepetitions = -1, Type x = cast(Type)0) {
	assert(accuracy > cast(Type)0);

	foreach( repetition; 0..maxRepetitions ) {
		Type nextX = x - f(x)/fDerivative(x);
		if( abs(f(nextX)) < accuracy ) {
			return nextX;
		}
		x = nextX;
	}

	// if we are here we had enough repetitions
	return x;
}
