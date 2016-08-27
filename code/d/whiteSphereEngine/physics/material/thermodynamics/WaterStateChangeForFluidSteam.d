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
		lookupInterpolator.parseTsvAndReadIntoLookupTableFromFile("resources/engine/physics/material/Saturated steam.tsv", 8, 1);
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

	enum EnumEvaporationCondensationState {
		NONSPECIAL,
		COMPLETLYEVAPORATED,
		COMPLETLYCONDENSATED,
	}

	// TODO< add steam mass and steam delta mass to calculate condensation too >
	// liquid --> steam transition

	static struct CalcEvaporationOfFluidParameters {
		float absolutePressureInKpa;
		float energyDeltaInJoule;
		double remainingFluidMassInKg;
		double remainingSteamMassInKg;
	}

	// \param deltaEnergyInJoules is either the used energy for the evaporation or the retrived energy for the condensation
	final void calcEvaporationOfFluid(
		CalcEvaporationOfFluidParameters parameters,
		out double deltaFluidMassInKg,
		out double deltaSteamMassInKg,
		out float deltaEnergyInJoules,
		out EnumEvaporationCondensationState evaporationCondensationState
	) {
		enum EnumEvaporationType {
			EVAPORATION,
			CONDENSATION,
		}

		with( EnumEvaporationCondensationState ) {
			with( parameters ) {
				evaporationCondensationState = NONSPECIAL;

				const float specificEnthalpyInJoules = lookupSpecificEnthalpyOfEnumByAbsolutePressureInJoules(absolutePressureInKpa, EnumEnthalpyColumn.EVAPORATION);
				const double evaporatedOrCondensatedFluidMassInKg = -energyDeltaInJoule/specificEnthalpyInJoules;

				const EnumEvaporationType evaporationType = energyDeltaInJoule > 0.0f ? EnumEvaporationType.EVAPORATION : EnumEvaporationType.CONDENSATION;
				
				if( evaporationType == EnumEvaporationType.EVAPORATION ) {
					if( -evaporatedOrCondensatedFluidMassInKg > remainingFluidMassInKg ) {
						evaporationCondensationState = COMPLETLYEVAPORATED;
					}

					const bool isCompletlyEvaporated = evaporationCondensationState == COMPLETLYEVAPORATED;

					// set evaporated fluid mass
					deltaFluidMassInKg = isCompletlyEvaporated ? remainingFluidMassInKg : evaporatedOrCondensatedFluidMassInKg;
					assert(deltaFluidMassInKg <= 0.0);

					// calculate how much energy was required for evaporation
					if( isCompletlyEvaporated ) {
						// calculate the energy required to convert everything to steam
						deltaEnergyInJoules = remainingFluidMassInKg*specificEnthalpyInJoules;
					}
					else {
						deltaEnergyInJoules = energyDeltaInJoule;
					}
				}
				else { // EnumEvaporationType.evaporationType == CONDENSATION
					if( evaporatedOrCondensatedFluidMassInKg > remainingSteamMassInKg ) {
						evaporationCondensationState = COMPLETLYCONDENSATED;
					}

					const bool isCompletlyCondensated = evaporationCondensationState == COMPLETLYCONDENSATED;

					// set condensatedFluidMass
					deltaFluidMassInKg = isCompletlyCondensated ? remainingSteamMassInKg : evaporatedOrCondensatedFluidMassInKg;
					assert(deltaFluidMassInKg >= 0.0);

					// calculate how much energy was retrived from condensation
					if( isCompletlyCondensated ) {
						deltaEnergyInJoules = remainingSteamMassInKg*specificEnthalpyInJoules;
					}
					else {
						deltaEnergyInJoules = energyDeltaInJoule;
					}
				}

				deltaSteamMassInKg = -deltaFluidMassInKg;
			}
		}

	}

	// heating of steam is not handled here


	final float calcHeatCapacity(float absolutePressureInKpa) {
		float specificEnthalpyInJoules = lookupSpecificEnthalpyOfEnumByAbsolutePressureInJoules(absolutePressureInKpa, EnumEnthalpyColumn.LIQUID);

		// this works fine for water, the author made this up because its consistent with the heat apacity of water at atmospheric pressure
		float heatCapacityInKelvin = specificEnthalpyInJoules / convertKelvinToCelsius(lookupBoilingTemperatureByAbsolutePressureInKelvin(absolutePressureInKpa));
		return heatCapacityInKelvin;
	}

	private static float calcHeatChange(float heatCapacity, float energyDeltaInJoule) {
		// after definition of heat cpacity
		return energyDeltaInJoule / heatCapacity;
	}
	
	private final float lookupBoilingTemperatureByAbsolutePressureInKelvin(float absolutePressureInKpa) {
		return convertCelsiusToKelvin(lookupInterpolator.lookupAndInterpolate(absolutePressureInKpa, 0, 1));
	}

	enum EnumEnthalpyColumn {
		LIQUID = 4,
		EVAPORATION = 5,
		STEAM = 6,
	}
	/*
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
	}*/

	private final float lookupSpecificEnthalpyOfEnumByAbsolutePressureInJoules(float absolutePressureInKpa, EnumEnthalpyColumn enthalpyColumn) {
		float enthalpyInKiloJoules = lookupInterpolator.lookupAndInterpolate(absolutePressureInKpa, 0, cast(uint)enthalpyColumn);
		return enthalpyInKiloJoules * 1000.0f;
	}

	private LookupInterpolator lookupInterpolator;
}