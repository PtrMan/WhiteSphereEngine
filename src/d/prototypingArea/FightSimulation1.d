module prototypingArea.FightSimulation1;

import std.stdio;

// AI - fuzzy logic

import ai.fuzzy.FuzzyControl;

// builds a fuzzy control instance for deciding the priority of a target
FuzzyControl buildFuzzyControlForPriorityOfTarget() {
	import ai.fuzzy.FuzzyElement;
	import ai.fuzzy.FuzzySet;
	import ai.fuzzy.Area1d;
	import ai.fuzzy.Trapezoid;
	import ai.fuzzy.ValueMatrix2dRuleLookup;
	
	FuzzyControl fuzzyControl = new FuzzyControl();
	
	fuzzyControl.defuzzificationType = FuzzyControl.EnumDefuzzificationType.CENTEROFGRAVITY;
	fuzzyControl.globalCombinatorRule = FuzzyControl.EnumValueOperation.MAX;
		
	ValueMatrix2dRuleLookup ruleMatrix = new ValueMatrix2dRuleLookup(/*2*/3, 3);
	// low armor * firepower
	ruleMatrix.ruleMatrix[0, 0] = new FuzzyControl.RuleElement(0, FuzzyControl.EnumRuleType.AND);
	ruleMatrix.ruleMatrix[1, 0] = new FuzzyControl.RuleElement(0, FuzzyControl.EnumRuleType.AND);
	ruleMatrix.ruleMatrix[2, 0] = new FuzzyControl.RuleElement(0, FuzzyControl.EnumRuleType.AND);
	
	// low high armor * firepower
	ruleMatrix.ruleMatrix[0, 1] = new FuzzyControl.RuleElement(1, FuzzyControl.EnumRuleType.AND);
	ruleMatrix.ruleMatrix[1, 1] = new FuzzyControl.RuleElement(1, FuzzyControl.EnumRuleType.AND);
	ruleMatrix.ruleMatrix[2, 1] = new FuzzyControl.RuleElement(0, FuzzyControl.EnumRuleType.AND);
	
	// high armor * firepower
	ruleMatrix.ruleMatrix[0, 2] = new FuzzyControl.RuleElement(2, FuzzyControl.EnumRuleType.AND);
	ruleMatrix.ruleMatrix[1, 2] = new FuzzyControl.RuleElement(1, FuzzyControl.EnumRuleType.AND);
	ruleMatrix.ruleMatrix[2, 2] = new FuzzyControl.RuleElement(0, FuzzyControl.EnumRuleType.AND);
	
	fuzzyControl.ruleLookup = ruleMatrix;
	
	// distance
	fuzzyControl.inputFuzzySets ~= new FuzzySet([
		new FuzzyElement(new Trapezoid(-0.125f,   0.0f, 1.0f,   6.0f, 1.0f,   7.0f)), // near 20km
		new FuzzyElement(new Trapezoid(6.0f,   7.0f, 1.0f,   8.0f, 1.0f,   9.0f)), // middle 100km
		new FuzzyElement(new Trapezoid(8.0f,   9.0f, 1.0f,  10.0f, 1.0f,  11.0f))  // extremly large
		]);
	
	// armor * relative firepower
	fuzzyControl.inputFuzzySets ~= new FuzzySet([
		new FuzzyElement(new Trapezoid(-0.125f,   0.0f, 1.0f,   0.2f, 1.0f,   0.3f)),
		new FuzzyElement(new Trapezoid(0.2f,   0.3f, 1.0f,   0.4f, 1.0f,   0.5f)),		
		new FuzzyElement(new Trapezoid(0.4f,   0.5f, 1.0f,   1.0f, 1.0f,   1.125f))		
		]);
	
	fuzzyControl.outputAreas ~= new Area1d([new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 1.0f), new PointDescriptor(2.0f, 0.0f)]); // extremly low priority
	fuzzyControl.outputAreas ~= new Area1d([new PointDescriptor(1.0f, 0.0f), new PointDescriptor(2.0f, 1.0f), new PointDescriptor(3.0f, 0.0f)]);
	fuzzyControl.outputAreas ~= new Area1d([new PointDescriptor(2.0f, 0.0f), new PointDescriptor(3.0f, 1.0f), new PointDescriptor(5.0f, 1.0f), new PointDescriptor(6.0f, 0.0f)]);
	
	// result value of fuzzy controller is the unnormalized attack priority
	
	return fuzzyControl;
}




import math.NumericSpatialVectors : SpatialVector;
import geometry.Pluecker : PlueckerCheckCcw = checkCcw, PlueckerCoordinate = Coordinate;
import geometry.RayPlane;

import geometry.MeshGenerator : MeshGenerator;
import geometry.Mesh : Mesh, MeshEdge, MeshEdgeStruct, MeshFace, MeshVertex;
import geometry.MeshConverter : convertMesh = convert;


import std.algorithm.searching : all;

class PlueckerFace(NumericType) {
	public PlueckerCoordinate!NumericType[] edgePueckerCoordinates;
	
	public final bool intersectRay(PlueckerCoordinate!NumericType ray) {
		foreach( iterationEdgePlueckerCoordinate; edgePueckerCoordinates ) {
			if( !PlueckerCheckCcw!NumericType(ray, iterationEdgePlueckerCoordinate)) {
				return false;
			}
		}
		
		return true;
	}
}

import helpers.ranges.IterationPair : forwardPair, backwardPair;

struct DamageDescriptor {
	public double heatDamageInJoules;
	public double radiationDamage;
}

alias Mesh!(double, MeshAndCollisionFace!double) MeshType;

// class for the faces of the mesh
// contains the default meshFace, the pluecker Face for the fast intersection test and the plane of the face for the calculation of the intersection position with a ray
// and things for damage calculations
class MeshAndCollisionFace(NumericType) {
	public final this(int[] vertexIndices) {
		meshFace = new MeshFace!NumericType(vertexIndices);
	}
	
	public MeshFace!NumericType meshFace;
	
	// face for the pluecker calculations
	public PlueckerFace!NumericType plueckerFace;
	
	public Plane!NumericType planeOfFace;
	
	
	
	enum EnumInterpolationForDamage {
		UNIFORM, // no interpolation, surface receives damage equally
		QUAD // calcculate the relative x and y coordinates with the dot products of the two perpendicular vectors
		// TODO< triangle >
	}
	
	
	// damage recording
	
	static struct InterpolationDamageDescriptor {
		DamageDescriptor damageDescriptor;
		public SpatialVector!(2, NumericType) coordinate; // can be null if its uniform
	}
	
	public EnumInterpolationForDamage interpolationForDamage = EnumInterpolationForDamage.UNIFORM;
	
	public final void addToDamageQueue(MeshType mesh, SpatialVector!(3, NumericType) position, ref DamageDescriptor damageDescriptor) {
		InterpolationDamageDescriptor interpolationDamageDescriptorToAdd;
		
		interpolationDamageDescriptorToAdd.damageDescriptor = damageDescriptor;
		
		if( interpolationForDamage == EnumInterpolationForDamage.UNIFORM ) {
			// do nothing
		}
		else if( interpolationForDamage == EnumInterpolationForDamage.QUAD ) {
			SpatialVector!(3, NumericType) p0 = mesh.vertices[meshFace.vertexIndices[0]];
			SpatialVector!(3, NumericType) p1 = mesh.vertices[meshFace.vertexIndices[1]];
			SpatialVector!(3, NumericType) pLast = mesh.vertices[meshFace.vertexIndices[$]];
			
			SpatialVector!(3, NumericType) diffToP0 = position - p0;
			SpatialVector!(3, NumericType) diffp1p0 = p1 - p0;
			SpatialVector!(3, NumericType) diffpLastp0 = pLast - p0;
			
			NumericType projectedAbsoluteX = dot(diffToP0, diffp1p0);
			NumericType projectedAbsoluteY = dot(diffToP0, diffpLastp0);
			NumericType projectedRelativeX = projectedAbsoluteX / diffp1p0.magnitude();
			NumericType projectedRelativeY = projectedAbsoluteY / diffpLastp0.magnitude();
			
			interpolationDamageDescriptorToAdd.coodinate = new SpatialVector!(2, NumericType)(projectedRelativeX, projectedRelativeY);
		}
		
		interpolationDamageDescriptors ~= interpolationDamageDescriptorToAdd;
	}
	
	public InterpolationDamageDescriptor[] interpolationDamageDescriptors;
	
	public final void flushInterpolationDamageDescriptors() {
		interpolationDamageDescriptors.length = 0;
	}
}


void recalcMesh(MeshType mesh) {
	void recalcPlueckerFace(MeshAndCollisionFace!double iterationFace) {
		iterationFace.plueckerFace = new PlueckerFace!(mesh.NumericType)();
		
		foreach( iterationVertexIndexPair; forwardPair(iterationFace.meshFace.verticesIndices) ) {
			SpatialVector!(3, double) startVertexPosition = mesh.vertices[iterationVertexIndexPair.first].position;
			SpatialVector!(3, double) endVertexPosition = mesh.vertices[iterationVertexIndexPair.second].position;
			
			iterationFace.plueckerFace.edgePueckerCoordinates ~= PlueckerCoordinate!double.createByPandQ(startVertexPosition, endVertexPosition);
		}
	}
	
	void recalcPlaneOfFace(MeshAndCollisionFace!double iterationFace) {
		int firstVertexOfFaceIndex = iterationFace.meshFace.verticesIndices[0];
		
		SpatialVector!(3, double) positionOfFirstVertex = mesh.vertices[firstVertexOfFaceIndex].position;
		iterationFace.planeOfFace = calcPlaneFromNormalAndPoint(iterationFace.meshFace.normalizedNormal, positionOfFirstVertex);
	}
	
	foreach( iterationFace; mesh.faces ) {
		recalcPlueckerFace(iterationFace);
		recalcPlaneOfFace(iterationFace);
	}
}

import std.typecons : Tuple;

import math.Matrix44;
import math.Matrix;
import math.MatrixCommonOperations : mul;

import physics.DynamicSimulator;
import physics.DynamicObject;

import ai.query.Query;

void main() {
	// armor*firepower normalized to 1.0
	alias Tuple!(uint, "index", float, "armorTimesFirepower", double, "distance", bool, "isBigShip", float, "calculatedPriority") QueryTupleType;
	alias Query!QueryTupleType QueryType;
		
	QueryType queryTargetSelection = new QueryType();
	
	
	DynamicSimulator dynamicSimulator = new DynamicSimulator();
	
	FuzzyControl fuzzyForPriorityOfTarget = buildFuzzyControlForPriorityOfTarget();
	
	// calculates the unnormalized attack priority (0; 4) of a target with fuzzylogic
	void foreachCalcPriority(ref QueryTupleType row) {
      	row.calculatedPriority = fuzzyForPriorityOfTarget.fuzzyLogic([cast(float)row.distance, row.armorTimesFirepower]);
   	}
	
	
	double shipMass = 10000.0f;
	DynamicObject shipDynamicObject = new DynamicObject(shipMass);
	shipDynamicObject.relativePosition = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	shipDynamicObject.velocity = new SpatialVector!(3, double)(0.0, 0.0, 0.0);
	
	dynamicSimulator.dynamicObjects ~= shipDynamicObject;



	
	PlueckerCoordinate!double plueckerRay;
	//PlueckerCoordinate!float edge0, edge1, edge2, edge3;
	
	plueckerRay = PlueckerCoordinate!double.createByNegativeVector(new SpatialVector!(3, double)(10.0f, 0.01f, 0.01f), new SpatialVector!(3, double)(-1.0f, 0.0f, 0.0f));
	
	Ray!double intersectionRay;
	intersectionRay.p0 = new SpatialVector!(3, double)(10.0f, 0.01f, 0.01f);
	intersectionRay.dir = new SpatialVector!(3, double)(-1.0f, 0.0f, 0.0f);
	
	/*
	SpatialVector!(3, float) vertex0 = new SpatialVector!(3, float)(0.0f, -1.0f, -1.0f);
	SpatialVector!(3, float) vertex1 = new SpatialVector!(3, float)(0.0f, -1.0f, 1.0f);
	SpatialVector!(3, float) vertex2 = new SpatialVector!(3, float)(0.0f, 1.0f, 1.0f);
	SpatialVector!(3, float) vertex3 = new SpatialVector!(3, float)(0.0f, 1.0f, -1.0f);
	
	edge0 = PlueckerCoordinate!float.createByPandQ(vertex0, vertex1);
	edge1 = PlueckerCoordinate!float.createByPandQ(vertex1, vertex2);
	edge2 = PlueckerCoordinate!float.createByPandQ(vertex2, vertex3);
	edge3 = PlueckerCoordinate!float.createByPandQ(vertex3, vertex0);
	
	
	writeln(PlueckerCheckCcw!float(plueckerRay, edge0));
	writeln(PlueckerCheckCcw!float(plueckerRay, edge1));
	writeln(PlueckerCheckCcw!float(plueckerRay, edge2));
	writeln(PlueckerCheckCcw!float(plueckerRay, edge3));
	*/
	float heightY = 10.0f;
	float sizeX = 3.0f;
	float sizeZ = 3.0f;
	uint segments = 5;
	Mesh!float cylinderMesh = MeshGenerator!(float).generateYCylinder(heightY, sizeX, sizeZ, segments);

	
	// simulate physics
	writeln(shipDynamicObject.relativePosition.x, " ", shipDynamicObject.relativePosition.y, " ", shipDynamicObject.relativePosition.z);


	dynamicSimulator.tick(1.0f / cast(float)60);
	
	Matrix!(double, 4, 4)[2] transformationMatrices;
	
	transformationMatrices[0] = createIdentity!(double)();
	transformationMatrices[1] = createIdentity!(double)();
	
	uint sourceMatrix = 0;
	
	// for fast multiplication of the matrices we switch between the matrices as the destination- and source-matrix
	mul(transformationMatrices[sourceMatrix], createTranslation(shipDynamicObject.relativePosition.x, shipDynamicObject.relativePosition.y, shipDynamicObject.relativePosition.z), transformationMatrices[1-sourceMatrix]);
	sourceMatrix = (sourceMatrix == 0) ? 1 : 0;
	
	Matrix!(double, 4, 4) transformationMatrix = transformationMatrices[sourceMatrix];
	
	MeshType workingCylinderMesh = convertMesh!(Mesh!float, MeshType)(cylinderMesh);
	
	// TODO< copy only vertices of mesh >
	// TODO< calculate transformation >
	workingCylinderMesh.transformVertices(transformationMatrix);
	workingCylinderMesh.recalculateNormals();
	workingCylinderMesh.recalcMesh();
	


	class IntersectionInfo {
		uint faceIndex;
		
		double rayDistance; // distance of the intersection ray, can be negative
	}
	
	
	
	IntersectionInfo[] intersectionInfos;
	
	foreach( faceIndex; 0..workingCylinderMesh.faces.length ) {
		if( workingCylinderMesh.faces[faceIndex].plueckerFace.intersectRay(plueckerRay) ) {
			IntersectionInfo createdIntersectionInfo = new IntersectionInfo();
			createdIntersectionInfo.faceIndex = faceIndex;
			
			intersectionInfos ~= createdIntersectionInfo;
		}
	}
	
	writeln(intersectionInfos.length);
	
	foreach( iterationIntersection; intersectionInfos ) {
		MeshAndCollisionFace!double intersectionFace = workingCylinderMesh.faces[iterationIntersection.faceIndex];
		
		iterationIntersection.rayDistance = calcRayPlaneT(intersectionRay, intersectionFace.planeOfFace);
		
		writeln("iterationIntersection.rayDistance ", iterationIntersection.rayDistance);
	}
	
	// TODO< search first intersection in front of the ray origin >
	
	
	
}
