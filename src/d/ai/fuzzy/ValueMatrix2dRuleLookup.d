module ai.fuzzy.ValueMatrix2dRuleLookup;

import ai.fuzzy.FuzzyControl;
import ai.fuzzy.IRuleLookup;
import common.ValueMatrix;

class ValueMatrix2dRuleLookup : IRuleLookup {
	public final this(uint width, uint height) {
		ruleMatrix = new ValueMatrix!(FuzzyControl.RuleElement)(width, height);
	}
	
	public final FuzzyControl.RuleElement lookupRule(uint[] indices) {
		uint row = indices[0];
		uint column = indices[1];
		
		return ruleMatrix[row, column];
	}
	
	public ValueMatrix!(FuzzyControl.RuleElement) ruleMatrix;
}
