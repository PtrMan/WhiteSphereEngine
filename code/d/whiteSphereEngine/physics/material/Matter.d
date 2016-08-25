module whiteSphereEngine.physics.material.Matter;

import std.algorithm.iteration : sum;
import std.algorithm.iteration : map;

import whiteSphereEngine.physics.nuclear.Nuclear;

// this module defines a physical matter which is made out of molecules of an isotope (can also be nonradioactive)



struct MaterialPart {
	IsotopeInfo isotope;
	double mass;
}

class Matter {
	/+ commented because we need an abstraction between the physical attributes and the matter itself
	// TODO< pressure >
	double temperature; // in kelvin
	+/

	MaterialPart[] isotopeFractions; // can be empty for special materials

	double specificHeatcapacity;
	double thermalConductivity;

	public enum EnumTag {
		BURNABLEASCOAL, // can be burned in furnances
		OXYGEN,
	}
	EnumTag[] tags; // to store usage hints

	final @property double mass() {
		if( tags.length > 0 && tags[0] == EnumTag.BURNABLEASCOAL ) {
			return overwriteMass;
		}
		return isotopeFractions.map!(a => a.mass).sum;
	}
	double overwriteMass; // for special materials
}