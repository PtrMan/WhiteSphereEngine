module math.LinearEquation;

float calculateM(float x0, float y0, float x1, float y1) {
	return (y1 - y0) / (x1 - x0);
}

float calculateN(float m, float x, float y) {
	return (-m * x) + y;
}

bool isMZero(float y1, float y2) {
	return y1 == y2;
}

float calcY(float m, float n, float x) {
	return m*x + n;
}

void calculateIntersection(float ax0, float ay0, float ax1, float ay1, float bx0, float by0, float bx1, float by1, out float x, out float y) {
	float am = calculateM(ax0, ay0, ax1, ay1);
	float an = calculateN(am, ax0, ay0);

	float bm = calculateM(bx0, by0, bx1, by1);
	float bn = calculateN(bm, bx0, by0);

	x = (an - bn) / (bm - am);
	y = am * x + an;
}
