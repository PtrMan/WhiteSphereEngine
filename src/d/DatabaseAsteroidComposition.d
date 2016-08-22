
// more detailed composition see
// Geochemistry of ordinary chondrites, Geochimica et Cosmochimica Acta, 1989, Vol. 53, page 2747–2767
// url(education web account required for access) http://www.sciencedirect.com/science/journal/00167037/53/10


struct StellarComponent {
	public enum EnumType {
		RAWELEMENTS,
		MINERALCOMPOSITION
	}
	
	// elementNameList : comma seperated
	static StellarComponent makeElement(string elementNameList, float compositionMin, float compositionMax) {
		// TODO
	}
	
	// makes it after the mineral composition
	static StellarComponent make(string stoneComposition, float compositionMinOrExact, float compositionMax = -1.0f) {
		// TODO
	}
	
	public immutable EnumType type;
	
	public immutable float compositionMax; // negative means there is no max
	public immutable float compositionMinOrExact; // minimal or exact value
	
	public immutable string elementNameList, stoneComposition;
}

// https://en.wikipedia.org/wiki/H_chondrite
static const StellarComponent[] compositionHchondrite = [StellarComponent.makeElement("iron", 25, 31), StellarComponent.make("bronzite"), StellarComponent.make("olivine", 16, 20), StellarComponent.makeElement("nickel,iron", 15, 19), StellarComponent.make("troilite", 5)]

// https://en.wikipedia.org/wiki/L_chondrite
TODO

// https://en.wikipedia.org/wiki/LL_chondrite
TODO

// https://en.wikipedia.org/wiki/Carbonaceous_chondrite
// TODO< composition of all of them >

// https://en.wikipedia.org/wiki/Enstatite_chondrite
// TODO< composition of all of them >

// https://en.wikipedia.org/wiki/Primitive_achondrite
// TODO< composition of all of them >


// TODO< Differentiated achondrites >

// TODO< Stony-irons >





// overall composition in solar system, see http://www.geology.cz/bulletin/fulltext/01burbinefinal.pdf
/ title "Asteroids: Their composition and impact threat"