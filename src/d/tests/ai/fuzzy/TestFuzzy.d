import ai.fuzzy.FuzzyControl;
import ai.fuzzy.FuzzyElement;
import ai.fuzzy.FuzzySet;
import ai.fuzzy.Area1d;
import ai.fuzzy.Trapezoid;

import common.ValueMatrix;

void main(string[] args) {
	import std.stdio;
	
	
	FuzzyControl fuzzyControl = new FuzzyControl();
	
	fuzzyControl.defuzzificationType = FuzzyControl.EnumDefuzzificationType.CENTEROFGRAVITY;
	fuzzyControl.globalCombinatorRule = FuzzyControl.EnumRuleType.OR; // TODO< rename to MAX >
	
	fuzzyControl.ruleMatrix = new ValueMatrix!(FuzzyControl.RuleElement)(2, 3);
	fuzzyControl.ruleMatrix[0, 0] = new FuzzyControl.RuleElement(1, FuzzyControl.EnumRuleType.AND);
	fuzzyControl.ruleMatrix[1, 0] = new FuzzyControl.RuleElement(1, FuzzyControl.EnumRuleType.AND);
	fuzzyControl.ruleMatrix[2, 0] = new FuzzyControl.RuleElement(0, FuzzyControl.EnumRuleType.AND);
	
	fuzzyControl.ruleMatrix[0, 1] = new FuzzyControl.RuleElement(1, FuzzyControl.EnumRuleType.AND);
	fuzzyControl.ruleMatrix[1, 1] = new FuzzyControl.RuleElement(1, FuzzyControl.EnumRuleType.AND);
	fuzzyControl.ruleMatrix[2, 1] = new FuzzyControl.RuleElement(0, FuzzyControl.EnumRuleType.AND);
	
	// distance
	fuzzyControl.inputFuzzySets ~= new FuzzySet([
		new FuzzyElement(new Trapezoid(0.0f,   5.0f, 1.0f,   6.0f, 1.0f,   7.0f)), // near 20km
		new FuzzyElement(new Trapezoid(6.0f,   7.0f, 1.0f,   8.0f, 1.0f,   9.0f)), // middle 100km
		new FuzzyElement(new Trapezoid(8.0f,   9.0f, 1.0f,  10.0f, 1.0f,  11.0f))  // extremly large
		]);
	
	// armor
	fuzzyControl.inputFuzzySets ~= new FuzzySet([
		new FuzzyElement(new Trapezoid(0.0f,   5.0f, 1.0f,   6.0f, 1.0f,   7.0f))		
		]);
	
	fuzzyControl.outputAreas ~= new Area1d([new PointDescriptor(0.0f, 0.0f), new PointDescriptor(1.0f, 1.0f), new PointDescriptor(2.0f, 0.0f)]); // extremly low priority
	fuzzyControl.outputAreas ~= new Area1d([new PointDescriptor(1.0f, 0.0f), new PointDescriptor(2.0f, 1.0f), new PointDescriptor(3.0f, 0.0f)]);
	
	
	writeln("start fuzzy");
	float fuzzyResult = fuzzyControl.fuzzyLogic([5.0f, 6.0f]);
	
	writeln(fuzzyResult);
}
