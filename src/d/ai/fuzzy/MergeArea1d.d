module ai.fuzzy.MergeArea1d;

// centroid for generalized trapezoid

import std.algorithm : min, max;

import math.Range;
import math.LinearEquation;
import ai.fuzzy.Area1d;

// we scan a for the intersections with b and iterate from there over a

// for the intersection of a as the maser with b there are four
// *   AAAAAAA
//   bbbb

// *   AAAAAAA
//          bbbb

// *   AAAAAAA
//       bbbb

// *   AAAAAAA
//   bbbbbbbbbbbb

// after this is done for each a segment the intersections have to be checked and the result calculated

// invariants : a is in front of b on the x axis
public PointDescriptor[] mergeSlopeDescriptorsWhenOverlap(PointDescriptor[] a, PointDescriptor[] b) {
	bool doesntIntersect = a[$-1].x < b[0].x;
	assert(!doesntIntersect);

	PointDescriptor[] result;

	struct CutCases {
		enum EnumCutCase {
			BCUTLOW,
			BCUTHIGH,
			BCONTAINED,
			EQUALOVERLAP,
			BINCLUDESA,
			BEXTERNAL 
		}

		public EnumCutCase cutCase;

		public final string getCaseAsString() {
			final switch(cutCase) {
				case EnumCutCase.BCUTLOW: return "BCUTLOW";
				case EnumCutCase.BCUTHIGH: return "BCUTHIGH";
				case EnumCutCase.BCONTAINED: return "BCONTAINED";
				case EnumCutCase.EQUALOVERLAP: return "EQUALOVERLAP";
				case EnumCutCase.BINCLUDESA: return "BINCLUDESA";
				case EnumCutCase.BEXTERNAL: return "BEXTERNAL";
			}
		}

		public final void calculate(float ax0, float ax1, float bx0, float bx1) {
			bool caseBCutLow = bx0 < ax0 && isInRange(ax0, ax1, bx1);
			bool caseBCutHigh = bx1 > ax1 && isInRange(ax0, ax1, bx0);
			bool caseBContained = isInRangeInclusive(ax0, ax1, bx0) && isInRangeInclusive(ax0, ax1, bx1);
			bool caseEqualOverlap = bx0 == ax0 && bx1 == ax1;
			bool caseBIncludesA = bx0 <= ax0 && ax1 <= bx1;
			bool caseBExternal = bx0 >= ax1;

			assert(caseBCutLow || caseBCutHigh || caseBContained || caseEqualOverlap || caseBIncludesA || caseBExternal );

			if( caseBCutLow ) {
				cutCase = EnumCutCase.BCUTLOW;
			}
			else if( caseBCutHigh ) {
				cutCase = EnumCutCase.BCUTHIGH;
			}
			else if( caseEqualOverlap ) {
				cutCase = EnumCutCase.EQUALOVERLAP;
			}
			else if( caseBContained ) {
				cutCase = EnumCutCase.BCONTAINED;
			}
			else if( caseBIncludesA ) {
				cutCase = EnumCutCase.BINCLUDESA;
			}
			else if( caseBExternal ) {
				cutCase = EnumCutCase.BEXTERNAL;
			}
		}

	}

	// calculate the ranges of the lines, clips b and calculates intersections if required
	// then it adds the right points to the result
	void calcPointsToAddToResult(float ax0, float ay0, float ax1, float ay1,  float bx0, float by0, float bx1, float by1, ref CutCases cutCases) {
		float am = calculateM(ax0, ay0, ax1, ay1);
		float an = calculateN(am, ax0, ay0);


		float transferedBx0 = bx0;
		float transferedBy0 = by0;
		float transferedBx1 = bx1;
		float transferedBy1 = by1;

		void addPoint(float x, float y) {
			result ~= new PointDescriptor(x, y);
		}

		void addPointsBeforeIntersection() {
			if( cutCases.cutCase == CutCases.EnumCutCase.BCUTLOW ) {
				addPoint(ax0, max(ay0, transferedBy0));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.BCUTHIGH ) {
				float interpolatedAy = am * transferedBx0 + an;

				addPoint(transferedBx0, max(interpolatedAy, transferedBy0));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.EQUALOVERLAP ) {
				assert(transferedBx0 == ax0 && transferedBx1 == ax1);

				addPoint(transferedBx0, max(ay0, transferedBy0));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.BCONTAINED ) {
				float interpolatedAy = am * transferedBx0 + an;
				
				addPoint(transferedBx0, max(interpolatedAy, transferedBy0));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.BINCLUDESA ) {
				addPoint(ax0, max(ay0, transferedBy0));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.BEXTERNAL) {
				if( bx0 == ax1 ) {
					addPoint(ax1, max(ay1, by0));
				}
				else {
					addPoint(ax1, ay1);
				}
			}
		}

		void addPointsAfterIntersection() {
			if( cutCases.cutCase == CutCases.EnumCutCase.BCUTLOW ) {
				float interpolatedAy = am * transferedBx1 + an;

				addPoint(transferedBx1, max(interpolatedAy, transferedBy1));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.BCUTHIGH ) {
				addPoint(ax1, max(ay1, transferedBy1));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.EQUALOVERLAP ) {
				assert(transferedBx0 == ax0 && transferedBx1 == ax1);

				addPoint(transferedBx1, max(ay1, transferedBy1));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.BCONTAINED ) {
				float interpolatedAy = am * transferedBx1 + an;
				
				addPoint(transferedBx1, max(interpolatedAy, transferedBy1));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.BINCLUDESA ) {
				addPoint(ax1, max(ay1, transferedBy1));
			}
			else if( cutCases.cutCase == CutCases.EnumCutCase.BEXTERNAL) {
				// nothing to do
			}
		}

		if( cutCases.cutCase == CutCases.EnumCutCase.BCUTLOW ) {
			float bm = calculateM(bx0, by0, bx1, by1);
			float bn = calculateN(bm, bx0, by0);

			float cuty = bm * ax0 + bn;

			transferedBx0 = ax0;
			transferedBy0 = cuty;
		}
		else if( cutCases.cutCase == CutCases.EnumCutCase.BCUTHIGH ) {
			float bm = calculateM(bx0, by0, bx1, by1);
			float bn = calculateN(bm, bx0, by0);

			float cuty = bm * ax1 + bn;

			transferedBx1 = ax1;
			transferedBy1 = cuty;
		}
		else if( cutCases.cutCase == CutCases.EnumCutCase.BCONTAINED || cutCases.cutCase == CutCases.EnumCutCase.EQUALOVERLAP ) {
			// no cut to calculate
		}
		else if( cutCases.cutCase == CutCases.EnumCutCase.BINCLUDESA ) {
			float bm = calculateM(bx0, by0, bx1, by1);
			float bn = calculateN(bm, bx0, by0);

			float cuty0 = bm * ax0 + bn;
			float cuty1 = bm * ax1 + bn;

			transferedBx0 = ax0;
			transferedBy0 = cuty0;
			transferedBx1 = ax1;
			transferedBy1 = cuty1;
		}
		else if( cutCases.cutCase == CutCases.EnumCutCase.BEXTERNAL ) {
			return;
		}

		addPointsBeforeIntersection();

		// intersection check
		if( isMZero(ay0, ay1) && isMZero(transferedBy0, transferedBy1) ) {
			
		}
		else {
			// calculate and check intersection
			float intersectionX, intersectionY;
			calculateIntersection(ax0, ay0, ax1, ay1, transferedBx0, transferedBy0, transferedBx1, transferedBy1, intersectionX, intersectionY);
			
			MinMax axMinMax = MinMax.createByValues(ax0, ax1);
			MinMax bxMinMax = MinMax.createByValues(transferedBx0, transferedBx1);

			bool xIntersectionInRange = axMinMax.isInRange(intersectionX) && bxMinMax.isInRange(intersectionX);

			if( xIntersectionInRange ) {
				result ~= new PointDescriptor(intersectionX, intersectionY);
			}
		}

		addPointsAfterIntersection();
	}

	// search for start of the intersection

	int aStartIndex = -1;

	foreach( ai; 0..a.length-1 ) {
		PointDescriptor aStart = a[ai];
		PointDescriptor aEnd = a[ai+1];

		if( b[0].x >= aStart.x && b[0].x <= aEnd.x ) {
			aStartIndex = ai;
			break;
		}
	}

	assert(aStartIndex != -1);

	// add the beginning of a
	result ~= a[0..aStartIndex+1];

	uint aIndex = aStartIndex;
	uint bIndex = 0;

	for(;;) {
		assert(aIndex <= a.length-1);
		assert(bIndex <= b.length-1);
		if( aIndex == a.length-1 || bIndex == b.length-1 ) {
			break;
		}

		float ax0 = a[aIndex].x;
		float ay0 = a[aIndex].y;
		float ax1 = a[aIndex+1].x;
		float ay1 = a[aIndex+1].y;

		float bx0 = b[bIndex].x;
		float by0 = b[bIndex].y;
		float bx1 = b[bIndex+1].x;
		float by1 = b[bIndex+1].y;

		CutCases cutCases;
		cutCases.calculate(ax0, ax1, bx0, bx1);

		calcPointsToAddToResult(ax0, ay0, ax1, ay1, bx0, by0, bx1, by1, cutCases);

		// logic to advance indices
		final switch( cutCases.cutCase ) {
			// cases for advancing a and b
			case CutCases.EnumCutCase.EQUALOVERLAP:
			aIndex++;

			// cases for advancing b
			case CutCases.EnumCutCase.BCONTAINED:
			case CutCases.EnumCutCase.BCUTLOW:
			bIndex++;
			break;

			// cases for only advance A
			case CutCases.EnumCutCase.BCUTHIGH:
			case CutCases.EnumCutCase.BINCLUDESA:
			case CutCases.EnumCutCase.BEXTERNAL:
			aIndex++;
			break;
		}
	}

	float lastResultX = result[$-1].x;

	// for maximum of area, add the remaining points of a or b
	if( aIndex == a.length-1 ) {
		foreach( iterationPosition; b[bIndex..$] ) {
			if( iterationPosition.x > lastResultX ) {
				result ~= iterationPosition;
			}
		}
	}
	else if( bIndex == b.length-1 ) {
		foreach( iterationPosition; a[aIndex..$] ) {
			if( iterationPosition.x > lastResultX ) {
				result ~= iterationPosition;
			}
		}
	}

	return result;
}


struct MinMax {
	public float min, max;

	public static MinMax createByValues(float a, float b) {
		MinMax result;
		result.min = .min(a, b);
		result.max = .max(a, b);
		return result;
	}

	public final bool isInRange(float value) {
		return min < value && value < max;
	}
}
