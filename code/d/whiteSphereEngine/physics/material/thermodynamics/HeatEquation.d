module whiteSphereEngine.physics.material.thermodynamics.heatEquation;

// http://hyperphysics.phy-astr.gsu.edu/hbase/thermo/heatcond.html
Type calcHeatConduction(Type)(Type thermalConductivity, Type area, Type temperatureDifference, Type thickness) {
	return (thermalConductivity*area*temperatureDifference) / thickness;
}

