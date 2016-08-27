module whiteSphereEngine.physics.material.thermodynamics.WaterStateChangeForFluidSteam;

import whiteSphereEngine.misc.LookupInterpolator;

// TODO< move to helper >
double convertCelsiusToKelvin(double temperatureInCelsius) {
	return 273.0 /* TODO< search more exact constant > */ + temperatureInCelsius;
}

double convertKelvinToCelsius(double temperatureInKelvin) {
	assert(temperatureInKelvin >= 0.0);
	return temperatureInKelvin - 273.0 /* TODO< search more exact constant > */;
}

/**
 * used to calculate ho much enrgy can be pumped or retrived from water in
 * different states (fluid, steam) 
 * Can't and doesn't handle melting/icing because its jet another statechange
 */

// Specific enthalpy in kj/kg is how much energy per kilogram we have to put into the
// matter from the smelting temperature.
// see http://www.engineeringtoolbox.com/saturated-steam-properties-d_101.html for the calculation basics

class WaterStateChangeForFluidSteam {
	final void load() {
		lookupInterpolator = new LookupInterpolator();
		lookupInterpolator.parseTsvAndReadIntoLookupTableFromFile("resources/engine/physics/material/Saturated steam.tsv");
	}

	// tries to pump energy into the fluid and checks if evaporation is taking place
	// the delta temperature is just till evaporation is taking place
	final void calcDeltaTemperatureOfFluid(float absolutePressureInKpa, float startTemperatureInKelvin, float energyDeltaInJoule, out float deltaTemperature, out bool isEvaporating) {

		const float heatCapacity = calcHeatCapacity(absolutePressureInKpa);

		const float boilingTemperatureByAbsolutePressureInKelvin = lookupBoilingTemperatureByAbsolutePressureInKelvin(absolutePressureInKpa);

		deltaTemperature = calcHeatChange(heatCapacity, energyDeltaInJoule);

		assert(startTemperatureInKelvin <= boilingTemperatureByAbsolutePressureInKelvin, "a starttemperature above the boiling temperature of the liquid is invalid!");
		isEvaporating = deltaTemperature + startTemperatureInKelvin > boilingTemperatureByAbsolutePressureInKelvin;
		if( isEvaporating ) {
			// if it is evaporating we can just put in as much remaining temperature as its possible till it evaporates
			deltaTemperature = boilingTemperatureByAbsolutePressureInKelvin - startTemperatureInKelvin;
		}
	}

	// TODO< add steam mass and steam delta mass to calculate condensation too >
	// liquid --> steam transition
	final void calcEvaporationOfFluid(float absolutePressureInKpa, float energyDeltaInJoule, double remainingFluidMassInKg, out double deltaFluidMassInKg, out float energyRequiredForEvaporation, out bool isCompletlyEvaporated) {
		const float specificEnthalpyInJoules = lookupSpecificEnthalpyOfEvaporationByAbsolutePressureInJoules(absolutePressureInKpa);

		const double evaporatedFluidMassInKg = energyDeltaInJoule/specificEnthalpyInJoules;

		isCompletlyEvaporated = evaporatedFluidMassInKg > remainingFluidMassInKg;
		
		// set evaporated fluid mass
		deltaFluidMassInKg = isCompletlyEvaporated ? -remainingFluidMassInKg : -evaporatedFluidMassInKg;

		// calculate how much energy was required for evaporation
		if( isCompletlyEvaporated ) {
			// calculate the energy required to convert everything to steam
			energyRequiredForEvaporation = remainingFluidMassInKg*specificEnthalpyInJoules;
		}
		else {
			energyRequiredForEvaporation = energyDeltaInJoule;
		}
	}

	// TODO< heating steam >




	final float calcHeatCapacity(float absolutePressureInKpa) {
		float specificEnthalpyInJoules = lookupSpecificEnthalpyOfLiquidByAbsolutePressureInJoules(absolutePressureInKpa);

		// this works fine for water, the author made this up because its consistent with the heat apacity of water at atmospheric pressure
		float heatCapacityInKiloKelvin = specificEnthalpyInJoules / convertKelvinToCelsius(lookupBoilingTemperatureByAbsolutePressureInKelvin(absolutePressureInKpa));
		return heatCapacityInKiloKelvin;
	}

	private static float calcHeatChange(float heatCapacity, float energyDeltaInJoule) {
		// after definition of heat cpacity
		return energyDeltaInJoule / heatCapacity;
	}
	
	private final float lookupBoilingTemperatureByAbsolutePressureInKelvin(float absolutePressureInKpa) {
		return convertCelsiusToKelvin(lookupInterpolator.lookupAndInterpolate(absolutePressureInKpa, 0, 1));
	}

	private final float lookupSpecificEnthalpyOfLiquidByAbsolutePressureInJoules(float absolutePressureInKpa) {
		float enthalpyInKiloJoules = lookupInterpolator.lookupAndInterpolate(absolutePressureInKpa, 0, 4);
		return enthalpyInKiloJoules * 1000.0f;
	}

	private final float lookupSpecificEnthalpyOfEvaporationByAbsolutePressureInJoules(float absolutePressureInKpa) {
		float enthalpyInKiloJoules = lookupInterpolator.lookupAndInterpolate(absolutePressureInKpa, 0, 5);
		return enthalpyInKiloJoules * 1000.0f;
	}

	private final float lookupSpecificEnthalpyOfSteamByAbsolutePressureInJoules(float absolutePressureInKpa) {
		float enthalpyInKiloJoules = lookupInterpolator.lookupAndInterpolate(absolutePressureInKpa, 0, 6);
		return enthalpyInKiloJoules * 1000.0f;
	}

	private LookupInterpolator lookupInterpolator;
}