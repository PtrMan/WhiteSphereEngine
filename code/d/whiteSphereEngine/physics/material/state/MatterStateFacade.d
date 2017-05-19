module whiteSphereEngine.physics.material.state.MatterStateFacade;

import whiteSphereEngine.physics.material.state.WaterStateFacade;
import whiteSphereEngine.physics.material.thermodynamics.WaterStateChangeForFluidSteam;
import whiteSphereEngine.material.state.MatterPhysicalState;

// abstracts away the specfic model of the matter for the state calculation(s)
class MatterStateFacade {
	static MatterStateFacade makeWater() {
		MatterStateFacade result = new MatterStateFacade(EnumMatterType.WATER);
		result.waterStateFacade = new WaterStateFacade;
		return result;
	}

	final protected this(EnumMatterType matterType) {
		this.matterType = matterType;
	}

	final void load() {
		final switch( matterType ) with (EnumMatterType) {
			case WATER: waterStateFacade.load(); return;
		}
	}

	final float calcDeltaTemperatureForIce(float temperatureInKelvin, float massInKg, float deltaEnergyInJoules) {
		final switch( matterType ) with (EnumMatterType) {
			case WATER: return waterStateFacade.calcDeltaTemperatureForIce(temperatureInKelvin, massInKg, deltaEnergyInJoules);
		}
	}

	final float calcDeltaTemperatureForSteam(float temperatureInKelvin, float massInKg, float deltaEnergyInJoules) {
		final switch( matterType ) with (EnumMatterType) {
			case WATER: return waterStateFacade.calcDeltaTemperatureForIce(temperatureInKelvin, massInKg, deltaEnergyInJoules);
		}
	}

	final void calcDeltaTemperatureOfFluid(float absolutePressureInKpa, float startTemperatureInKelvin, float energyDeltaInJoule, float freezingTemperatureInKelvin, out float deltaTemperature, out WaterStateChangeForFluidSteam.EnumStateChange stateChange) {
		final switch( matterType ) with (EnumMatterType) {
			case WATER: waterStateFacade.calcDeltaTemperatureOfFluid(absolutePressureInKpa, startTemperatureInKelvin, energyDeltaInJoule, freezingTemperatureInKelvin, deltaTemperature, stateChange); return;
		}
	}

	final void calcEvaporationOfFluid(
		WaterStateChangeForFluidSteam.CalcEvaporationOfFluidParameters parameters,
		out double deltaFluidMassInKg,
		out double deltaSteamMassInKg,
		out float deltaEnergyInJoules,
		out WaterStateChangeForFluidSteam.EnumStateChange evaporationCondensationState
	) {
		final switch( matterType ) with (EnumMatterType) {
			case WATER: waterStateFacade.calcEvaporationOfFluid(parameters, deltaFluidMassInKg, deltaSteamMassInKg, deltaEnergyInJoules, evaporationCondensationState); return
		}
	}

	final void calcHeatCapacity(float absolutePressureInKpa, double temperatureInKelvin, EnumMatterPhysicalState matterPhysicalState) {
		final switch( matterType ) with (EnumMatterType) {
			case WATER: return waterStateFacade.calcHeatCapacity(absolutePressureInKpa, temperatureInKelvin, matterPhysicalState);
		}
	}

	public enum EnumMatterType {
		WATER,
		// TODO< other type for more specific matter >
	}

	private EnumMatterType matterType;
	private WaterStateFacade waterStateFacade;
}

