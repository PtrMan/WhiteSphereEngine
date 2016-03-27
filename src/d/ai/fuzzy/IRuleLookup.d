module ai.fuzzy.IRuleLookup;

import ai.fuzzy.FuzzyControl;

interface IRuleLookup {
	FuzzyControl.RuleElement lookupRule(uint[] indices);
}
