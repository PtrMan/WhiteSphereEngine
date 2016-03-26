module ai.fuzzy.Area1d;

import ai.fuzzy.MergeArea1d;

class PointDescriptor {
	public float x, y;

	public final this(float x, float y) {
		this.x = x;
		this.y = y;
	}
}

class Area1d {
	// succeeding points witht the same x and y coordinates are allowed
	PointDescriptor[] points;

	public final this(PointDescriptor[] points) {
		this.points = points;
	}

	public final @property float minX() {
		return points[0].x;
	}

	public final @property float maxX() {
		return points[$-1].x;
	}

}

public float calcArea(Area1d area1d) {
	float calcAreaOfPoints(PointDescriptor[] points) {
		float area = 0.0f;

		foreach( i; 0..points.length-1 ) {
			float x0 = points[i].x;
			float y0 = points[i].y;
			float x1 = points[i+1].x;
			float y1 = points[i+1].y;

			assert( x1 >= x0 );

			float xDiff = x1 - x0;
			float yDiff = y1 - y0;

			float rectangularArea = y0 * xDiff;
			float triangularArea = 0.5f * xDiff * yDiff;

			float areaOfSegment = rectangularArea + triangularArea;

			area += areaOfSegment;
		}

		return area;
	}

	return calcAreaOfPoints(area1d.points);
}

public float calcWeightedX(Area1d area1d) {
	float calcForSegment(float m, float n, float x0, float x1) {
		// integral of (m*x + n)*x dx   from x0 to x1

		return -(n*x0*x0)/2.0f -(m*x0*x0*x0)/3.0f + (n*x1*x1)/2.0f + (m*x1*x1*x1)/3.0f;
	}

	float result = 0.0f;

	foreach( i; 0..area1d.points.length-1 ) {
		float x0 = area1d.points[i].x;
		float y0 = area1d.points[i].y;
		float x1 = area1d.points[i+1].x;
		float y1 = area1d.points[i+1].y;

		assert( x1 >= x0 );

		float m = calculateM(x0, y0, x1, y1);
		float n = calculateN(m, x0, y0);

		result += calcForSegment(m, n, x0, x1);
	}

	return result;
}


public Area1d merge(Area1d a, Area1d b) {
	Area1d minXArea, maxXArea;

	if( a.minX < b.minX ) {
		minXArea = a;
		maxXArea = b;
	}
	else {
		minXArea = b;
		maxXArea = a;
	}

	bool doOverlap = isInRangeInclusive(minXArea.minX, minXArea.maxX, maxXArea.minX);
	if( doOverlap ) {
		return new Area1d(mergeSlopeDescriptorsWhenOverlap(minXArea.points, maxXArea.points));
	}
	else {
		return new Area1d(minXArea.points ~ maxXArea.points);
	}
}
