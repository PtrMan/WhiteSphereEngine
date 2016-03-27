module ai.fuzzy.FuzzyElement;

import math.Range;
import math.LinearEquation;
import ai.fuzzy.Trapezoid;

class FuzzyElement {
	public Trapezoid trapezoid;
	
	public final this(Trapezoid trapezoid) {
		this.trapezoid = trapezoid;
	}
	
	public final bool isInRange(float value) {
		return .isInRange(trapezoid.x0, trapezoid.x3, value);
	}
	
	public final float calcIntersection(float value) {
		assert(isInRange(value));
		
		float m, n;
		
		if( .isInRangeInclusive(trapezoid.x0, trapezoid.x1, value) ) {
			m = calculateM(trapezoid.x0, 0.0f, trapezoid.x1, trapezoid.y1);
			n = calculateN(m, trapezoid.x0, 0.0f);
		}
		else if( .isInRangeInclusive(trapezoid.x1, trapezoid.x2, value) ) {
			m = calculateM(trapezoid.x1, trapezoid.y1, trapezoid.x2, trapezoid.y2);
			n = calculateN(m, trapezoid.x1, trapezoid.y1);
		}
		else { // between x2 and x3
			m = calculateM(trapezoid.x2, trapezoid.y2, trapezoid.x3, 0.0f);
			n = calculateN(m, trapezoid.x2, trapezoid.y2);
		}
		
		return calcY(m, n, value);
	}
}
