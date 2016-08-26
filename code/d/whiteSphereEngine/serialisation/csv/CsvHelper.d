module whiteSphereEngine.serialization.csv.CsvHelper;

import std.csv;
import std.array : array;
import std.conv : to;
import std.algorithm.searching : find, boyerMooreFinder;

Type[] convertTextToCsv(Type)(string text, char seperator = ',') {
	return csvReader!Type(text, seperator).array;
}

Type[] jumpOverHeaderLinesAndReadCsv(Type)(string text, uint numberOfLinesToJumpOver, string seperator = ",")
in {
	assert(seperator.length == 1);
}
body {
	foreach( iterationLine; 0..numberOfLinesToJumpOver ) {
		text = text.find(boyerMooreFinder("\n"))[1..$-1];
	}

	return convertTextToCsv!Type(text, seperator[0]);
}

unittest {
	import std.typecons : Tuple;
	alias Tuple!(int, float) TestType;

	TestType[] result = jumpOverHeaderLinesAndReadCsv!TestType("aabb\nccdd\n5\t3.0\n2\t1.0\n", 2, "\t");
	assert(result.length == 2);
}
