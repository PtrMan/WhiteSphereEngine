module whiteSphereEngine.test.rocketTrajectorySolver.MathematicaDebug;

import std.format : format;

import math.NumericSpatialVectors;
import math.VectorAlias;

class DebugVector {
	Vector3f start;
	Vector3f end;
	EnumColor color;

	final this(Vector3f start, Vector3f end, EnumColor color = EnumColor.BLACK) {
		this.start = start;
		this.end = end;
		this.color = color;
	}

	enum EnumColor {
		BLACK,
		RED,
		BLUE,
		GREEN,
		YELLOW,
	}
}

string calcMathematicaFormOfVectors(DebugVector[] vectors) {
	string result = "Graphics3D[{";

	foreach( i, iterationVector; vectors ) {
		final switch(iterationVector.color) with (DebugVector.EnumColor) {
			case BLACK: result ~= "Black"; break;
			case RED: result ~= "Red"; break;
			case BLUE: result ~= "Blue"; break;
			case GREEN: result ~= "Green"; break;
			case YELLOW: result ~= "Yellow"; break;
		}

		result ~= ",";


		result ~= format("Arrow[{%s, %s}]", calcMathematicaFormOfVector(iterationVector.start), calcMathematicaFormOfVector(iterationVector.end));

		bool isLast = i == vectors.length-1;
		if( !isLast ) {
			result ~= ", ";
		}
	}

	result ~= "}, PlotRange->{{-10, 50},{-15, 15},{-10, 10}}";

	// just for the 2d case
	//result ~= ",GridLines -> Automatic";

	result ~= "]";

	return result;
}

private string calcMathematicaFormOfVector(const Vector3f vector, bool threeDimensional = true) {
	if( threeDimensional ) {
		return format("{%s,%s,%s}", vector.x, vector.y, vector.z);
	}
	else {
		return format("{%s,%s}", vector.x, vector.y);
	}
}
