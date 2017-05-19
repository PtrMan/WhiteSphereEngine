module whiteSphereEngine.physics.material.state.WaterStateFacade;

import whiteSphereEngine.physics.material.thermodynamics.WaterStateChangeForFluidSteam;
import whiteSphereEngine.physics.material.SpecificHeatLookup;
import whiteSphereEngine.material.state.MatterPhysicalState;

// is a abstraction over the different table lookups and thermodynamic calculations of heating the different states of water and the transitions between the states

class WaterStateFacade {
	final this() {
		heatLookupWaterSteam = new SpecificHeatLookup(2, 2, 0, 1);
		heatLookupWaterIce = new SpecificHeatLookup(2, 2, 0, 3);
		waterStateChangeForFluidSteam = new WaterStateChangeForFluidSteam;
	}

	final void load() {
		heatLookupWaterSteam.load("resources/engine/physics/material/Specific heat water vapor.tsv");
		heatLookupWaterIce.load("resources/engine/physics/material/Properties water ice.tsv");
		waterStateChangeForFluidSteam.load();
	}

	final float calcDeltaTemperatureForIce(float temperatureInKelvin, float massInKg, float deltaEnergyInJoules) {
		assert(temperatureInKelvin <= 273.0f + 0.001f /* epsilon */); // TODO< get constant >
		return heatLookupWaterIce.calcDeltaTemperatureForIce(temperatureInKelvin, massInKg, deltaEnergyInJoules);
	}

	final float calcDeltaTemperatureForSteam(float temperatureInKelvin, float massInKg, float deltaEnergyInJoules) {
		return heatLookupWaterSteam.calcDeltaTemperatureForIce(temperatureInKelvin, massInKg, deltaEnergyInJoules);
	}

	// all delegations to WaterStateChangeForFluidSteam

	final void calcDeltaTemperatureOfFluid(float absolutePressureInKpa, float startTemperatureInKelvin, float energyDeltaInJoule, float freezingTemperatureInKelvin, out float deltaTemperature, out WaterStateChangeForFluidSteam.EnumStateChange stateChange) {
		waterStateChangeForFluidSteam.calcDeltaTemperatureOfFluid(absolutePressureInKpa, startTemperatureInKelvin, energyDeltaInJoule, freezingTemperatureInKelvin, deltaTemperature, stateChange);
	}

	final void calcEvaporationOfFluid(
		WaterStateChangeForFluidSteam.CalcEvaporationOfFluidParameters parameters,
		out double deltaFluidMassInKg,
		out double deltaSteamMassInKg,
		out float deltaEnergyInJoules,
		out WaterStateChangeForFluidSteam.EnumStateChange evaporationCondensationState
	) {
		waterStateChangeForFluidSteam.calcEvaporationOfFluid(parameters, deltaFluidMassInKg, deltaSteamMassInKg, deltaEnergyInJoules, evaporationCondensationState);
	}

	final void calcHeatCapacity(float absolutePressureInKpa, double temperatureInKelvin, EnumMatterPhysicalState matterPhysicalState) {
		final switch(matterPhysicalState) with(EnumMatterPhysicalState) {
			case LIQUID: return waterStateChangeForFluidSteam.calcHeatCapacityOfLiquid(absolutePressureInKpa);
			case SOLID: return heatLookupWaterIce.lookupSpecificHeatInJoules(temperatureInKelvin);
			case GAS: return heatLookupWaterSteam.lookupSpecificHeatInJoules(temperatureInKelvin);
		}
	}

	private SpecificHeatLookup heatLookupWaterSteam, heatLookupWaterIce;
	private WaterStateChangeForFluidSteam waterStateChangeForFluidSteam;
}
