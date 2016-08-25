module PrototypeQueueAndBurningSystem;

// routing information is prebaked

import common.ArrayQueue;

struct RoutingInfoWithPayload(PayloadType) {
	PayloadType payload;
	size_t[] remainingRoute;

	final @property bool isForThisRoute() {
		// if the length of the remaining route is zero, then its for the node which did the call
		return remainingRoute.length == 0;
	}
}

class RoutingNode(PayloadType) {
	RoutingInfoWithPayload!PayloadType*[] queueIn;
	RoutingInfoWithPayload!PayloadType*[] queueOut;

	protected RoutingInfoWithPayload!PayloadType*[] queuedForThisNode;

	
	RoutingNode!PayloadType[] neightbors;

	final void step() {
		if( queueIn.length > 0 ) {
			routeNext();
		}
	}

	// safe for out of range check
	@safe final protected void routeNext() {
		assert( queueIn.length > 0 );

		RoutingInfoWithPayload!PayloadType* payloadToRoute = queueIn.dequeue();

		if( payloadToRoute.isForThisRoute ) {
			queuedForThisNode.enqueue(payloadToRoute);
		}
		else {
			// try to route
			size_t neighborAdress = payloadToRoute.remainingRoute.dequeue();
			neightbors[neighborAdress].queueIn.enqueue(payloadToRoute);
		}
	}
}




import whiteSphereEngine.physics.material.Matter;

import math.NumericSpatialVectors;
import math.VectorAlias;

// all physical "things"
class ObjectMadeOfMaterialInShape {
	Matter matter;
	
	public enum EnumShape {
		SHAPELESS,
		BOX,
	}
	Vector3f shapeSize;
	float shapeRadius;
	EnumShape shape = EnumShape.SHAPELESS;
}

class EnergyPayload {
	double energy; // in joules
}


struct RoutingMaterialOrEnergyPayload {
	enum EnumType {
		ENERGY,
		OBJECT,
	}
	
	protected final this(EnumType type) {
		this.type = type;
	}
	
	static RoutingMaterialOrEnergyPayload makeObjectMadeOfMaterialInShape(ObjectMadeOfMaterialInShape objectMadeOfMaterialInShape) {
		RoutingMaterialOrEnergyPayload result;
		result.type = EnumType.OBJECT;
		result.objectMadeOfMaterialInShape = objectMadeOfMaterialInShape;
		return result;
	}
	
	static RoutingMaterialOrEnergyPayload makeEnergy(EnergyPayload energyPayload) {
		RoutingMaterialOrEnergyPayload result;
		result.type = EnumType.ENERGY;
		result.energyPayload = energyPayload;
		return result;
	}
	
	EnumType type;
	EnergyPayload energyPayload;
	ObjectMadeOfMaterialInShape objectMadeOfMaterialInShape;
}

// see https://en.wikipedia.org/wiki/Energy_density
// in joules
//immutable float[string] specificEnergies = ["coal":33e6, "tnt":4.6e6];

// stores the state of an burn node
class BurnNodeState {
	float accumulatedMassOfOxygen = 0.0f;
	

	float accumulatedMassOfCoal = 0.0f;
	// TODO< other burnable things >
	
	uint[] destinationAdress; // adress of burnproducts
}

void burnerProcess(RoutingNode!RoutingMaterialOrEnergyPayload node, BurnNodeState state, float[string] specificEnergies) {
	double accumulatedMassOfOxygen = 0.0;
	double accumulatedMassOfCoal = 0.0;

	foreach( iterationQueueElement; node.queuedForThisNode ) {
		// TODO< accumulate >


	}
	node.queuedForThisNode.length = 0;

	accumulatedMassOfOxygen = 2.0f; // hack
	accumulatedMassOfCoal = 1.1f; // hack

	// do burn calculations

	// for one process we need so and so much oxygen and coal

	// needs 1.64 kg of oxygen for 1 kg coal
	// see http://www.brighthubengineering.com/power-plants/20189-burning-coal-how-much-air-is-required/
	
	const double massOfBurnedCoal = 1.0;
	if( accumulatedMassOfOxygen > 1.64 * massOfBurnedCoal && accumulatedMassOfCoal > massOfBurnedCoal ) {
		

		accumulatedMassOfOxygen -= (1.64 * massOfBurnedCoal);
		accumulatedMassOfCoal -= (1.0 * massOfBurnedCoal);

		// create burn products and heat them
		
		// TODO< implement incomplete combustion (if it doesn't get enough oxygen) >

		// specific heat capacity of water
		// https://www.wolframalpha.com/input/?i=heat+capacity+water
		const double specificHeatCapacityWaterGas = 1.865; // joules per gram per kelvin
		const double specificHeatCapacityWaterLiquid = 4.18; // joules per gram per kelvin
		
		// see http://www.engineeringtoolbox.com/carbon-dioxide-d_974.html 
		// TODO< depends on temperature! >
		const double specificHeatCapacityCarbondioxide = 0.709; // joules per gram per kelvin
		
		// TODO< heat water until evaporation if enough heat is there with the physical interaction system
		// for now we just heat watervapor

		// and this just with hardcoded values for the burning
		// coal mass was 1.0 kg, after http://www.brighthubengineering.com/power-plants/20189-burning-coal-how-much-air-is-required/
		// 2.2% are hydrogen, furhter 1 kg of hydrogen and 8kg of oxgen are 9 kg water
		double massOfWaterVapor = massOfBurnedCoal * 0.022 * 9.0 /* kg of water from burning 1kg hydrogen and 8kg oxygen */;
		
		// for each kilo of coal it produces 3.67 kg of carbon dioxide;
		double massOfCarbonDioxide = massOfBurnedCoal * 3.67;
		
		
		// we go by mass here for the fraction
		float molarMassOfVaterVapor = 18.2f; // http://www.engineeringtoolbox.com/molecular-weight-gas-vapor-d_1156.html
		float molarMassOfCarbonDioxide = 44.01f; // http://www.engineeringtoolbox.com/molecular-weight-gas-vapor-d_1156.html
		MolarFractionTupleType[2] gasMixtureComponents = [
			MolarFractionTupleType(cast(float)(massOfWaterVapor / (massOfWaterVapor+massOfCarbonDioxide)), molarMassOfVaterVapor),
			MolarFractionTupleType(cast(float)(massOfCarbonDioxide / (massOfWaterVapor+massOfCarbonDioxide)), molarMassOfCarbonDioxide),
			
		];
		float[2] molarSpecificHeatOfGases = [
			calcMolarHeatCapacity(3.350f, 1, 18.02f),// specific heat: http://www.engineeringtoolbox.com/water-vapor-d_979.html
			                                         // depends on temperature
			                                         // http://www.engineeringtoolbox.com/molecular-weight-gas-vapor-d_1156.html
			calcMolarHeatCapacity(1.476f, 1, 44.01f), // http://www.engineeringtoolbox.com/carbon-dioxide-d_974.html
			                                          // depends on temperature
			                                          // http://www.engineeringtoolbox.com/molecular-weight-gas-vapor-d_1156.html
		];
		const float molarSpecificHeatOfGasMixture = calcMolarSpecificHeatOfGasMixture(gasMixtureComponents, molarSpecificHeatOfGases);
		
		double massSum = massOfWaterVapor + massOfCarbonDioxide;
		double heatOfMixtureKelvin = (1.0 / ((molarSpecificHeatOfGasMixture * 1000.0) * massSum) /* division converts from J/K to K/J */) * specificEnergies["coal"];
		
		import std.stdio;
		writeln("debug ", molarSpecificHeatOfGasMixture);
		writeln("burning of 1 kg coal heated mixture of [water(vapor), carbon dioxide(gas)] to ", heatOfMixtureKelvin, " K [inexact because values depend on temerature]");
		
		
		// now we put out the products
		
		// uncommented because pipe system will be used
		//RoutingInfoWithPayload!RoutingMaterialOrEnergyPayload *payloadForProduct = new RoutingInfoWithPayload!RoutingMaterialOrEnergyPayload;
		//ObjectMadeOfMaterialInShape oxygenObject = new ObjectMadeOfMaterialInShape();
		
		//queueOut.enqueue();
		
		
		// TODO< all products >
	}


	// TODO< do burn calculations with a chemaical binding energy simulation >

	// TODO< emit (heated) burn products >
}




// TODO< put this into file called "Specific"


// helper
// https://en.wikipedia.org/wiki/Heat_capacity
// " The molar heat capacity is the heat capacity per unit amount (SI unit: mole) of a pure substance"
//
// we calculate this by multiplying as given in the caculation
// the numberOfMolecules is important to get right!
float calcMolarHeatCapacity(float specificHeat, uint numberOfMolecules, float molarMass) {
	return specificHeat  *  cast(float)numberOfMolecules*molarMass;
}



// see "Rocket Propulsion Elements" page 160
const float universalGasConstant = 8.3143; // J/g-mol-K


import std.typecons : Tuple;
import std.algorithm.iteration : sum;




alias Tuple!(float, "fraction", float, "moleOfGas") MolarFractionTupleType;

// now we need to calculate the molar specific heat of a/the gas mixture

// dummy, just here for showing how to set the values...
//MolarFractionTupleType[2] gasMixtureComponents = [MolarFractionTupleType(0.3f, 4.0f), MolarFractionTupleType(0.7f, 8.0f)] // values just for testing
// same
//float[gasMixtureComponents.length] molarSpecificHeatOfComponents = [0.5f, 0.7f];



float calcMolarSpecificHeatOfGasMixture(MolarFractionTupleType[] gasMixtureComponents, float[] molarSpecificHeatOfComponents) {
	// see http://www.eng-tips.com/viewthread.cfm?qid=244590 first answer from buckley8 
	// who referenced "Rocket Propulsion Elements" page 161 where details are given
	//
	// https://en.wikipedia.org/wiki/Mole_fraction explains what an molar fraction in the formula is



	// helper for calculating the molar fraction of one gas

	// Tuple:
	//  fraction : is how much of the gas the component is made out of, [0; 1], where 1 is equal to 100%
	//  moleOfGas : is how much mole the gas has
	static float calcMolarFraction(MolarFractionTupleType component, MolarFractionTupleType[] components) {
		float divisionSum = 0.0;
		foreach( iterationComponents; components ) {
			divisionSum += (iterationComponents.fraction*iterationComponents.moleOfGas);
		}

		float dividend = component.fraction*component.moleOfGas;
		return cast(float)(cast(double)dividend / cast(double)divisionSum);
	}

	// calculate molar fractions
	float[] molarFractions;
	molarFractions.length = gasMixtureComponents.length;
	foreach( i; 0..gasMixtureComponents.length ) {
		molarFractions[i] = calcMolarFraction(gasMixtureComponents[i], gasMixtureComponents);
	}
	
	
	// now we calculate the molar specific heat of the mixture  cpMix as described in "Rocket Propulsion Elements" page 161
	float cpMix = 0.0;
	foreach( i; 0..gasMixtureComponents.length ) {
		cpMix += (molarFractions[i]*molarSpecificHeatOfComponents[i]);
	}
	cpMix = cpMix / molarFractions.sum;
	
	
	// as descibed in "Rocket Propulsion Elements" page 161
	assert(cpMix >= universalGasConstant);
	const float  kMix = cast(float)(cast(double)cpMix / (cast(double)cpMix - cast(double)universalGasConstant));
	return kMix;
}
