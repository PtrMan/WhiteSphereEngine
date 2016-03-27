module ai.fuzzy.FunctionRuleLookup;

import ai.fuzzy.IRuleLookup;

// lookup of the fuzzy rule by calling a function
class FunctionRuleLookup : IRuleLookup {
	public final this(FuzzyControl.RuleElement function(uint[] indices) functionToCall) {
		this.functionToCall = functionToCall;
	}
	
	public final FuzzyControl.RuleElement lookupRule(uint[] indices) {
		return functionToCall(indices);
	}
	
	public FuzzyControl.RuleElement function(uint[] indices) functionToCall;
}
