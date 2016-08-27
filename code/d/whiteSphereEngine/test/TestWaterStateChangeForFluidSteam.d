import whiteSphereEngine.physics.material.thermodynamics.WaterStateChangeForFluidSteam;
import whiteSphereEngine.physics.material.SpecificHeatLookup;

import std.stdio;

void main() {
	float absolutePressureInKpa = 101.33f;

	WaterStateChangeForFluidSteam waterStateChangeForFluidSteam = new WaterStateChangeForFluidSteam;
	waterStateChangeForFluidSteam.load();

	SpecificHeatLookup specificHeatLookupForWaterSteam = new SpecificHeatLookup;
	specificHeatLookupForWaterSteam.load("resources/engine/physics/material/Specific heat water vapor.tsv");



	if(false) {


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
				double deltaFluidMassInKg, deltaSteamMassInKg;
				float deltaEnergyInJoules;
				
				WaterStateChangeForFluidSteam.CalcEvaporationOfFluidParameters parameters;
				parameters.absolutePressureInKpa = absolutePressureInKpa;
				parameters.energyDeltaInJoule = remaingEnergyInJoules;
				parameters.remainingFluidMassInKg = remainingFluidMassInKg;
				parameters.remainingSteamMassInKg = 0.0; // not checked here

				WaterStateChangeForFluidSteam.EnumEvaporationCondensationState evaporationCondensationState;

				waterStateChangeForFluidSteam.calcEvaporationOfFluid(
					parameters,
					/*out*/deltaFluidMassInKg, 
					/*out*/deltaSteamMassInKg,
					/*out*/deltaEnergyInJoules,
					/*out*/evaporationCondensationState
				);

				bool isCompletlyEvaporated = evaporationCondensationState == WaterStateChangeForFluidSteam.EnumEvaporationCondensationState.COMPLETLYEVAPORATED;


				remainingFluidMassInKg += deltaFluidMassInKg;
				remaingEnergyInJoules -= deltaEnergyInJoules;
				energySumInJoules += deltaEnergyInJoules;

				writeln("remainingFluidMassInKg ", remainingFluidMassInKg);

				if( isCompletlyEvaporated ) {
					writeln("completly evaporated!");
					return;

					writeln("energySumInJoules = ", energySumInJoules);

					// todo< heat steam for testing >
					// in the real usage we calculate with material masses in specific states

					for(;;) {
						writeln("heating steam");

						double steamMassInKg = 1.0;
						deltaTemperature = specificHeatLookupForWaterSteam.calcDeltaTemperature(currentTemperatureInKelvin, steamMassInKg, stepEnergyInJoules);
						currentTemperatureInKelvin += deltaTemperature;

						writeln("currentTemperatureInKelvin = ", currentTemperatureInKelvin);
					}

					break;
				}
			}

			writeln("energySumInJoules = ", energySumInJoules);
		}

	}
	else {
		double deltaFluidMassInKg, deltaSteamMassInKg;
		float deltaEnergyInJoules;
			

		WaterStateChangeForFluidSteam.CalcEvaporationOfFluidParameters parameters;
		parameters.absolutePressureInKpa = absolutePressureInKpa;
		parameters.energyDeltaInJoule = -2257.0f;
		parameters.remainingFluidMassInKg = 0.0;
		parameters.remainingSteamMassInKg = 1.0;

		WaterStateChangeForFluidSteam.EnumEvaporationCondensationState evaporationCondensationState;

		waterStateChangeForFluidSteam.calcEvaporationOfFluid(
			parameters,
			/*out*/deltaFluidMassInKg, 
			/*out*/deltaSteamMassInKg,
			/*out*/deltaEnergyInJoules,
			/*out*/evaporationCondensationState
		);

		bool isCompletlyCondensated = evaporationCondensationState == WaterStateChangeForFluidSteam.EnumEvaporationCondensationState.COMPLETLYCONDENSATED;

		import std.stdio;
		writeln("deltaFluidMassInKg = ", deltaFluidMassInKg);
		writeln("deltaSteamMassInKg = ", deltaSteamMassInKg);
		writeln("deltaEnergyInJoules = ", deltaEnergyInJoules);

	}
}