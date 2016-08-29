module whiteSphereEngine.physics.material.MatterHeat;

import whiteSphereEngine.physics.material.thermodynamics.heatEquation;
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

struct HeatTransmissionDescriptor {
	double heatTransmissionArea;
	float heatTransmissionThicknessInMeters; // is used by the heat transfer calculations
}

double calcHeatTransferBetweenMatter(const float absolutePressureInKpa, const HeatTransmissionDescriptor transmissionDescriptor, Matter matterA, const double aVolume, Matter matterB, const double bVolume)
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

	return q;
}

private double calcSingleDirectionHeatTransfer(const double thermalConductivity, const HeatTransmissionDescriptor transmissionDescriptor, float temperatureDifference) {
	return calcHeatConduction(thermalConductivity, transmissionDescriptor.heatTransmissionArea, temperatureDifference, transmissionDescriptor.heatTransmissionThicknessInMeters);
}

private double calcHeatTransmissionVolume(const HeatTransmissionDescriptor descriptor) {
	return descriptor.heatTransmissionArea*descriptor.heatTransmissionThicknessInMeters;
}
