module physics.spatial.HashSpatialNestedGrid;

import std.typecons : Typedef;

import common.Hashtable;
import math.NumericSpatialVectors;

/*
 * implementation of a nested grid for acceleration of objectqueries (nearest objects, ray traversal, )
 * It is baked by a hashmap to not waste too much memory and improve the lookup time
 *
 * nesting grid sizes are for simplicity base 2, a grid could nest a 4x finer grid or more finer grids
 */
// TODO< custom non-GC memory manager for less GC pressure and more speed >
// TODO< grid traversal >
// TODO< query for next objects inside an radius, see the computergrafik presentation from "TU dresden" >

private struct IntegerCoordinateType {
	public int x, y, z;
}
private alias Typedef!(IntegerCoordinateType, IntegerCoordinateType.init, "global") IntegerCoordinateGlobalType;
private alias Typedef!(IntegerCoordinateType, IntegerCoordinateType.init, "local") IntegerCoordinateLocalType;

private IntegerCoordinateLocalType makeLocalCoordinate(int x, int y, int z) {
	IntegerCoordinateLocalType result;
	result.x = x;
	result.y = y;
	result.z = z;
	return result;
}

private IntegerCoordinateGlobalType makeGlobalCoordinate(int x, int y, int z) {
	IntegerCoordinateGlobalType result;
	result.x = x;
	result.y = y;
	result.z = z;
	return result;
}

private Type makeGenericCoordinate(Type : IntegerCoordinateLocalType)(int x, int y, int z) {
	return makeLocalCoordinate(x, y, z);
}

private Type makeGenericCoordinate(Type : IntegerCoordinateGlobalType)(int x, int y, int z) {
	return makeGlobalCoordinate(x, y, z);
}


private IntegerCoordinateLocalType scaleLocal(IntegerCoordinateLocalType argument, int scale) {
	return makeLocalCoordinate(argument.x * scale, argument.y * scale, argument.z * scale);
}

private IntegerCoordinateGlobalType scaleGlobal(IntegerCoordinateGlobalType argument, int scale) {
	return makeGlobalCoordinate(argument.x * scale, argument.y * scale, argument.z * scale);
}


private IntegerCoordinateLocalType convertToLocal(IntegerCoordinateGlobalType argument) {
	IntegerCoordinateLocalType result;
	result.x = argument.x;
	result.y = argument.y;
	result.z = argument.z;
	return result;
}

private IntegerCoordinateGlobalType convertToGlobal(IntegerCoordinateLocalType argument) {
	IntegerCoordinateGlobalType result;
	result.x = argument.x;
	result.y = argument.y;
	result.z = argument.z;
	return result;
}



import std.algorithm : min, max;

struct CoordinateRange(Type) {
	public Type minInclusive, maxInclusive;
	
	public static CoordinateRange!Type createFromSingleCoordinate(Type coordinate) {
		CoordinateRange!Type result;
		result.minInclusive = coordinate;
		result.maxInclusive = coordinate;
		return result;
	}
	
	// limits the input range to this range
	public final CoordinateRange!Type calcInclusiveRange(ref CoordinateRange!Type input) {
		CoordinateRange!Type result;
		result.minInclusive.x = max(minInclusive.x, input.minInclusive.x);
		result.minInclusive.y = max(minInclusive.y, input.minInclusive.y);
		result.minInclusive.z = max(minInclusive.z, input.minInclusive.z);
		result.maxInclusive.x = min(maxInclusive.x, input.maxInclusive.x);
		result.maxInclusive.y = min(maxInclusive.y, input.maxInclusive.y);
		result.maxInclusive.z = min(maxInclusive.z, input.maxInclusive.z);
		return result;
	}
	
	public final @property Type extend() {
		return makeGenericCoordinate!Type(maxInclusive.x - minInclusive.x, maxInclusive.y - minInclusive.y, maxInclusive.z - minInclusive.z);
	}

	
	public static CoordinateRange!Type make(Type minInclusive, Type maxInclusive) {
		CoordinateRange!Type result;
		result.minInclusive = minInclusive;
		result.maxInclusive = maxInclusive;
		return result;
	}
}

// helper
private IntegerCoordinateLocalType calcCorespondingLocalCoordinateOfGlobal(IntegerCoordinateGlobalType globalCoordinate, uint nestingDepth) {
	assert( globalCoordinate.x >= 0 && globalCoordinate.y >= 0 && globalCoordinate.z >= 0 );
	return makeLocalCoordinate(
		cast(uint)globalCoordinate.x >> nestingDepth,
		cast(uint)globalCoordinate.y >> nestingDepth,
		cast(uint)globalCoordinate.z >> nestingDepth
	);
}

private IntegerCoordinateGlobalType calcCorespondingGlobalCoordinateOfLocal(IntegerCoordinateLocalType localCoordinate, uint nestingDepth) {
	assert( localCoordinate.x >= 0 && localCoordinate.y >= 0 && localCoordinate.z >= 0 );
	return makeGlobalCoordinate(
		cast(uint)localCoordinate.x << nestingDepth, 
		cast(uint)localCoordinate.y << nestingDepth, 
		cast(uint)localCoordinate.z << nestingDepth
	);
}

unittest {
	IntegerCoordinateLocalType result = calcCorespondingLocalCoordinateOfGlobal(makeGlobalCoordinate(2,1,3), 1);
	assert( result.x == 1 && result.y == 0 && result.z == 1 );
}

import geometry.AxisOrientedBoundingBox;

class GridElement(ContentType, VectorType) {
	public static class ContentWithBoundingBox {
		public ContentType content;
		public AxisOrientedBoundingBox!VectorType boundingBox;
		
		public final this(ContentType content, AxisOrientedBoundingBox!VectorType boundingBox) {
			this.content = content;
			this.boundingBox = boundingBox;
		}
	}
	
	
	public final this(
		VectorType minExtend, VectorType maxExtend,
		CoordinateRange!IntegerCoordinateGlobalType globalCoordinateRange, IntegerCoordinateLocalType coordinate,
		uint nestingDepth, bool isNested
	) {
		assert( maxExtend.x > minExtend.x && maxExtend.y > minExtend.y && maxExtend.z > minExtend.z);
		
		this.minExtend = minExtend;
		this.maxExtend = maxExtend;
		this.protectedSize = maxExtend - minExtend;
		this.protectedGlobalCoordinateRange = globalCoordinateRange;
		this.coordinate = coordinate;
		this.nestingDepth = nestingDepth;
		this.isNested = isNested;
	}
	
	public ContentWithBoundingBox[] decoratedContent;
	
	public IntegerCoordinateLocalType coordinate;
	public bool isNested; // is this a nested grid itself?
	public uint nestingDepth;
	
	// extend is in global space, not local
	public VectorType minExtend, maxExtend;
	protected VectorType protectedSize;
	
	public final @property VectorType size() {
		return protectedSize;
	}
	
	public final @property CoordinateRange!IntegerCoordinateGlobalType globalCoordinateRange() {
		return protectedGlobalCoordinateRange;
	}
	
	// used by hashtable
	// for equality we just compare the local coordinates
	public final isEqual(GridElement!(ContentType, VectorType) other) {
		return coordinate == other.coordinate;
	}
	
	protected CoordinateRange!IntegerCoordinateGlobalType protectedGlobalCoordinateRange;
}

class NestedGrid(ContentType, VectorType) : GridElement!(ContentType, VectorType) {
	public alias GridElement!(ContentType, VectorType) GridElementType;
	public alias Hashtable!(GridElementType, HashSpatialNestedGrid!(ContentType, VectorType).HASHTABLEBUCKETS) HashTableType;
	
	
	public final this(
		VectorType minExtend, VectorType maxExtend,
		CoordinateRange!IntegerCoordinateGlobalType globalCoordinateRange,
		IntegerCoordinateLocalType localCoordinate,
		uint nestingDepth
	) {
		super(minExtend, maxExtend, globalCoordinateRange, localCoordinate, nestingDepth, true);
		hashtable = new HashTableType(&hashFunctionForHashtable);
	}
	
	// doesn't look for deeper grids, doesn't reallocate anything
	public final void addNonrecursive(ContentWithBoundingBox contentWithBoundingBox) {
		CoordinateRange!IntegerCoordinateGlobalType coordinateRangeToSweepToAdd = convertRealRangeToGlobalCoordinateRange(contentWithBoundingBox.boundingBox.min, contentWithBoundingBox.boundingBox.max);
		foreach( ix; coordinateRangeToSweepToAdd.minInclusive.x..coordinateRangeToSweepToAdd.maxInclusive.x+1 ) {
			foreach( iy; coordinateRangeToSweepToAdd.minInclusive.y..coordinateRangeToSweepToAdd.maxInclusive.y+1 ) {
				foreach( iz; coordinateRangeToSweepToAdd.minInclusive.z..coordinateRangeToSweepToAdd.maxInclusive.z+1 ) {
					addToGridElementAtCoordinate(contentWithBoundingBox, makeLocalCoordinate(ix, iy, iz));
				}
			}
		}
	}
	
	protected final void addToGridElementAtCoordinate(ContentWithBoundingBox contentWithBoundingBox, IntegerCoordinateLocalType localCoordinate) {
		GridElementType requestedGridElement = getElementByLocalCoordinate(localCoordinate);
		// can be null if it wasn't allocated
		if( requestedGridElement is null ) {
			createGridElementAndAddContentToIt(localCoordinate, contentWithBoundingBox);
		}
		else {
			requestedGridElement.decoratedContent ~= contentWithBoundingBox;
		}
	}
	
	protected final void createGridElementAndAddContentToIt(IntegerCoordinateLocalType localCoordinate, ContentWithBoundingBox contentWithBoundingBox) {
		GridElementType createdGridElement;
		
		// create new GridElement
		{
			CoordinateRange!IntegerCoordinateGlobalType globalCoordinateRange = 
				CoordinateRange!IntegerCoordinateGlobalType.make(
					calcCorespondingGlobalCoordinateOfLocal(localCoordinate, nestingDepth),
					calcCorespondingGlobalCoordinateOfLocal(localCoordinate, nestingDepth) // ASK< should the range be +1 for all dimensions? >
				);

			IntegerCoordinateGlobalType
				minCoordinate = globalCoordinateRange.minInclusive,
				maxCoordinate = makeGlobalCoordinate(minCoordinate.x + 1, minCoordinate.y + 1, minCoordinate.z + 1);
			
			VectorType
				minExtend = convertCoordinateToAbsoluteMinPosition(minCoordinate), 
				maxExtend = convertCoordinateToAbsoluteMinPosition(maxCoordinate);
				
			uint nestingDepth = this.nestingDepth;
			bool isNested = false;
		
			createdGridElement = new GridElementType(
				minExtend,
				maxExtend,
				
				globalCoordinateRange, coordinate,
				
				nestingDepth, isNested
			);
		}
		
		
		createdGridElement.decoratedContent ~= contentWithBoundingBox;
		hashtable.insert(createdGridElement);
	}
	
	// unittest for internal consistency between the internals of createGridElementAndAddContentToIt and the other methods
	// create dummy object of this class and fill it with the right values, then call the methods
	unittest {
		import std.math : abs;
		
		alias NestedGrid!(uint, SpatialVector!(3, double)) GridType;
		
		GridType grid = new GridType(
			new SpatialVector!(3, double)(0.0, 0.0, 0.0),// minExtend
			new SpatialVector!(3, double)(1.0, 1.0, 1.0),// maxExtend
			CoordinateRange!IntegerCoordinateGlobalType.make(makeGlobalCoordinate(0, 0, 0), makeGlobalCoordinate(0, 0, 0)),// globalCoordinateRange
			makeLocalCoordinate(0, 0, 0), // localCoordinate
			0 // nesting depth
		);
		
		
		IntegerCoordinateLocalType localCoordinate = makeLocalCoordinate(0, 0, 0);
		
		uint nestingDepth = 0;
		
		CoordinateRange!IntegerCoordinateGlobalType globalCoordinateRange = 
			CoordinateRange!IntegerCoordinateGlobalType.make(
				calcCorespondingGlobalCoordinateOfLocal(localCoordinate, nestingDepth),
				calcCorespondingGlobalCoordinateOfLocal(localCoordinate, nestingDepth) // ASK< should the range be +1 for all dimensions? >
			);

		IntegerCoordinateGlobalType
			minCoordinate = grid.globalCoordinateRange.minInclusive,
			maxCoordinate = makeGlobalCoordinate(minCoordinate.x + 1, minCoordinate.y + 1, minCoordinate.z + 1);
		
		VectorType
			minExtend = grid.convertCoordinateToAbsoluteMinPosition(minCoordinate), 
			maxExtend = grid.convertCoordinateToAbsoluteMinPosition(maxCoordinate);
		
		
		
		VectorType minExtendFromCoordinate = grid.convertCoordinateToAbsoluteMinPosition(minCoordinate);
		VectorType maxExtendFromCoordinate = grid.convertCoordinateToAbsoluteMinPosition(maxCoordinate);
		
		assert(abs((minExtend-minExtendFromCoordinate).magnitude()) < 0.001f);
		assert(abs((maxExtend-maxExtendFromCoordinate).magnitude()) < 0.001f);
	}
	

	
	public final ContentWithBoundingBox[] getContentByGlobalRangeRecursive(CoordinateRange!IntegerCoordinateGlobalType globalCoordinateRange) {
		CoordinateRange!IntegerCoordinateGlobalType limitedGlobalCoordinateRange = globalCoordinateRange.calcInclusiveRange(globalCoordinateRange);
		
		IntegerCoordinateLocalType localCoordinateRangeMinInclusive = calcCorespondingLocalCoordinateOfGlobal(limitedGlobalCoordinateRange.minInclusive, nestingDepth);
		IntegerCoordinateLocalType localCoordinateRangeMaxInclusive = calcCorespondingLocalCoordinateOfGlobal(limitedGlobalCoordinateRange.maxInclusive, nestingDepth);
		
		ContentWithBoundingBox[] notReducedContent;
		
		foreach( localIx; localCoordinateRangeMinInclusive.x..localCoordinateRangeMaxInclusive.x+1 ) {
			foreach( localIy; localCoordinateRangeMinInclusive.y..localCoordinateRangeMaxInclusive.y+1 ) {
				foreach( localIz; localCoordinateRangeMinInclusive.z..localCoordinateRangeMaxInclusive.z+1 ) {
					auto localCoordinate = makeLocalCoordinate(localIx, localIy, localIz);
					
					GridElementType currentIterationElement = getElementByLocalCoordinate(localCoordinate);
					// result of the method can be null because fields can be empty
					if( currentIterationElement is null ) {
						continue;
					}
					
					if( currentIterationElement.isNested ) {
						// recursively call into it
						NestedGrid!(ContentType, VectorType) nestedGrid = cast(NestedGrid!(ContentType, VectorType))currentIterationElement;
						
						IntegerCoordinateGlobalType globalCoordinate = calcCorespondingGlobalCoordinateOfLocal(localCoordinate, nestingDepth);
						notReducedContent ~= nestedGrid.getContentByGlobalRangeRecursive(CoordinateRange!IntegerCoordinateGlobalType.createFromSingleCoordinate(globalCoordinate));
					}
					else {
						notReducedContent ~= currentIterationElement.decoratedContent;
					}
				}
			}
		}
		
		return calcUnique(notReducedContent);
	}
	
	// returns null if it wasn't found
	// NOTE< could be public if it is needed >
	protected final GridElementType getElementByLocalCoordinate(IntegerCoordinateLocalType coordinate) {
		uint hashForCoordinate = hashFuntionByLocalCoordinate(coordinate);
		
		GridElementType[] potentialSolutions = hashtable.get(hashForCoordinate);
		foreach( iterationPotentialSolution; potentialSolutions ) {
			if( iterationPotentialSolution.coordinate == coordinate ) {
				return iterationPotentialSolution;
			}
		}
		
		return null;
	}
	
	protected final VectorType convertCoordinateToAbsoluteMinPosition(IntegerCoordinateGlobalType coordinate) {
		alias typeof(coordinate.x) VectorComponentType;
		
		auto absoluteDelta = new VectorType(
			// +1 depend if the upper range is inclusive or exclusive
			cast(VectorComponentType)coordinate.x * (cast(VectorComponentType)size.x / (cast(VectorComponentType)globalCoordinateRange.extend.x + 1)),
			cast(VectorComponentType)coordinate.y * (cast(VectorComponentType)size.y / (cast(VectorComponentType)globalCoordinateRange.extend.y + 1)),
			cast(VectorComponentType)coordinate.z * (cast(VectorComponentType)size.z / (cast(VectorComponentType)globalCoordinateRange.extend.z + 1)),
		);
		return minExtend + absoluteDelta;
	}
	
	public final CoordinateRange!IntegerCoordinateGlobalType convertRealRangeToGlobalCoordinateRange(VectorType min, VectorType max) {
		assert( min.x > minExtend.x && min.y > minExtend.y && min.z > minExtend.z );
		assert( min.x < maxExtend.x && min.y < maxExtend.y && min.z < maxExtend.z );
		
		assert( max.x < maxExtend.x && max.y < maxExtend.y && max.z < maxExtend.z );
		assert( max.x > minExtend.x && max.y > minExtend.y && max.z > minExtend.z );
		
		alias typeof(min.x) VectorComponentType;
		
		VectorType
			diffFromMinExtend = min - minExtend,
			diffFromMaxExtend = max - minExtend,
			relativeDiffAsVectorForMin = diffFromMinExtend.componentDivision(size),
			relativeDiffAsVectorForMax = diffFromMinExtend.componentDivision(size);
		
		// convert
		IntegerCoordinateGlobalType minCoordinate = makeGlobalCoordinate(
			cast(int)(relativeDiffAsVectorForMin.x * cast(VectorComponentType)globalCoordinateRange.extend.x),
			cast(int)(relativeDiffAsVectorForMin.y * cast(VectorComponentType)globalCoordinateRange.extend.y),
			cast(int)(relativeDiffAsVectorForMin.z * cast(VectorComponentType)globalCoordinateRange.extend.z)
		);
		
		IntegerCoordinateGlobalType maxCoordinate = makeGlobalCoordinate(
			cast(int)(relativeDiffAsVectorForMax.x * cast(VectorComponentType)globalCoordinateRange.extend.x),
			cast(int)(relativeDiffAsVectorForMax.y * cast(VectorComponentType)globalCoordinateRange.extend.y),
			cast(int)(relativeDiffAsVectorForMax.z * cast(VectorComponentType)globalCoordinateRange.extend.z)
		);

		return CoordinateRange!IntegerCoordinateGlobalType.make(minCoordinate, maxCoordinate);
	}
	
	protected static uint hashFuntionByLocalCoordinate(IntegerCoordinateLocalType coordinate) {
		return coordinate.x + coordinate.y * 23 + coordinate.z * 5;
	}
	
	protected static uint hashFunctionForHashtable(GridElement!(ContentType, VectorType) element) {
		return hashFuntionByLocalCoordinate(element.coordinate);
	}
	
	public alias uint function(IntegerCoordinateLocalType) HashFunctionType;
	
	protected HashTableType hashtable;
}

import std.algorithm.iteration : map, filter;
import std.array : array;

class HashSpatialNestedGrid(ContentType, VectorType) {
	public final this(
		VectorType minExtend,
		VectorType maxExtend,
		IntegerCoordinateGlobalType rootGridSize,
		uint rootNestingDepth
	) {
		auto rootGridGlobalCoordinateRange = CoordinateRange!IntegerCoordinateGlobalType.make(makeGlobalCoordinate(0,0,0), scaleGlobal(rootGridSize, 1 << rootNestingDepth));
		auto rootGridCoordinate = makeLocalCoordinate(0,0,0);
		rootGrid = new NestedGrid!(ContentType, VectorType)(
			minExtend, maxExtend, 
			rootGridGlobalCoordinateRange, rootGridCoordinate,
			
			rootNestingDepth
		);
	}
	
	public alias NestedGrid!(ContentType, VectorType).ContentWithBoundingBox ContentWithBoundingBoxType;
	
	// LATER TODO< we do have the oportunity to reallocate the nested grids to a given depth after some criteria >
	public final void resetContentAndAddAll(ContentWithBoundingBoxType[] contents) {
		// for now we do the simple algorithm
		
		foreach( iterationContentWithBoundingBox; contents ) {
			rootGrid.addNonrecursive(iterationContentWithBoundingBox);
		}
	}
	
	// \param checkBoundingBox if this is true only overlapping or content inside are included in the result
	//                         else everything from the correspoding grid is included
	public final ContentType[] getContentByRange(VectorType min, VectorType max, bool checkBoundingBox = true) {
		CoordinateRange!IntegerCoordinateGlobalType globalCoordinateRange = rootGrid.convertRealRangeToGlobalCoordinateRange(min, max);
		ContentWithBoundingBoxType[] gridQueryResult = rootGrid.getContentByGlobalRangeRecursive(globalCoordinateRange);
		
		ContentWithBoundingBoxType[] filteredGridQueryResult;
		
		if( checkBoundingBox ) {
			bool isContentWithBoundingBoxInsideBoundOrOverlaps(ContentWithBoundingBoxType contentWithBoundingBox) {
				bool doesOverlapOrIsInside = boundingBoxDoesOverlapInclusive(contentWithBoundingBox.boundingBox, new AxisOrientedBoundingBox!VectorType(min, max));
				return doesOverlapOrIsInside;
			}
			
			filteredGridQueryResult = array(filter!(isContentWithBoundingBoxInsideBoundOrOverlaps)(gridQueryResult));
		}
		else {
			filteredGridQueryResult = gridQueryResult;
		}
		
		return array(map!(element => element.content)(filteredGridQueryResult));
	}
		
	protected NestedGrid!(ContentType, VectorType) rootGrid;
	
	protected const uint HASHTABLEBUCKETS = 256;
	
	protected uint subdivisionFactor; // is powr of two for a simpler grid traversal calculation
}

// TODO< unittests >

// contains element
// checks for correct overlap tests
unittest {
	alias SpatialVector!(3, double) VectorType;
	alias HashSpatialNestedGrid!(uint, VectorType) SpatialGridType;
	
	VectorType minExtend = new VectorType(0.0, 0.0, 0.0);
	VectorType maxExtend = new VectorType(10.0, 20.0, 10.0);
	auto rootGridSize = makeGlobalCoordinate(1, 1, 1);
	SpatialGridType spatialGrid = new SpatialGridType(minExtend, maxExtend, rootGridSize, 0);
	
	SpatialGridType.ContentWithBoundingBoxType[] contentWithBbToAdd;
	contentWithBbToAdd ~= new SpatialGridType.ContentWithBoundingBoxType(5, new AxisOrientedBoundingBox!VectorType(new VectorType(5.0, 10.0, 5.0), new VectorType(9.5, 19.5, 9.5)));
	
	spatialGrid.resetContentAndAddAll(contentWithBbToAdd);
	
	// query
	uint[] contentByRange = spatialGrid.getContentByRange(new VectorType(0.01, 0.01, 0.01), new VectorType(4.5, 9.5, 4.5));
	assert(contentByRange.length == 0);
	
	contentByRange = spatialGrid.getContentByRange(new VectorType(0.01, 0.01, 0.01), new VectorType(4.5, 9.5, 4.5), false);
	assert(contentByRange.length == 1);
	assert(contentByRange[0] == 5);
	
	contentByRange = spatialGrid.getContentByRange(new VectorType(0.01, 0.01, 0.01), new VectorType(9.9, 19.9, 9.9));
	assert(contentByRange.length == 1);
	assert(contentByRange[0] == 5);
}

// contains right element, no hits for other positions  ( multiple cells in the grid )
unittest {
		alias SpatialVector!(3, double) VectorType;
	alias HashSpatialNestedGrid!(uint, VectorType) SpatialGridType;
	
	VectorType minExtend = new VectorType(0.0, 0.0, 0.0);
	VectorType maxExtend = new VectorType(10.0, 20.0, 10.0);
	auto rootGridSize = makeGlobalCoordinate(2, 2, 2);
	SpatialGridType spatialGrid = new SpatialGridType(minExtend, maxExtend, rootGridSize, 0);
	
	SpatialGridType.ContentWithBoundingBoxType[] contentWithBbToAdd;
	contentWithBbToAdd ~= new SpatialGridType.ContentWithBoundingBoxType(5, new AxisOrientedBoundingBox!VectorType(new VectorType(0.02, 0.02, 0.02), new VectorType(4.5, 9.5, 4.5)));
	
	spatialGrid.resetContentAndAddAll(contentWithBbToAdd);
	
	// query
	uint[] contentByRange = spatialGrid.getContentByRange(new VectorType(0.01, 0.01, 0.01), new VectorType(4.9, 9.9, 4.9));
	assert(contentByRange.length == 1);
	
	contentByRange = spatialGrid.getContentByRange(new VectorType(5.1, 11.0, 5.1), new VectorType(9.9, 19.9, 9.9));
	assert(contentByRange.length == 0);
}

// helper
private Type[] calcUnique(Type)(Type[] input) {
	Type[] result;
	
	foreach( iterationInput; input ) {
		bool alreadyContained = false;
		foreach( iterationResult; result ) {
			if( iterationResult is iterationInput ) {
				alreadyContained = true;
				break;
			}
		}
		
		if( !alreadyContained ) {
			result ~= iterationInput;
		}
	}
	
	return result;
}



