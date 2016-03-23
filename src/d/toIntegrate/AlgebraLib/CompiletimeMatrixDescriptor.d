module AlgebraLib.CompiletimeMatrixDescriptor;

/**
 * Holds informations about the matrix (alignment, location, size, ...) at compiletime
 * 
 * used only at compile time!
 */
final package class CompiletimeMatrixDescriptor {
	/*
	public enum EnumDatatype {
		FLOAT,   // 32 bit
		DOUBLE,  // 64 bit
		EXTENDED // 80 bit, not implemented
	}*/

	// has no constructor because the constructor has too many parameters

	//public uint alignment;
	public uint[] dimensions;
	public string pointerName;
	//public EnumDatatype datatype;
}
