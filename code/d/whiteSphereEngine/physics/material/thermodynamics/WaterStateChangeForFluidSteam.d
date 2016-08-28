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

// doesn't handle heating of steam or freezing and cooling of ice!
class WaterStateChangeForFluidSteam {
	final void load() {
		lookupInterpolator = new LookupInterpolator();
		lookupInterpolator.parseTsvAndReadIntoLookupTableFromFile("resources/engine/physics/material/Saturated steam.tsv", 8, 1);
	}

	// tries to pump energy into the fluid or takes it away and checks if evaporation or freezing is taking place
	// the delta temperature is just till evaporation is taking place
	// startTemperatureInKelvin must be equal or above freezingTemperatureInKelvin
	final void calcDeltaTemperatureOfFluid(float absolutePressureInKpa, float startTemperatureInKelvin, float energyDeltaInJoule, float freezingTemperatureInKelvin, out float deltaTemperature, out EnumStateChange stateChange)
	in {
		assert(absolutePressureInKpa >= 0.0f);
		assert(startTemperatureInKelvin >= freezingTemperatureInKelvin);
	}
	body {
		stateChange = EnumStateChange.NONSPECIAL;

		const float heatCapacity = calcHeatCapacity(absolutePressureInKpa);

		const float boilingTemperatureByAbsolutePressureInKelvin = lookupBoilingTemperatureByAbsolutePressureInKelvin(absolutePressureInKpa);
		assert(startTemperatureInKelvin <= boilingTemperatureByAbsolutePressureInKelvin, "a starttemperature above the boiling temperature of the liquid is invalid!");

		deltaTemperature = calcHeatChange(heatCapacity, energyDeltaInJoule);

		const bool isEvaporating = deltaTemperature + startTemperatureInKelvin > boilingTemperatureByAbsolutePressureInKelvin;
		const bool isFreezing = deltaTemperature + startTemperatureInKelvin < freezingTemperatureInKelvin;
		if( isEvaporating ) {
			stateChange = EnumStateChange.EVAPORATING;
		}
		else if( isFreezing ) {
			stateChange = EnumStateChange.FREEZING;
		}

		if( isEvaporating ) {
			// if it is evaporating we can just put in as much remaining temperature as its possible till it evaporates
			deltaTemperature = boilingTemperatureByAbsolutePressureInKelvin - startTemperatureInKelvin;
		}
		else if( isFreezing ) {
			deltaTemperature = startTemperatureInKelvin - freezingTemperatureInKelvin;
		}
	}

	enum EnumStateChange {
		NONSPECIAL,
		COMPLETLYEVAPORATED,
		COMPLETLYCONDENSATED,
		EVAPORATING,
		FREEZING,
	}

	
	static struct CalcEvaporationOfFluidParameters {
		float absolutePressureInKpa;
		float energyDeltaInJoule;
		double remainingFluidMassInKg;
		double remainingSteamMassInKg;
	}

	// liquid <-> steam transition
	// \param deltaEnergyInJoules is either the used energy for the evaporation or the retrived energy for the condensation
	final void calcEvaporationOfFluid(
		CalcEvaporationOfFluidParameters parameters,
		out double deltaFluidMassInKg,
		out double deltaSteamMassInKg,
		out float deltaEnergyInJoules,
		out EnumStateChange evaporationCondensationState
	) {
		enum EnumEvaporationType {
			EVAPORATION,
			CONDENSATION,
		}

		with( EnumStateChange ) {
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

	private final float lookupSpecificEnthalpyOfEnumByAbsolutePressureInJoules(float absolutePressureInKpa, EnumEnthalpyColumn enthalpyColumn) {
		float enthalpyInKiloJoules = lookupInterpolator.lookupAndInterpolate(absolutePressureInKpa, 0, cast(uint)enthalpyColumn);
		return enthalpyInKiloJoules * 1000.0f;
	}

	private LookupInterpolator lookupInterpolator;
}