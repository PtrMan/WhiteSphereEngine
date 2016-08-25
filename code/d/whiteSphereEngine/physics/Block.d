




import whiteSphereEngine.physics.material.Matter;

// each section has an materialcontent for the force affected/stationary and a remainder
// for example for a watertank with an airgap the stationary is the water and the remainder is the air
struct SectionMaterialContent {
	Matter stationary, remainder;
}

class Section {
	bool hasMaterial; // sections can be empty for various reasons, if so accessing materialContent is invalid
	SectionMaterialContent materialContent;

	enum EnumTopDownType {
		SQUARE,
		CIRCLE, // can be scaled by x and y
		// commented because first we want to experiment with simple shapes  TRIANGLE // can be rotated by 90 degrees
	}

	enum EnumSideType {
		SQUARE,
		// commented because first we want to experiment with simple shapes  PARALLELGRAM, // can be rotated by 0 degree
	}

	EnumTopDownType topDownType;
	EnumSideType sideType;

	// relative position is the position in the block in [0;1]
	final Matter getMatterByRelativePosition(Vector3f relativePosition)
	in {
		assert(hasMaterial, "section must have material to access the matter by relative position!");

		assert(relativePosition.x >= 0.0f && relativePosition.x <= 1.0f);
		assert(relativePosition.y >= 0.0f && relativePosition.y <= 1.0f);
		assert(relativePosition.z >= 0.0f && relativePosition.z <= 1.0f);
	}
	body {
		// TODO< figure out after acceleration (because liqnuids are at the bottom if accelerated in the right direction) the matter it hits >

		// for now we just return the stationary matter 
		return materialContent.stationary;
	}

	// TODO< scaling and position atribute for circle >

}

// a block is the basic "atomar" building block of the stations, space vehicles and so on
// a block is made out of sections, which are just compartments, the physical layout can vary.
// this allows a block to have holes and such where fluids and gases can flow.
class Block {
	Section[] sections;

/*
	alias size_t SectionIndex;

	protected SectionIndex[][SectionIndex] topology; // key is source section, data are the sections it is connected to, connections are build in both ways so the lookup and enumeration is fast

	protected final void topologyConnection(SectionIndex a, SectionIndex b) {
		final void addSourceDestination(SectionIndex source, SectionIndex destination) {
			if( source in topology ) {
				topology[source] ~= destination;
			}
			else {
				topology[source] = [destination];
			}
		}
		
		addSourceDestination(a, b);
		addSourceDestination(b, a);
	}*/

	VoxelContext voxelContext;
}

import math.NumericSpatialVectors;
import math.VectorAlias;
import physics.heat.heatEquation;

// has a own struct to save memory and make the attribute lookup more efficient
struct VoxelContext {
	// we divide the space of the block in small voxels, because this gives us the most freedom for the heat calculations
	Voxel[][][] voxels;

	size_t[3] size; // coresponding to the dimension

	double[3] cachedArea; // area for the surfaces between the voxels in the dimensions
	double[3] cachedThickness; // thickness of voxels in dimension

	final void resetVoxels(size_t[3] size) {
		this.size = size;

		voxels.length = 0; // set to zero to throw content away
		voxels.length = size[0];

		foreach( x; 0..size[0] ) {
			voxels[x].length = 0;
			voxels[x].length = size[1];

			foreach( y; 0..size[1] ) {
				voxels[x][y].length = 0;
				voxels[x][y].length = size[2];
			}
		}
	}

	final void resetTemperatureDelta() {
		foreach( xi; 0..size[0] ) {
			foreach( yi; 0..size[1] ) {
				foreach( zi; 0..size[2] ) {
					voxels[xi][yi][zi].resetTemperatureDelta();
				}
			}
		}
	}

	final void doHeatTransferStep(float deltaT) {
		foreach( xi; 0..size[0] ) {
			bool xim1Exist = xi != 0;
			bool xip1Exist = xi < size[0]-1;

			foreach( yi; 0..size[1] ) {
				bool yim1Exist = yi != 0;
				bool yip1Exist = yi < size[1]-1;

				foreach( zi; 0..size[2] ) {
					bool zim1Exist = zi != 0;
					bool zip1Exist = zi < size[2]-1;

					if( xim1Exist ) {
						doHeatTransferBetweenCoordinates(0, deltaT, xi, yi, zi, xi-1, yi, zi);
					}
					if( xip1Exist ) {
						doHeatTransferBetweenCoordinates(0, deltaT, xi, yi, zi, xi+1, yi, zi);
					}

					if( yim1Exist ) {
						doHeatTransferBetweenCoordinates(1, deltaT, xi, yi, zi, xi, yi-1, zi);
					}
					if( yip1Exist ) {
						doHeatTransferBetweenCoordinates(1, deltaT, xi, yi, zi, xi, yi+1, zi);
					}

					if( zim1Exist ) {
						doHeatTransferBetweenCoordinates(2, deltaT, xi, yi, zi, xi, yi, zi-1);
					}
					if( zip1Exist ) {
						doHeatTransferBetweenCoordinates(2, deltaT, xi, yi, zi, xi, yi, zi+1);
					}
				}
			}
		}
	}

	private final void doHeatTransferBetweenCoordinates(size_t dimension, float deltaT, size_t xa, size_t ya, size_t za, size_t xb, size_t yb, size_t zb) {
		if( voxels[xa][ya][za].isOutside || voxels[xb][yb][zb].isOutside ) {
			return;
		}

		// calculate heat transfer in time Q/t
		// ASK< we need the thickness in this formulation, maybe the formula is incorrect because it could work without the thickness >
		const double temperatureDifference = voxels[xa][ya][za].temperature - voxels[xb][yb][zb].temperature; // TODO< check if this is right >
		const float thermalConductivity = voxels[xa][ya][za].cachedThermalConductivity;
		const double heatTransferRate = calcHeatConduction(thermalConductivity, cachedArea[dimension], temperatureDifference, cachedThickness[dimension]);
		const double heatTransferRatebyTime = heatTransferRate * deltaT;

		// https://en.wikipedia.org/wiki/Heat_capacity
		voxels[xa][ya][za].temperatureDelta -= ((1.0/voxels[xa][ya][za].cachedSpecificHeatCapacity) * heatTransferRatebyTime);
		voxels[xb][yb][zb].temperatureDelta += ((1.0/voxels[xb][yb][zb].cachedSpecificHeatCapacity) * heatTransferRatebyTime);
	}
}

// test if the heat transfer works and if the heat direction is the right one
unittest {
	VoxelContext testcontent;

	testcontent.voxels.length = 2;
	testcontent.voxels[0].length = 1;
	testcontent.voxels[1].length = 1;
	testcontent.voxels[0][0].length = 1;
	testcontent.voxels[1][0].length = 1;


	testcontent.size = [2, 1, 1];

	testcontent.cachedArea = [1.0f, 1.0f, 1.0f];
	testcontent.cachedThickness = [1.0f, 1.0f, 1.0f];

	testcontent.voxels[0][0][0].temperature = 5.0;
	testcontent.voxels[0][0][0].temperatureDelta = 0.0;
	testcontent.voxels[0][0][0].isOutside = false;

	testcontent.voxels[0][0][0].cachedThermalConductivity = 1.0f;
	testcontent.voxels[0][0][0].cachedSpecificHeatCapacity = 1.0f;


	testcontent.voxels[1][0][0].temperature = 0.0;
	testcontent.voxels[1][0][0].temperatureDelta = 0.0;
	testcontent.voxels[1][0][0].isOutside = false;

	testcontent.voxels[1][0][0].cachedThermalConductivity = 1.0f;
	testcontent.voxels[1][0][0].cachedSpecificHeatCapacity = 1.0f;


	testcontent.doHeatTransferStep(0.1f);

	assert(testcontent.voxels[0][0][0].temperatureDelta < 0.0);
	assert(testcontent.voxels[1][0][0].temperatureDelta > 0.0);
}


private void voxelFill(VoxelContext voxelContext, Section section, bool delegate(Vector3f relativePosition) isInside) {
	foreach( xi; 0..voxelContext.size[0] ) {
		foreach( yi; 0..voxelContext.size[1] ) {
			foreach( zi; 0..voxelContext.size[2] ) {
				Vector3f relativePosition = new Vector3f(
					cast(float)xi / cast(float)voxelContext.size[0] + (1.0f / cast(float)voxelContext.size[0]) * 0.5f,
					cast(float)yi / cast(float)voxelContext.size[1] + (1.0f / cast(float)voxelContext.size[1]) * 0.5f,
					cast(float)zi / cast(float)voxelContext.size[2] + (1.0f / cast(float)voxelContext.size[2]) * 0.5f
				);

				Voxel *voxel = &voxelContext.voxels[xi][yi][zi];

				if( isInside(relativePosition) ) {
					voxel.isOutside = false;
					voxel.section = section;
					voxel.refreshCache(relativePosition); // TODO< move refleshing of cache into a method >
				}
			}
		}
	}
}

// function to "carve out" a cylinder
// section is the section which is being carved out
void addCylinder(VoxelContext voxelContext, Section section, size_t axis, Vector3f centerPosition, float radius){
	const float squaredRadius = radius*radius;

	bool isInside(Vector3f relativePosition) {
		relativePosition.data[axis] = 0.0f;
		const float squaredDistance = (relativePosition - centerPosition).magnitudeSquared;
		return squaredDistance < squaredRadius;
	}

	voxelFill(voxelContext, section, &isInside);
}

void addSphere(VoxelContext voxelContext, Section section, Vector3f centerPosition, float radius){
	const float squaredRadius = radius*radius;

	bool isInside(Vector3f relativePosition) {
		const float squaredDistance = (relativePosition - centerPosition).magnitudeSquared;
		return squaredDistance < squaredRadius;
	}

	voxelFill(voxelContext, section, &isInside);
}

// TODO< block >



struct Voxel {
	Section section; // section which the voxel belongs to

	double temperature;
	double temperatureDelta;

	final void resetTemperatureDelta() {
		temperatureDelta = 0.0;
	}

	final void refreshCache(Vector3f relativePosition) {
		if( !section.hasMaterial ) { // grabbing material properties from vacuum is nonsense
			cachedThermalConductivity = 0.0f;
			cachedSpecificHeatCapacity = 0.0f;
			return;
		}

		cachedThermalConductivity = section.getMatterByRelativePosition(relativePosition).thermalConductivity;
		cachedSpecificHeatCapacity = section.getMatterByRelativePosition(relativePosition).specificHeatcapacity;
	}

	bool isOutside = true;

	float cachedThermalConductivity; // has to be refreshed if the content of the block has changed
	float cachedSpecificHeatCapacity;
}
