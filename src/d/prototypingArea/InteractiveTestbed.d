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
			
		
		
		
		string command = readln();
		
		if( command == "s" ) {
			
			
		}
	}
}
