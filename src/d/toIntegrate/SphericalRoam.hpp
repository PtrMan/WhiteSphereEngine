#pragma once

#include <cmath>

#include "TemplateHelper.hpp"

interface IHeightCalculationCallback(NumericType, VectorType) {
    NumericType calculateHeightForNormalizedDirection(VectorType direction);
}

// for now a classs because we want it to be GC'ed
class Point(NumericType, VectorType) {
    NumericType cachedHeight = 0.0;
    VectorType direction;

    public final this(VectorType direction_, NumericType cachedHeight_) {
        direction = direction_;
        cachedHeight = cachedHeight_;
    }

    public final this() /*: direction(VectorType(1.0, 0.0, 0.0))*/ {
    }

    public final VectorType calcPosition() {
        return direction*cachedHeight;
    }
}

/**
 *
 * invariants:
 * * edge [2] is always the longest
 * * point [1] is on the other side of edge [2]
 * * edge neighbor pointers are ordered counterclockwise  0-1, 1-2, and 2-0
 *
 *  0
 *   +
 *   | \
 *   |   \
 *   |     \   2
 *   |       \
 *  0|         \
 *   |           \
 *   |             \
 *   +--------------+
 * 1        1        2
 *
 */
// for now a classs because we want it to be GC'ed
class Triangle(NumericType, VectorType) {
    Triangle!(NumericType, VectorType)[3] edgeNeightbors;
    Triangle!(NumericType, VectorType) splitFromParent = null; // can be null if its the root

    Point!(NumericType, VectorType)[3] points;
    uint16_t coarseLevel = 0; // needs 16 bits
    float[3] cachedEdgeCenterVariance; // variance (difference between the height of the height function and the interpolated height of the points)
                                       // is cached for efficience, needs to be recalculated when the terrain (function) changes
                                       // is just a float because the values are small and so the precision is high

	// is the triangle on the top (and is of no oter triangle a parent)
	bool top = true;

	public final this() {
	}

    public final @property bool isDiamond() pure {
		return this.edgeNeightbors[2].edgeNeightbors[2] is this;
	}

	public final @property bool isPartOfDiamondAnticlockwise() pure {
        return this.edgeNeightbors[0].edgeNeightbors[0].edgeNeightbors[0].edgeNeightbors[0] is this;
	}

	public final @property bool isPartOfDiamondClockwise() pure {
        return this.edgeNeightbors[1].edgeNeightbors[1].edgeNeightbors[1].edgeNeightbors[1] is this;
	}

    public final NumericType getMaxCachedEdgeVariance() pure {
        return max(max(cachedEdgeCenterVariance[0], cachedEdgeCenterVariance[1]), cachedEdgeCenterVariance[2]);
    }
};



// temporary used
// class because it gets referenced
class TemporaryQuad {
    /**
	 *
	 * 0   3
	 *
	 * 1   2
	 */
    public final this(uint32_t pointIndices0, uint32_t pointIndices1, uint32_t pointIndices2, uint32_t pointIndices3, bool shift_) {
		pointIndices[0] = pointIndices0;
		pointIndices[1] = pointIndices1;
		pointIndices[2] = pointIndices2;
		pointIndices[3] = pointIndices3;
		shift = shift_;
	}


    uint32_t[4] pointIndices;
	bool shift;
};





struct SplitQueueElement(NumericType, VectorType) {
	Triangle!(NumericType, VectorType) triangle;

    public final float getPriority() {
        const NumericType scaleVariance = 1.0;
        const NumericType scaleCoarseLevel = 1.0;

        //UE_LOG(YourLog,Log,TEXT("SplitQueueElement<>::getPriority() max edge variance %f"), triangle.getMaxCachedEdgeVariance());


        return (float)(triangle.getMaxCachedEdgeVariance()*scaleVariance - scaleCoarseLevel*(triangle.coarseLevel));
	}
}

struct SplitQueueElementPredicate(NumericType, VectorType) {
	bool operator()(const SplitQueueElement<NumericType, VectorType> &a, const SplitQueueElement<NumericType, VectorType> &b) const {
		// Inverted compared to std::priority_queue - higher priorities float to the top
        return a.getPriority() < b.getPriority();
	}
}

// algorithm is described in http://www.gamasutra.com/view/feature/131451/a_realtime_procedural_universe_.php
// based on ROAM algorithm https://graphics.llnl.gov/ROAM/roam.pdf

// ideas:
// * defered heightmap calculation (requests get queued and get dispatched in batches, later the height is updated) >
//   should work fine with opencl / vulkan
class SphericalRoam(NumericType, VectorType) {
    alias Triangle!(NumericType, VectorType) TriangleType;
    alias Point!(NumericType, VectorType) PointType;

    private TriangleType[] triangles;
    private TriangleType[6*2] rootTriangles;
    private PointType[] points;

    private PointType[8] startPoints;


    public IHeightCalculationCallback!(NumericType, VectorType) heightCalculation;

	public virtual ~this() {
	}

    protected static NumericType getSigned(const NumericType &value, const bool sign) {
		return sign ? -value : value;
	}
	
    public /*virtual*/ void setupBaseMesh() {
        // 1.0/sqrt(1^2 + 1^2 + 1^2)
        const NumericType ONEDIVSQRT3 = 0.5773502691896257645091487805019574556476017512701268;

        assert(heightCalculation !is null);

        for( uint32_t vertexI = 0; vertexI < 8; vertexI++ ) {
			const bool xSignFlag = (vertexI & 1) != 0;
			const bool ySignFlag = (vertexI & 2) != 0;
			const bool zSignFlag = (vertexI & 4) != 0;

			const NumericType x = getSigned(ONEDIVSQRT3, xSignFlag);
            const NumericType y = getSigned(ONEDIVSQRT3, ySignFlag);
            const NumericType z = getSigned(ONEDIVSQRT3, zSignFlag);

			const VectorType direction = VectorType(x, y, z);
			const NumericType height = heightCalculation.calculateHeightForNormalizedDirection(direction);

            startPoints[vertexI] = new PointType(direction, height);
		}

        for( uint vertexI = 0; vertexI < 8; vertexI++ ) {
            points.AddHead(startPoints[vertexI]);
		}

		// create root triangles and link them
		
		// anti clockwise points of triangles

		TemporaryQuad[6] temporaryQuads;
		// side
		temporaryQuads[0] = TemporaryQuad(6, 7, 5, 4, false);
		temporaryQuads[1] = TemporaryQuad(4, 5, 1, 0, true);
		temporaryQuads[2] = TemporaryQuad(0, 1, 3, 2, false);
		temporaryQuads[3] = TemporaryQuad(2, 3, 7, 6, true);

		// top and bottom
		temporaryQuads[4] = TemporaryQuad(2, 6, 4, 0, true);
		temporaryQuads[5] = TemporaryQuad(7, 3, 1, 5, false);

		// build triangles from quads
        for (uint quadIndex = 0; quadIndex < 6; quadIndex++) {
			createAndAddTrianglesFromQuad(temporaryQuads[quadIndex]);
		}

        recalcVariancesOfAllTriangles();
		transferTrianglesToRootTriangles();
		transferTrianglesToSplitqueue();

		// figure out polygons on the other side of the edge
		// we do this with comparing the vertex pointers of the edges until we find a match
		// can be inefficient but it doesn't matter because we do it only once
		determineNeightborTrianglesOfRootTriangles();
	}

    public final TriangleType[] getTopTriangles() {
        TriangleType[] resultTriangles;

        foreach( iterationTriangle; triangles) {
            if( iterationTriangle.top ) {
                resultTriangles ~= iterationTriangle;
            }
        }

        return resultTriangles;
    }

    public final void heightmapFunctionChanged() {
        // TODO< call to method which recalculate all heights of all points >


        recalcVariancesOfAllTriangles();

        // TODO< reorder priority queue of the splitQueue because the variance changed >
    }

    public struct CheckForRequiredUpdatesParameters {
        uint limitMeshOperations = -1;
    };

    /**
     * checks if updates are required and if so it changes the mesh.
     *
     *
     */
    public final void checkForRequiredUpdates(CheckForRequiredUpdatesParameters parameters, out bool meshChanged) {
        meshChanged = false;

        uint meshOperationsCounter = 0;

        for(;;) {
            if( parameters.limitMeshOperations != -1 && meshOperationsCounter > parameters.limitMeshOperations ) {
                break;
            }

            assert(splitQueueSize() > 0);

            SplitQueueElement<NumericType, VectorType> splitQueueTopElement = splitQueueTop();

            // TODO< log >
            //UE_LOG(YourLog,Log,TEXT("SphericalRoam<>::::checkForRequiredUpdates() top priority %f"), splitQueueTopElement.getPriority());

            if( splitQueueTopElement.getPriority() > 0.0f ) {
                // call tryForceSplitRecursive()
                // NOTE< we don't remove the queue element because this is done by the method >
                tryForceSplitRecursive(splitQueueTopElement.triangle);

                meshChanged = true;
            }

            meshOperationsCounter++;
        }
    }

	protected final void determineNeightborTrianglesOfRootTriangles() {
        for (uint outerI = 0; outerI < size(rootTriangles); outerI++) {
            for (uint edgeI = 0; edgeI < 3; edgeI++) {
                const uint pointIndexA = getWrapAroundIndexPositive(edgeI, 0, 3);
                const uint pointIndexB = getWrapAroundIndexPositive(edgeI, 1, 3);

                PointType pointA = rootTriangles[outerI].points[pointIndexA];
                PointType pointB = rootTriangles[outerI].points[pointIndexB];

                TriangleType neightborTriangle = determineNeightborTriangleExceptRootTriangleIndex(pointA, pointB, outerI);

                const uint edgeNeightborIndex = edgeI;
				rootTriangles[outerI].edgeNeightbors[edgeNeightborIndex] = neightborTriangle;
			}
		}
	}

    protected final TriangleType determineNeightborTriangleExceptRootTriangleIndex(PointType pointA, PointType pointB, const size_t exceptRootTriangleIndex) {
        for (size_t outerI = 0; outerI < size(rootTriangles); outerI++) {
			if (outerI == exceptRootTriangleIndex) {
				continue;
			}

            for (size_t edgeI = 0; edgeI < 3; edgeI++) {
                const uint32 pointIndexA = getWrapAroundIndexPositive(edgeI, 0, 3);
                const uint32 pointIndexB = getWrapAroundIndexPositive(edgeI, 1, 3);

                PointType iterationPointA = rootTriangles[outerI].points[pointIndexA];
                PointType iterationPointB = rootTriangles[outerI].points[pointIndexB];

				if ( ((pointA == iterationPointA) && (pointB == iterationPointB)) || ((pointB == iterationPointA) && (pointA == iterationPointB))) {
					return rootTriangles[outerI];
				}
			}
		}

        // terminate critical if it reaches this point!
        assert(false, "SphericalRoam<>::determineNeightborTriangleExceptRootTriangleIndex() unreachable  reached!");
        return null;
	}

    protected static size_t getWrapAroundIndexPositive(size_t base, size_t offset, size_t length) {
		return (base + offset) % length;
	}

	protected final void createAndAddTrianglesFromQuad(TemporaryQuad quad) {
        TriangleType triangleA, triangleB;
		
        triangleA = new TriangleType();
		triangleA.top = true;
        triangleB = new TriangleType();
		triangleB.top = true;

		if (!quad.shift) {
            triangleA.points[0] = startPoints[quad.pointIndices[0]];
            triangleA.points[1] = startPoints[quad.pointIndices[1]];
            triangleA.points[2] = startPoints[quad.pointIndices[2]];

            triangleB.points[0] = startPoints[quad.pointIndices[2]];
            triangleB.points[1] = startPoints[quad.pointIndices[3]];
            triangleB.points[2] = startPoints[quad.pointIndices[0]];
		}
		else {
            triangleA.points[0] = startPoints[quad.pointIndices[1]];
            triangleA.points[1] = startPoints[quad.pointIndices[2]];
            triangleA.points[2] = startPoints[quad.pointIndices[3]];

            triangleB.points[0] = startPoints[quad.pointIndices[3]];
            triangleB.points[1] = startPoints[quad.pointIndices[0]];
            triangleB.points[2] = startPoints[quad.pointIndices[1]];
		}

		triangles.AddHead(triangleA);
		triangles.AddHead(triangleB);
	}

	private final void transferTrianglesToRootTriangles() {
        uint32 rootTrianglesI = 0;
		
        for(TriangleType *iterationTriangle : triangles) {
			rootTriangles[rootTrianglesI] = iterationTriangle;
			rootTrianglesI++;
		}
	}

	private final void transferTrianglesToSplitqueue() {
        for (TriangleType *iterationTriangle : triangles) {
            eventlikeCreatedTopTriangle(iterationTriangle);
		}
	}

    // splits the triangle recursive
    // as described in http://www.gamasutra.com/view/feature/131596/realtime_dynamic_level_of_detail_.php?page=2
    // doesn't use recursion because we have to keep track of the "callstack"
    protected final void tryForceSplitRecursive(TriangleType triangle) {
        TArray<TriangleType*> triangleStack;
        triangleStack.Push(triangle);

        for(;;) {
            if( triangleStack.Num() == 0 ) {
                break;
            }

            TriangleType topTriangle = triangleStack.Pop(false);

            if( topTriangle.isDiamond ) {
                UE_LOG(YourLog,Log,TEXT("SphericalRoam<>::::tryForceSplitRecursive() splitDiamond"));

                splitDiamond(topTriangle, topTriangle.edgeNeightbors[2]);
            }
            // TODO< check for template boolean and if its on the edge
            else if( false ) {

            }
            else {
                // no diamond and not on edge

                // force split the base neightbor

                triangleStack.Push(topTriangle.edgeNeightbors[2]);
            }
        }
    }

    protected final void splitDiamond(TriangleType leftBottom, TriangleType rightTop) {
        assert(leftBottom.coarseLevel == rightTop.coarseLevel);
        assert(leftBottom.isDiamond());
		
        assert(leftBottom.top);
        assert(rightTop.top);

		leftBottom.top = false;
		rightTop.top = false;


		
        const VectorType unnormalizedMidpointDirection = calcMiddle(leftBottom.points[0].direction, leftBottom.points[2].direction);
        const VectorType normalizedMidpointDirection = unnormalizedMidpointDirection.normalized();
		const NumericType heightOfMidpoint = heightCalculation.calculateHeightForNormalizedDirection(normalizedMidpointDirection);

        PointType midpoint = new PointType(normalizedMidpointDirection, heightOfMidpoint);
        points.AddHead(midpoint);

        TriangleType leftBottomChildEdge20 = new TriangleType();
		leftBottomChildEdge20.coarseLevel = leftBottom.coarseLevel + 1;
		triangles.AddHead(leftBottomChildEdge20);

        TriangleType *leftBottomChildEdge21 = new TriangleType();
		leftBottomChildEdge21.coarseLevel = leftBottom.coarseLevel + 1;
		triangles.AddHead(leftBottomChildEdge21);

        TriangleType *rightTopChildEdge20 = new TriangleType();
		rightTopChildEdge20.coarseLevel = leftBottom.coarseLevel + 1;
		triangles.AddHead(rightTopChildEdge20);

        TriangleType *rightTopChildEdge21 = new TriangleType();
		rightTopChildEdge21.coarseLevel = leftBottom.coarseLevel + 1;
		triangles.AddHead(rightTopChildEdge21);

		// link all pointers of the edges and vertices and others
		splitHelperLink(leftBottom, leftBottomChildEdge20, leftBottomChildEdge21, rightTop, rightTopChildEdge20, rightTopChildEdge21, midpoint);

        recalculateVarianceOfEdgesOfTriangle(leftBottomChildEdge20);
        recalculateVarianceOfEdgesOfTriangle(leftBottomChildEdge21);
        recalculateVarianceOfEdgesOfTriangle(rightTopChildEdge20);
        recalculateVarianceOfEdgesOfTriangle(rightTopChildEdge21);


        eventlikeRemovedTopTriangle(leftBottom);
        eventlikeRemovedTopTriangle(rightTop);

        eventlikeCreatedTopTriangle(leftBottomChildEdge20);
        eventlikeCreatedTopTriangle(leftBottomChildEdge21);
        eventlikeCreatedTopTriangle(rightTopChildEdge20);
        eventlikeCreatedTopTriangle(rightTopChildEdge21);
    }

	/**
	 * Edges/Vertices/split is like described in the article
	 *
	 *
	 *		+------------+
	 *		| \ rightTop |
	 *		|   \        |
	 *		|     \      |
	 *		|       \    |
	 *		|         \  |
	 *		| leftBottom\|
	 *		+------------+
	 */
    private static void splitHelperLink(TriangleType leftBottom, TriangleType leftBottomChildEdge20, TriangleType leftBottomChildEdge21, TriangleType rightTop, TriangleType rightTopChildEdge20, TriangleType rightTopChildEdge21, PointType midpoint) {
        verify(leftBottom.isDiamond());
        verify(rightTop.isDiamond());

		leftBottomChildEdge20.splitFromParent = leftBottom;
		leftBottomChildEdge20.points[0] = leftBottom.points[1];
		leftBottomChildEdge20.points[1] = midpoint;
		leftBottomChildEdge20.points[2] = leftBottom.points[0];
		leftBottomChildEdge20.edgeNeightbors[0] = leftBottomChildEdge21;
		leftBottomChildEdge20.edgeNeightbors[1] = rightTopChildEdge21;
		leftBottomChildEdge20.edgeNeightbors[2] = leftBottom.edgeNeightbors[0];

		leftBottomChildEdge21.splitFromParent = leftBottom;
		leftBottomChildEdge21.points[0] = leftBottom.points[2];
		leftBottomChildEdge21.points[1] = midpoint;
		leftBottomChildEdge21.points[2] = leftBottom.points[1];
		leftBottomChildEdge21.edgeNeightbors[0] = rightTopChildEdge20;
		leftBottomChildEdge21.edgeNeightbors[1] = leftBottomChildEdge20;
		leftBottomChildEdge21.edgeNeightbors[2] = leftBottom.edgeNeightbors[1];


		rightTopChildEdge20.splitFromParent = rightTop;
		rightTopChildEdge20.points[0] = rightTop.points[1];
		rightTopChildEdge20.points[1] = midpoint;
		rightTopChildEdge20.points[2] = rightTop.points[0];
		rightTopChildEdge20.edgeNeightbors[0] = rightTopChildEdge21;
		rightTopChildEdge20.edgeNeightbors[1] = leftBottomChildEdge21;
		rightTopChildEdge20.edgeNeightbors[2] = rightTop.edgeNeightbors[0];

		rightTopChildEdge21.splitFromParent = rightTop;
		rightTopChildEdge21.points[0] = rightTop.points[2];
		rightTopChildEdge21.points[1] = midpoint;
		rightTopChildEdge21.points[2] = rightTop.points[1];
		rightTopChildEdge21.edgeNeightbors[0] = leftBottomChildEdge20;
		rightTopChildEdge21.edgeNeightbors[1] = rightTopChildEdge20;
		rightTopChildEdge21.edgeNeightbors[2] = rightTop.edgeNeightbors[1];

		// check invariants
        verify(leftBottomChildEdge21.isPartOfDiamondAnticlockwise());
        verify(leftBottomChildEdge21.isPartOfDiamondClockwise())
	}

    protected final void recalcVariancesOfAllTriangles() {
        for( TriangleType *iterationTriangle : triangles ) {
            recalculateVarianceOfEdgesOfTriangle(iterationTriangle);
        }
    }

    protected final void recalculateVarianceOfEdgesOfTriangle(TriangleType triangle) /*const*/ {
        verify(heightCalculation != nullptr);

        const VectorType directionOfMiddleOfEdge0 = calcMiddle(triangle.points[1].direction, triangle.points[0].direction).normalized();
        const VectorType directionOfMiddleOfEdge1 = calcMiddle(triangle.points[1].direction, triangle.points[2].direction).normalized();
        const VectorType directionOfMiddleOfEdge2 = calcMiddle(triangle.points[0].direction, triangle.points[2].direction).normalized();

        const NumericType interpolatedHeightOfMiddleOfEdge0 = calcMiddle(triangle.points[1].direction*triangle.points[1].cachedHeight, triangle.points[0].direction*triangle.points[0].cachedHeight).norm();
        const NumericType interpolatedHeightOfMiddleOfEdge1 = calcMiddle(triangle.points[1].direction*triangle.points[1].cachedHeight, triangle.points[2].direction*triangle.points[2].cachedHeight).norm();
        const NumericType interpolatedHeightOfMiddleOfEdge2 = calcMiddle(triangle.points[0].direction*triangle.points[0].cachedHeight, triangle.points[2].direction*triangle.points[2].cachedHeight).norm();

        /*
        const NumericType interpolatedHeightOfMiddleOfEdge0 = (triangle.points[1].cachedHeight + triangle.points[0].cachedHeight) * 0.5;
        const NumericType interpolatedHeightOfMiddleOfEdge1 = (triangle.points[1].cachedHeight + triangle.points[2].cachedHeight) * 0.5;
        const NumericType interpolatedHeightOfMiddleOfEdge2 = (triangle.points[0].cachedHeight + triangle.points[2].cachedHeight) * 0.5;
        */

        const NumericType heightOfMiddleOfEdge0 = heightCalculation.calculateHeightForNormalizedDirection(directionOfMiddleOfEdge0);
        const NumericType heightOfMiddleOfEdge1 = heightCalculation.calculateHeightForNormalizedDirection(directionOfMiddleOfEdge1);
        const NumericType heightOfMiddleOfEdge2 = heightCalculation.calculateHeightForNormalizedDirection(directionOfMiddleOfEdge2);

        triangle.cachedEdgeCenterVariance[0] = abs(interpolatedHeightOfMiddleOfEdge0-heightOfMiddleOfEdge0);
        triangle.cachedEdgeCenterVariance[1] = abs(interpolatedHeightOfMiddleOfEdge1-heightOfMiddleOfEdge1);
        triangle.cachedEdgeCenterVariance[2] = abs(interpolatedHeightOfMiddleOfEdge2-heightOfMiddleOfEdge2);
    }

    protected static VectorType calcMiddle(const VectorType &a, const VectorType &b) {
        return (a+b) * 0.5;
    }

    protected final void eventlikeCreatedTopTriangle(TriangleType *triangle) {
        verify(triangle.top);

        SplitQueueElement<NumericType, VectorType> createdSplitQueueElement;
        createdSplitQueueElement.triangle = triangle;
        splitQueueAdd(createdSplitQueueElement);
    }

    protected final void eventlikeRemovedTopTriangle(TriangleType triangle) {
        for(size_t currentHeapIndex = 0; currentHeapIndex < splitQueue.Num(); currentHeapIndex++) {
            if( splitQueue[currentHeapIndex].triangle == triangle ) {
                splitQueue.HeapRemoveAt(currentHeapIndex, SplitQueueElementPredicate<NumericType, VectorType>());
                return;
            }
        }

        assert(false, "SphericalRoam<>::eventlikeRemovedTopTriangle() unreachable reached!");
    }

    // invariants: only top polygons are in the splitqueue
    //             we need to add remove elements (which point at the polygons) on the fly
    // unreal engine - priority queue see https://answers.unrealengine.com/questions/180188/analogue-of-priority-queue.html
	private: TArray<SplitQueueElement<NumericType, VectorType>> splitQueue;

	// queue helpers
	protected: void splitQueueAdd(const SplitQueueElement<NumericType, VectorType> &element) {
		splitQueue.HeapPush(element, SplitQueueElementPredicate<NumericType, VectorType>());
	}

	protected: SplitQueueElement<NumericType, VectorType> splitQueuePop() {
		SplitQueueElement<NumericType, VectorType> result;
		splitQueue.HeapPop(result);
		return result;
	}

	protected: unsigned int splitQueueSize() {
        return splitQueue.Num();
	}

	protected: SplitQueueElement<NumericType, VectorType> splitQueueTop() {
        return splitQueue.HeapTop();
	}
};
