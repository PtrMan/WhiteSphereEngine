module ai.fuzzy.MergeArea1dUnittests;

import ai.fuzzy.Area1d;
import ai.fuzzy.MergeArea1d;

// exact overlapping case
unittest {
	{
		import std.stdio;
		writeln("exact overlap case");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 1.0f), new PointDescriptor(2.0f, 0.0f)];
	PointDescriptor[] pointsB = pointsA;

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 1.0f);
}

// distinct cases
unittest {
	{
		import std.stdio;
		writeln("distinct cases");
	}


	PointDescriptor[] pointsA = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 1.0f), new PointDescriptor(2.0f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(3.0f, 0.0f), new PointDescriptor(4.0f, 1.0f), new PointDescriptor(5.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 2.0f);
}

// overlapping distinct cases
unittest {
	{
		import std.stdio;
		writeln("overlap distinct cases");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 1.0f), new PointDescriptor(2.0f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(2.0f, 0.0f), new PointDescriptor(3.0f, 1.0f), new PointDescriptor(4.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 2.0f);
}

// masked case
// one area completly eats away the other
//  triangular cases
unittest {
	{
		import std.stdio;
		writeln("masked case(1)");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 0.5f), new PointDescriptor(2.0f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 1.0f), new PointDescriptor(2.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 1.0f);
}

// triangular case assymetric high
unittest {
	{
		import std.stdio;
		writeln("masked case(2)");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 0.5f), new PointDescriptor(2.0f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 1.0f), new PointDescriptor(3.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 0.5f + 1.0f);
}

// triangle case assymetric low
unittest {
	{
		import std.stdio;
		writeln("masked case(3)");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 0.5f), new PointDescriptor(2.0f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(-1.0f, 0.0f), new PointDescriptor(1.0f, 1.0f), new PointDescriptor(2.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 0.5f + 1.0f);
}

// triangle case skewed
unittest {
	{
		import std.stdio;
		writeln("masked case(4)");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(1.0f - 0.2f, 0.0f), new PointDescriptor(1.0f - 0.1f, 0.05f), new PointDescriptor(1.0f + 0.1f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 1.0f), new PointDescriptor(2.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 1.0f);
}


// trapezoid masked case
unittest {
	{
		import std.stdio;
		writeln("trapezoid masked(1)");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(1.5f, 0.0f), new PointDescriptor(2.5f, 1.0f), new PointDescriptor(3.5f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(0.5f, 1.0f), new PointDescriptor(4.5f, 1.0f), new PointDescriptor(5.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 0.25f + 4.0f + 0.25f);
}

unittest {
	{
		import std.stdio;
		writeln("trapezoid masked(2)");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(1.5f, 0.0f), new PointDescriptor(2.5f, 1.0f), new PointDescriptor(3.5f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(0.5f, 1.0f), new PointDescriptor(2.5f, 1.0f), new PointDescriptor(4.5f, 1.0f), new PointDescriptor(5.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 0.25f + 4.0f + 0.25f);
}



// intersection tests
unittest {
	{
		import std.stdio;
		writeln("intersection test(1)");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(1.5f, 0.0f), new PointDescriptor(2.5f, 2.0f), new PointDescriptor(3.5f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(0.5f, 1.0f), new PointDescriptor(4.5f, 1.0f), new PointDescriptor(5.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 0.25f + 1.5f + 1.5f + 1.5f + 0.25f);
}

unittest {
	{
		import std.stdio;
		writeln("intersection test(2)");
	}

	PointDescriptor[] pointsA = [new PointDescriptor(1.5f, 0.0f), new PointDescriptor(2.5f, 2.0f), new PointDescriptor(3.5f, 0.0f)];
	PointDescriptor[] pointsB = [new PointDescriptor(0.0f, 0.0f), new PointDescriptor(0.5f, 1.0f), new PointDescriptor(2.5f, 1.0f), new PointDescriptor(4.5f, 1.0f), new PointDescriptor(5.0f, 0.0f)];

	checkAreaForNonswappedAndSwappedCases(pointsA, pointsB, 0.25f + 1.5f + 1.5f + 1.5f + 0.25f);
}



// functions just for unittests
void checkAreaForNonswappedAndSwappedCases(PointDescriptor[] pointsA, PointDescriptor[] pointsB, float compareArea) {
	import std.math : abs;

	{
		Area1d resultArea = merge(new Area1d(pointsA), new Area1d(pointsB));
		debugPoints(resultArea.points);
		assert( abs(resultArea.calcArea() - compareArea) < 0.0001f );
	}

	{
		Area1d resultArea = merge(new Area1d(pointsB), new Area1d(pointsA));
		assert( abs(resultArea.calcArea() - compareArea) < 0.0001f );
	}
}

// debugging
void debugPoints(PointDescriptor[] points) {
	foreach( PointDescriptor iterationPoint; points ) {
		import std.stdio;
		writeln("x=", iterationPoint.x, " y=", iterationPoint.y);
	}
}
