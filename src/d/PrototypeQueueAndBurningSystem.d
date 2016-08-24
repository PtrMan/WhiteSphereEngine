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

import whiteSphereEngine.physics.nuclear.Nuclear;

struct MaterialPart {
	IsotopeInfo isotope;
	double mass;
}



import std.algorithm.iteration : sum;
import std.algorithm.iteration : map;

import math.NumericSpatialVectors;
import math.VectorAlias;

// all physical "things"
class ObjectMadeOfMaterialInShape {
	double temperature; // in kelvin

	MaterialPart[] isotopeFractions; // can be empty for special materials

	final @property double mass() {
		if( tags.length > 0 && tags[0] == EnumTag.BURNABLEASCOAL ) {
			return overwriteMass;
		}
		return isotopeFractions.map!(a => a.mass).sum;
	}

	public enum EnumShape {
		SHAPELESS,
		BOX,
	}
	Vector3f shapeSize;
	float shapeRadius;
	EnumShape shape = EnumShape.SHAPELESS;
	
	double overwriteMass;

	public enum EnumTag {
		BURNABLEASCOAL, // can be burned in furnances
		OXYGEN,
	}
	EnumTag[] tags; // to store usage hints
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

		// specific heat capacity of water
		// https://www.wolframalpha.com/input/?i=heat+capacity+water
		const double specificHeatCapacityWaterGas = 1.865; // joules per gram per kelvin
		const double specificHeatCapacityWaterLiquid = 4.18; // joules per gram per kelvin

		// TODO< heat water until evaporation if enough heat is there with the physical interaction system
		// for now we just heat watervapor

		// and this just with hardcoded values for the burning
		// coal mass was 1.0 kg, after http://www.brighthubengineering.com/power-plants/20189-burning-coal-how-much-air-is-required/
		// 2.2% are hydrogen, furhter 1 kg of hydrogen and 8kg of oxgen are 9 kg water
		double massOfWaterVapor = massOfBurnedCoal * 0.022 * 9.0 /* kg of water from burning 1kg hydrogen and 8kg oxygen */;

		// calculate the heat of the watervapor (we pump all heat energy into it)
		// TODO< distribute heat energy >
		double heatOfWaterVaporInKelvin = 1.0 / ((specificHeatCapacityWaterGas * 0.001 /* convert to J/(kg*K) */) * massOfWaterVapor) /* division converts from J/K to K/J */ * specificEnergies["coal"];


		import std.stdio;
		writeln("burning of 1 kg coal heated water(vapor) to ", heatOfWaterVaporInKelvin, " K  [hack, heats only water vapor]");


		// now we put out the products
		// TODO< put out water vapor >

		// TODO< all products >
	}


	// TODO< do burn calculations with a chemaical binding energy simulation >

	// TODO< emit (heated) burn products >
}
