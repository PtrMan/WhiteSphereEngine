module ai.fuzzy.FuzzyControl;

// https://de.wikipedia.org/wiki/Fuzzy-Regler

import std.algorithm : min, max;

import math.LinearEquation;
import ai.fuzzy.Area1d;
import ai.fuzzy.FuzzySet;
import ai.fuzzy.FuzzyElement;
import ai.fuzzy.IRuleLookup;


// TODO< the rule table can be either a matrix or a function which does the decision >

class FuzzyControl {
	alias uint RuleSelector;
	alias uint FuzzyElementIndex;
	
	public enum EnumRuleType {
		AND,
		OR
	}
	
	public enum EnumValueOperation {
		MIN,
		MAX
	}
	
	public enum EnumDefuzzificationType {
		CENTEROFGRAVITY
	}
	
	private static class FuzzyElementWithActivation {
		final public this(FuzzyElementIndex elementIndex, float activationValue) {
			this.elementIndex = elementIndex;
			this.activationValue = activationValue;
		}
		
		public FuzzyElementIndex elementIndex;
		public float activationValue;
	}
		
	// one element of the rule matrix can have either a and or a or combination
	public static class RuleElement {
		public final this(RuleSelector ruleSelector, EnumRuleType ruleType) {
			this.ruleSelector = ruleSelector;
			this.ruleType = ruleType;
		}
		
		public EnumRuleType ruleType;
		public RuleSelector ruleSelector;
	}
	
	
	private static struct ResultActivationElement {
		public bool set;
		public float activation = 0.0f;
		
		public final void combine(EnumValueOperation globalCombinatorRule, float otherActivation) {
			if( set ) {
				activation = FuzzyControl.applyValueOperation(globalCombinatorRule, activation, otherActivation);
			}
			else {
				set = true;
				activation = otherActivation;
			}
		}
	}
		
	
	public EnumDefuzzificationType defuzzificationType;
	
	// TODO< avergage of membership >
	public EnumValueOperation globalCombinatorRule;

	public IRuleLookup ruleLookup;
	
	public FuzzySet[] inputFuzzySets;
	
	public Area1d[] outputAreas;
	
	public final float fuzzyLogic(float[] inputValues) {
		// we have it just implemented for two values
		assert(inputValues.length == 2);
		
		// used for defuzification
		ResultActivationElement[] resultElements;
		resultElements.length = outputAreas.length;
		
		// fuzzification
		FuzzyElementWithActivation[] fuzzyElementsWithActivationForA = fuzzificationBySet(inputFuzzySets[0], inputValues[0]);
		FuzzyElementWithActivation[] fuzzyElementsWithActivationForB = fuzzificationBySet(inputFuzzySets[1], inputValues[1]);
		
		// inference
		foreach( iterationActivatedAElement; fuzzyElementsWithActivationForA ) {
			foreach( iterationActivatedBElement; fuzzyElementsWithActivationForB ) {
				float combinedValue;
				RuleSelector resultRuleSelector;
				calcCombination(
					iterationActivatedAElement.elementIndex,
					iterationActivatedBElement.elementIndex,
					
					iterationActivatedAElement.activationValue,
					iterationActivatedBElement.activationValue,
					
					resultRuleSelector, // out
					combinedValue // out
				);
				
				resultElements[resultRuleSelector].combine(globalCombinatorRule, combinedValue);
			}
		}
		
		// defuzzification
		Area1d[] resultTrapezoids = translateActivationElementsToAreas(outputAreas, resultElements);
		
		float defuzzificationResult;
		
		if( defuzzificationType == EnumDefuzzificationType.CENTEROFGRAVITY ) {
			Area1d mergedAreas = mergeAreas(resultTrapezoids);
			defuzzificationResult = mergedAreas.calcCentroid();
		}
		else {
			assert(false, "Internal Error"); // impossible
		}
		
		return defuzzificationResult;
	}
	
	protected static Area1d mergeAreas(Area1d[] areas) {
		Area1d result = areas[0];
		
		foreach( iterationArea; areas[1..$] ) {
			result = result.merge(iterationArea);
		}
		
		return result;
	}
	
	protected static Area1d[] translateActivationElementsToAreas(Area1d[] outputAreas, ResultActivationElement[] resultElements) {
		float[] activations = translateResultElementsToActivations(resultElements);
		
		Area1d[] result;
		
		foreach( i; 0..resultElements.length ) {
			float activation = activations[i];
			Area1d outputArea = outputAreas[i];
			result ~= calcActivatedArea(outputArea, activation);
		}
		
		return result;
	}
	
	protected static Area1d calcActivatedArea(Area1d area, float activation) {
		PointDescriptor[] resultAreaPoints;
		
		foreach( i ; 0..area.points.length-1 ) {
			PointDescriptor a = area.points[i];
			PointDescriptor b = area.points[i+1];
			
			if( (a.y > activation) != (b.y > activation) ) {
				float ay = min(a.y, activation), by = min(b.y, activation);
				
				float m = calculateM(a.x, a.y, b.x, b.y);
				float n = calculateN(m, a.x, a.y);
				
				
				resultAreaPoints ~= new PointDescriptor(a.x, ay);
				resultAreaPoints ~= new PointDescriptor(calcX(m, n, activation), activation);
				resultAreaPoints ~= new PointDescriptor(b.x, by);
			}
			else {
				float ay = min(a.y, activation), by = min(b.y, activation);
				
				resultAreaPoints ~= new PointDescriptor(a.x, ay);
				resultAreaPoints ~= new PointDescriptor(b.x, by);
			}
		}
		
		return new Area1d(resultAreaPoints);
	}
	
	protected static float[] translateResultElementsToActivations(ResultActivationElement[] resultElements) {
		float[] result;
		
		foreach( iterationResultElement; resultElements ) {
			result ~= iterationResultElement.activation;
		}
		
		return result;
	}
	
	// fuzzifies a value with a set and returns zero or more fuzzy elements with the activation strengths
	protected final FuzzyElementWithActivation[] fuzzificationBySet(FuzzySet set, float value) {
		void calcIntersectionOfFuzzyElementByValue(FuzzyElement element, float value, out bool intersect, out float activationValue) {
			intersect = element.isInRange(value);
			if( !intersect ) {
				return;
			}
			
			activationValue = element.calcIntersection(value);
		}
		
		FuzzyElementWithActivation[] result;
		
		foreach( uint elementIndex, iterationElement; set.elements ) {
			bool intersect;
			float activationValue;
			calcIntersectionOfFuzzyElementByValue(iterationElement, value, intersect, activationValue);
			if( intersect ) {
				result ~= new FuzzyElementWithActivation(elementIndex, activationValue);
			}
		}
		
		return result;
	}
	
	
		
	// lookup the rule and calculates the combined value by the rule table
	protected final void calcCombination(uint row, uint column, float rowValue, float columnValue, out RuleSelector resultRuleSelector, out float combinedValue) {
		RuleElement lookedupRule = ruleLookup.lookupRule([row, column]);
		
		resultRuleSelector = lookedupRule.ruleSelector;
		combinedValue = combineAfterRuleType(lookedupRule.ruleType, [rowValue, columnValue]);
	}
	
	protected static float combineAfterRuleType(EnumRuleType ruleType, float[] values) {
		EnumValueOperation valueOperation = translateRuleTypeToValueOperation(ruleType);
		
		float carryValue = values[0];
		
		foreach( iterationValue; values[1..$] ) {
			carryValue = applyValueOperation(valueOperation, carryValue, iterationValue);
		} 
		
		return carryValue;
	}
	
	protected static EnumValueOperation translateRuleTypeToValueOperation(EnumRuleType ruleType) {
		final switch( ruleType ) {
			case EnumRuleType.AND: // AND combination is realized by minimum of the two inputs
			return EnumValueOperation.MIN;
			
			case EnumRuleType.OR: // OR combination is realized by maximum of the two inputs
			return EnumValueOperation.MAX;
		}
	}
	
	protected static float applyValueOperation(EnumValueOperation valueOperation, float a, float b) {
		final switch( valueOperation ) {
			case EnumValueOperation.MIN: return min(a, b);
			case EnumValueOperation.MAX: return max(a, b);
		}
	}
}
