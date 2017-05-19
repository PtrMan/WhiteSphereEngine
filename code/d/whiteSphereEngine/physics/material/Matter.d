module whiteSphereEngine.physics.material.Matter;

import std.algorithm.iteration : sum;
import std.algorithm.iteration : map;

import whiteSphereEngine.physics.nuclear.Nuclear;
import whiteSphereEngine.physics.material.state.MatterStateFacade;
import whiteSphereEngine.material.state.MatterPhysicalState;

// this module defines a physical matter which is made out of molecules of an isotope (can also be nonradioactive)

// can be globally defined for fast lookup
class Molecule {
	static struct IsotopeWithNumberOfAtoms {
		IsotopeInfo isotope;
		uint numberOfAtoms;
	}

	IsotopeWithNumberOfAtoms[] bonding; // how is the molecule composed?, includes isotopes
}

class MolecularComposition {
	static struct MolecularCompositionPart {
		Molecule molecule;
		double mass;
	}

	MolecularCompositionPart[] molecularCompositionParts;
}


class Matter {
	MolecularComposition molecularComposition; // can be null for vacuum
	EnumMatterPhysicalState matterPhysicalState; // invalid for vaccuum
	double temperatureInKelvin = 0.0; // invalid for vacuum
	double deltaTemperature;

	final void resetDeltaTemperature() {
		deltaTemperature = 0.0;
	}

	MatterStateFacade matterStateFacade;

	// TODO< retrival of thermalConductivity which gets dispatched to calls to matterStateFacade, parameters are the pressure, and the temperature and state, but tese get taken from the matter fields >

	final float calcSpecificHeatcapacity(float absolutePressureInKpa) {
		assert( !isVacuum, "calcSpecificHeatcapacity() requested for vacuum!");
		return matterStateFacade.calcHeatCapacity(absolutePressureInKpa, temperatureInKelvin, matterPhysicalState);
	}


	public enum EnumTag {
		BURNABLEASCOAL, // can be burned in furnances
		OXYGEN,
	}
	EnumTag[] tags; // to store usage hints

	final @property bool isVacuum() {
		return molecularComposition is null;
	}

	final @property double mass() {
		assert( !isVacuum, "mass property requested for vacuum!");
		return molecularComposition.molecularCompositionParts.map!(a => a.mass).sum;
	}
}
