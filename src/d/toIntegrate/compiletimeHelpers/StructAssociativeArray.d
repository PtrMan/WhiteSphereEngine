// TODO< module >

/**
 * used to simplify codegen of redudant API struct usage
 *
 * is mainly useful for compiletime heavy lifting
 */

struct AssociativeStructure {
	public string[string] structDefs;
}

// useful for for example the inheriation of structure definitions
public AssociativeStructure collapse(AssociativeStructure[] input) {
	AssociativeStructure result = input[0];
	
	foreach( AssociativeStructure iterationStruct; input[1..$] ) {
		foreach( string currentKey; iterationStruct.structDefs.keys ) {
			result.structDefs[currentKey] = iterationStruct.structDefs[currentKey];
		}
	}
	
	return result;
}

public string genCodeForAssociativeStructure(string prefix, AssociativeStructure structure) {
	import std.format : format;
	
	string resultCode;
	
	foreach( string currentKey; structure.structDefs.keys ) {
		resultCode ~= format("%s.%s = %s;\n", prefix, currentKey, structure.structDefs[currentKey]);
	}
	
	return resultCode;
}

// for shorthand notation
public string genCodeForCollapsedAssocStruct(string prefix, AssociativeStructure[] structures) {
	return genCodeForAssociativeStructure(prefix, collapse(structures));
}
