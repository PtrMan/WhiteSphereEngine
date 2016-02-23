module Octree;

import NumericSpatialVectors;
import Frustum;
import ProjectionContext;

class OctreeNode(NumericType, ContentType) {
	public SpatialVector!(3,NumericType) min, max;

	public FrustumSphere!NumericType sphere;
	public FrustumAabb!NumericType box;

	// if all childrens are null then this is a leaf
	public OctreeNode!(NumericType, ContentType)[2*2*2] childrens;

	public ContentType[] leafObjects;

	final public this(SpatialVector!(3,NumericType) min, SpatialVector!(3,NumericType) max) {
		this.min = min;
		this.max = max;
	}

	final public void makeMutable() {
		// nothing to do here
	}

	final public void makeImmutable() {
		recalcCachedVariables();
	}

	final @property bool isBranch() {
		return !isLeaf();
	}

	final @property bool isLeaf() {
        return cachedIsLeaf;
    }

    private final void recalcCachedVariables() {
    	cachedIsLeaf = true;

    	foreach( auto iterationChildren; childrens ) {
    		if( iterationChildren !is null ) {
    			cachedIsLeaf = false;
    			break;
    		}
    	}
    }

    protected bool cachedIsLeaf = false;
}

// TODO TODO< fill method which just looks at the Aabb's of the objects which should be placed into the leafObjects >

// builds an actree down to a deep
// used to build the (initial) Octree for a dynamic scene
class OctreeBuilder(NumericType, ContentType) {
	public static OctreeNode!(NumericType,ContentType) buildToDepth(uint depth, SpatialVector!(3,NumericType) min, SpatialVector!(3,NumericType) max) {
		if( depth == 1 ) {
			return new OctreeNode!(NumericType,ContentType)(min, max);
		}
		else {
			SpatialVector!(3,NumericType) middleOffset = (max - min).scale(cast(NumericType)0.5);

			/**
			 *                          max
             *                -24-  25   26
             *              -21-  22   23
             *            -18- -19- -20-
             *
			 *
			 *               -15-  16   17
			 *              12   13   14
			 *             9   10  -11-
			 *
			 *
			 *                 -6- -7- -8-
			 *               3   4  -5-
			 *             0   1  -2-
			 *           min
			 *         
			 *  y
			 *  |   z
			 *  |  / 
			 *  |/ 
			 *  +------> x
			 */


			SpatialVector!(3,NumericType)[3*3*3] gridPositions;

			uint currentGridPositionsIndex = 0;

			// TODO< check iteratorranges >
			foreach( uint zi; 0..2 ) {
				foreach( uint yi; 0..2 ) {
					foreach( uint xi; 0..2 ) {
						gridPositions[currentGridPositionsIndex] = min + new SpatialVector!(3,NumericType)(cast(NumericType)xi * middleOffset.x, cast(NumericType)yi * middleOffset.y, cast(NumericType)zi * middleOffset.z);

						currentGridPositionsIndex++;
					}
				}
			}
			
			OctreeNode!(NumericType,ContentType) lowY1 = buildToDepth(depth-1, gridPositions[0], gridPositions[13]);
			OctreeNode!(NumericType,ContentType) lowY2 = buildToDepth(depth-1, gridPositions[1], gridPositions[14]);
			OctreeNode!(NumericType,ContentType) lowY3 = buildToDepth(depth-1, gridPositions[3], gridPositions[16]);
			OctreeNode!(NumericType,ContentType) lowY4 = buildToDepth(depth-1, gridPositions[4], gridPositions[17]);
			
			OctreeNode!(NumericType,ContentType) highY1 = buildToDepth(depth-1, gridPositions[9], gridPositions[22]);
			OctreeNode!(NumericType,ContentType) highY2 = buildToDepth(depth-1, gridPositions[10], gridPositions[23]);
			OctreeNode!(NumericType,ContentType) highY3 = buildToDepth(depth-1, gridPositions[12], gridPositions[25]);
			OctreeNode!(NumericType,ContentType) highY4 = buildToDepth(depth-1, gridPositions[13], gridPositions[26]);
			
			OctreeNode!(NumericType,ContentType) result = new OctreeNode!(NumericType,ContentType)(min, max);
			result.children[0] = lowY1;
			result.children[1] = lowY2;
			result.children[2] = lowY3;
			result.children[3] = lowY4;

			result.children[4] = highY1;
			result.children[5] = highY2;
			result.children[6] = highY3;
			result.children[7] = highY4;

			return result;
		}
	}
}

class Octree(NumericType, ContentType) {
	// check if the node is visible by the frustum
	// testChildren indices that the children of the node should be tested too (for example if it is partially intersected)
	// inspired from http://www.flipcode.com/archives/Frustum_Culling.shtml
	public final static boolean isNodeInView(ProjectionContext!NumericType projectionContext, OctreeNode!(NumericType,ContentType) node, ref bool testChildren) {
		// do we need to check for clipping?
		if( testChildren ) {

			// check if we are inside this box first...
			if( !node.box.containsPoint(projectionContext.globalPosition) ) {
				// test the sphere first
				switch(projectionContext.frustum.calcContainsForSphere(node.sphere)) {
					case Frustum!Type.EnumFrustumIntersectionResult.OUTSIDE:
						return false;
					case Frustum!Type.EnumFrustumIntersectionResult.INSIDE:
						testChildren = false;
						break;
					case Frustum!Type.EnumFrustumIntersectionResult.INTERSECT:
						// check if the box is in view
						switch(projectionContext.frustum.calcContainsForAabb(node.box)) {
							case Frustum!Type.EnumFrustumIntersectionResult.OUTSIDE:
								return false;

							case Frustum!Type.EnumFrustumIntersectionResult.INSIDE:
								testChildren = false;
								break;
						}
						break;
				}
			}
		}
		
		return true;
	}
}
