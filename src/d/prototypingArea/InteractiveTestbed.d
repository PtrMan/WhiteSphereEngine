import math.NumericSpatialVectors;
import math.VectorAlias;

import world.World;

// ai
import world.WorldAi;
import ai.behaviorTree.Task : BehaviorTreeTask = Task;
import ai.behaviorTree.Sequence : BehaviorTreeSequence = Sequence;

import world.SystemInstance;
import celestial.CelestialObject;

import std.stdio : writeln, readln;

import std.format;
string toDescription(Vector3p vector) {
	return format("<%s,%s,%s>", vector.x, vector.y, vector.z);
}

import PrototypeQueueAndBurningSystem;

void main() {
	// TODO< create world with sun >
	SystemInstance system = new SystemInstance();
	
	SystemObject objectMainPlanet;
	
	ulong id = 0;
	{
		CelestialObject celestialObjectForMainplanet = new CelestialObject(CelestialObject.EnumCelestialObjectType.GENETICCELESTIALBODY);
		celestialObjectForMainplanet.orbitProperties.period = 24.0*3600.0*350.0; // 350 days
		celestialObjectForMainplanet.orbitProperties.eccentricity = 0.0;
		celestialObjectForMainplanet.orbitProperties.semiMajorAxis = 500.0 * 1000.0; // 500km, just for testing
		celestialObjectForMainplanet.orbitProperties.majorAxisDirection = new Vector3p(1.0, 0.0, 0.0);
		celestialObjectForMainplanet.orbitProperties.semimajorAxisDirection = new Vector3p(0.0, 1.0, 0.0);
		
		CelestialObjectWithPosition celestialObjectWithPositionForMainPlanet = new CelestialObjectWithPosition();
		celestialObjectWithPositionForMainPlanet.celestialObject = celestialObjectForMainplanet;
		objectMainPlanet = SystemObject.makeCelestialOnrails(celestialObjectWithPositionForMainPlanet, id);
	}
	
	system.systemObjects.addElement(objectMainPlanet);
	
	NpcRaceEntityContext homeworldAiContext = new NpcRaceEntityContext();
	
	
	BehaviorTreeTask homeworldAiTopTask;
	{ // fill BehaviorTree AI
		BehaviorTreeSequence mainSequence = new BehaviorTreeSequence();
		homeworldAiTopTask = mainSequence;
		
		NpcRaceCheckUpdateResearchTask researchTask = new NpcRaceCheckUpdateResearchTask();
		
		mainSequence.children ~= researchTask;
	}
	
	
	
	
	
	// setup processing fabric (at homeplanet)
	BurnNodeState burnerNodeState = new BurnNodeState;
	RoutingNode!RoutingMaterialOrEnergyPayload routingNodeBurner = new RoutingNode!RoutingMaterialOrEnergyPayload;
	
	// and put some material into it directly
	RoutingInfoWithPayload!RoutingMaterialOrEnergyPayload *payloadForCoal = new RoutingInfoWithPayload!RoutingMaterialOrEnergyPayload;
	ObjectMadeOfMaterialInShape coalObject = new ObjectMadeOfMaterialInShape();
	coalObject.tags = [ObjectMadeOfMaterialInShape.EnumTag.BURNABLEASCOAL];
	coalObject.overwriteMass = 5.0;
	payloadForCoal.payload = RoutingMaterialOrEnergyPayload.makeObjectMadeOfMaterialInShape(coalObject);
	
	routingNodeBurner.queueIn ~= payloadForCoal;
	
	
	RoutingInfoWithPayload!RoutingMaterialOrEnergyPayload *payloadForOxygen = new RoutingInfoWithPayload!RoutingMaterialOrEnergyPayload;
	ObjectMadeOfMaterialInShape oxygenObject = new ObjectMadeOfMaterialInShape();
	oxygenObject.tags = [ObjectMadeOfMaterialInShape.EnumTag.OXYGEN];
	oxygenObject.overwriteMass = 5.0;
	payloadForOxygen.payload = RoutingMaterialOrEnergyPayload.makeObjectMadeOfMaterialInShape(oxygenObject);
	
	routingNodeBurner.queueIn ~= payloadForOxygen;
	
	
	
	
	
	
	
	
	// TODO< set to negative large value with enough precision
	double time = 24.0;
	
	
	
	Vector3p positionOfPlanet = objectMainPlanet.celestialOnRails.position(time);
	
	writeln(positionOfPlanet.toDescription);
	
	// TODO< do something with the AI, let it research >
	
	for(;;) {
		time += 60.0;
		writeln("time is now ", time);
		
		{ // do ai tick
			uint errorDepth;
			string errorMessage;
		
			BehaviorTreeTask.EnumReturn behaviorTreeResult = homeworldAiTopTask.run(homeworldAiContext, errorMessage, errorDepth);
		}
		
		// do Queue system tick
		{
			routingNodeBurner.step();
			
			
			float[string] specificEnergies = ["coal":33e6f, "tnt":4.6e6f];
			burnerProcess(routingNodeBurner, burnerNodeState, specificEnergies);
		}
		
		
		
		string command = readln();
		
		if( command == "s" ) {
			
			
		}
	}
}
