import ai.fuzzy.FuzzyControl;
import ai.fuzzy.FuzzyElement;
import ai.fuzzy.FuzzySet;
import ai.fuzzy.Area1d;
import ai.fuzzy.Trapezoid;
import ai.fuzzy.ValueMatrix2dRuleLookup;

import common.ValueMatrix;

void main(string[] args) {
	import std.stdio;
	
	
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
	
	// todo new row
	
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
	
	
	writeln("start fuzzy");
	float fuzzyResult = fuzzyControl.fuzzyLogic([0.5f, 1.0f]);
	
	writeln(fuzzyResult);
}
