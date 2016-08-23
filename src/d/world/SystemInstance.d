module world.SystemInstance;

import common.HashIdCollection;

import physics.DynamicObject;
import physics.DynamicSimulator;

import world.World; // to import SystemObject

/**
 * A system instance is an active system in RAM
 * there can be many system instances at one point in time
 *
 *
 *
 */
class SystemInstance {
	HashIdCollection!SystemObject systemObjects = new HashIdCollection!SystemObject;
	
	DynamicEngine dynamicSimulator;
}

