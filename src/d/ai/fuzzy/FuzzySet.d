module ai.fuzzy.FuzzySet;

import ai.fuzzy.FuzzyElement;

class FuzzySet {
	public final this(FuzzyElement[] elements) {
		this.elements = elements;
	}
	
	public FuzzyElement[] elements;
}
