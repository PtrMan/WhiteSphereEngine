import whiteSphereEngine.physics.material.thermodynamics.WaterStateChangeForFluidSteam;

import std.stdio;

void main() {
	WaterStateChangeForFluidSteam waterStateChangeForFluidSteam = new WaterStateChangeForFluidSteam;
	waterStateChangeForFluidSteam.load();

	float absolutePressureInKpa = 101.33f;

	float currentTemperatureInKelvin = 273.0f;

	float stepEnergyInJoules = 500.0;

	float energySumInJoules = 0.0f;

	double remainingFluidMassInKg = 1.0;

	for(;;) {
		// dump energy into it
		float deltaTemperature;
		bool isEvaporating;

		writeln("currentTemperatureInKelvin = ", currentTemperatureInKelvin);

		float remaingEnergyInJoules = stepEnergyInJoules;

		waterStateChangeForFluidSteam.calcDeltaTemperatureOfFluid(absolutePressureInKpa, currentTemperatureInKelvin, remaingEnergyInJoules, /*out*/deltaTemperature, /*out*/isEvaporating);
		
		const float heatCapacity = waterStateChangeForFluidSteam.calcHeatCapacity(absolutePressureInKpa);
		const float consumedEnergyForHeatingOfFluid = heatCapacity*deltaTemperature;
		remaingEnergyInJoules -= consumedEnergyForHeatingOfFluid;
		energySumInJoules += consumedEnergyForHeatingOfFluid;
		currentTemperatureInKelvin += deltaTemperature;

		writeln("delta temperature = ", deltaTemperature);
		writeln("is evaporating = ", isEvaporating);

		if( isEvaporating ) {
			// TODO< try to evaporate from remaining heat >
			double deltaFluidMassInKg;
			float energyRequiredForEvaporation;
			bool isCompletlyEvaporated;
			waterStateChangeForFluidSteam.calcEvaporationOfFluid(absolutePressureInKpa, remaingEnergyInJoules, remainingFluidMassInKg, /*out*/deltaFluidMassInKg, /*out*/energyRequiredForEvaporation, /*out*/isCompletlyEvaporated);

			remainingFluidMassInKg += deltaFluidMassInKg;
			remaingEnergyInJoules -= energyRequiredForEvaporation;
			energySumInJoules += energyRequiredForEvaporation;

			writeln("remainingFluidMassInKg ", remainingFluidMassInKg);

			if( isCompletlyEvaporated ) {
				writeln("energySumInJoules = ", energySumInJoules);

				break;
			}
		}

		writeln("energySumInJoules = ", energySumInJoules);
	}


}