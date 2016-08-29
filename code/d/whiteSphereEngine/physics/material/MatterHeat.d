module whiteSphereEngine.physics.material.MatterHeat;

//import whiteSphereEngine.physics.material.thermodynamics.heatEquation;
// TODO< import Matter >


// just for testing
class Matter {
	final float calcSpecificHeatconductivity(float absolutePressureInKpa) {
		return heatConductivity;
	}

	final float calcSpecificHeatcapacity(float absolutePressureInKpa) {
		return 1.0f;
	}
  
	double heatConductivity = 0.1f;

	double temperatureInKelvin;
	double temperatureDelta;
}

class HeatTransmissionDescriptor {
	double heatTransmissionArea;
	float heatTransmissionThicknessInMeters; // is used by the heat transfer calculations
}

// works by calculating the heat transfer to the heat transmission volume and spreads then the heat over the remaining mass
// is maybe not 100% correct because the heat transmission thickness hould cancel out?
void calcHeatTransferBetweenMatter(const float absolutePressureInKpa, const HeatTransmissionDescriptor transmissionDescriptor, Matter matterA, const double aVolume, Matter matterB, const double bVolume)
in {
	assert(aVolume > calcHeatTransmissionVolume(transmissionDescriptor));
	assert(bVolume > calcHeatTransmissionVolume(transmissionDescriptor));
}
body {
	const double thermalConductivityA = matterA.calcSpecificHeatconductivity(absolutePressureInKpa);
	const double thermalConductivityB = matterB.calcSpecificHeatconductivity(absolutePressureInKpa);
	const double thermalCapacityA = matterA.calcSpecificHeatcapacity(absolutePressureInKpa);
	const double thermalCapacityB = matterB.calcSpecificHeatcapacity(absolutePressureInKpa);

	const double heatTransferVolume = calcHeatTransmissionVolume(transmissionDescriptor);

	const double temperatureDifferenceAtoB = matterA.temperatureInKelvin - matterB.temperatureInKelvin;
	const double temperatureDifferenceBtoA = -temperatureDifferenceAtoB;

	
	// calculate heat transfer from a to b and b to a
	const double qAtoB = calcSingleDirectionHeatTransfer(thermalConductivityA, transmissionDescriptor, temperatureDifferenceAtoB);
	const double qBtoA = calcSingleDirectionHeatTransfer(thermalConductivityB, transmissionDescriptor, temperatureDifferenceAtoB);

	const double q = (qAtoB+qBtoA)/2.0;

	const double newEnergyA = matterA.temperatureInKelvin*thermalCapacityA*aVolume - q;
	const double newEnergyB = matterB.temperatureInKelvin*thermalCapacityB*bVolume + q;

	const double newTemperatureA = newEnergyA / (thermalCapacityA*aVolume);
	const double newTemperatureB = newEnergyB / (thermalCapacityB*bVolume);

	const double deltaTA = newTemperatureA - matterA.temperatureInKelvin;
	const double deltaTB = newTemperatureB - matterB.temperatureInKelvin;

	matterA.temperatureDelta += deltaTA;
	matterB.temperatureDelta += deltaTB;
}

private double calcSingleDirectionHeatTransfer(const double thermalConductivity, const HeatTransmissionDescriptor transmissionDescriptor, float temperatureDifference) {
	return calcHeatConduction(thermalConductivity, transmissionDescriptor.heatTransmissionArea, temperatureDifference, transmissionDescriptor.heatTransmissionThicknessInMeters);
}

private double calcHeatTransmissionVolume(const HeatTransmissionDescriptor descriptor) {
	return descriptor.heatTransmissionArea*descriptor.heatTransmissionThicknessInMeters;
}

void main() {
	Matter matterA, matterB;

	matterA = new Matter;
	matterA.temperatureDelta = 0.0f;
	matterA.temperatureInKelvin = 100.0f;

	matterB = new Matter;
	matterB.temperatureDelta = 0.0f;
	matterB.temperatureInKelvin = 0.0f;

	HeatTransmissionDescriptor transmissionDescriptor = new HeatTransmissionDescriptor;
	transmissionDescriptor.heatTransmissionArea = 1.0f;
	transmissionDescriptor.heatTransmissionThicknessInMeters = 0.5f;

	float absolutePressureInKpa = 100.0f;

	float aVolume = 2.001f;
	float bVolume = 1.001f;

	calcHeatTransferBetweenMatter(absolutePressureInKpa, transmissionDescriptor, matterA, aVolume, matterB, bVolume);

	import std.stdio;
	writeln(matterA.temperatureDelta);
	writeln(matterB.temperatureDelta);
}





// TODO< remove >

// http://hyperphysics.phy-astr.gsu.edu/hbase/thermo/heatcond.html
Type calcHeatConduction(Type)(Type thermalConductivity, Type area, Type temperatureDifference, Type thickness) {
	return (thermalConductivity*area*temperatureDifference) / thickness;
}

