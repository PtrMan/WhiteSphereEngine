
// TODO< unify with decay simulator and use common database >
// dummy
class Isotope {
	// TODO< dummy >
}

class IsotopeLookup {
	final Isotope lookupByStandardname(string name) {
		assert(false, "TODO - is a dummy");
	}
}

class Mineral {
	static class Composition {
		Isotope isotope;
		float fraction; // 1.0 is 100%

		final this(Isotope isotope, float fraction) {
			this.isotope = isotope;
			this.fraction = fraction;
		}
	}

	string humanName;
}

{
	IsotopeLookup isotopeLookup; // TODO< grab or initialize >

	// see https://www.mineralienatlas.de/lexikon/index.php/MineralData?lang=de&language=german&mineral=Bronzite
	// TODO< more detailed
	Mineral bronzite = new Mineral();
	with(bronzite) {
		humanName = "bronzite";
		components = [
			new Mineral.Composition(isotopeLookup.lookupByStandardname("o"), 0.4433f),
			new Mineral.Composition(isotopeLookup.lookupByStandardname("mg"), 0.1684f),
			new Mineral.Composition(isotopeLookup.lookupByStandardname("si"), 0.2594f),
			new Mineral.Composition(isotopeLookup.lookupByStandardname("fe"), 0.1289f),
		];
	}

	assert(false, "TODO - add bronzite to database");

	// see https://www.mineralienatlas.de/lexikon/index.php/MineralData?mineral=Fayalit
	// TODO< more detailed
	Mineral fayalite = new Mineral();
	with(fayalite) {
		humanName = "fayalite";
		components = [
			new Mineral.Composition(isotopeLookup.lookupByStandardname("o"), 0.3141f),
			new Mineral.Composition(isotopeLookup.lookupByStandardname("si"), 0.1378f),
			new Mineral.Composition(isotopeLookup.lookupByStandardname("fe"), 0.5481f),
		];
	}

	assert(false, "TODO - add fayalite to database");


	// see https://www.mineralienatlas.de/lexikon/index.php/MineralData?mineral=Troilite
	Mineral troilite = new Mineral();
	with(troilite) {
		humanName = "troilite";
		components = [
			new Mineral.Composition(isotopeLookup.lookupByStandardname("fe"), 0.5749f),
			new Mineral.Composition(isotopeLookup.lookupByStandardname("co"), 0.015f),
			new Mineral.Composition(isotopeLookup.lookupByStandardname("ni"), 0.043f),
			new Mineral.Composition(isotopeLookup.lookupByStandardname("s"), 0.3571f),
		];
	}

	assert(false, "TODO - add troilite to database");


	// deprecated name: https://www.mineralienatlas.de/lexikon/index.php/MineralData?mineral=Hypersthene
	// data is from https://www.mineralienatlas.de/lexikon/index.php/MineralData?mineral=Enstatit
	Mineral enstatit;
	with(enstatit) {
		humanName = "enstatit";
		components = [
		new Mineral.Composition(isotopeLookup.lookupByStandardname("o"), 0.4781f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("mg"), 0.2421f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("si"), 0.2798f),
		];
	}

	Mineral hypersthene = enstatit;

	assert(false, "TODO - add hypersthene to database");

	// https://www.mineralienatlas.de/lexikon/index.php/MineralData?mineral=Chromite
	Mineral chromite;
	with(chromite) {
		humanName = "chromite";
		components = [
		new Mineral.Composition(isotopeLookup.lookupByStandardname("o"), 0.2859f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("cr"), 0.4646f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("fe"), 0.2495f),
		];
	}


	assert(false, "TODO - add Chromite to database");

	// https://www.mineralienatlas.de/lexikon/index.php/MineralData?mineral=Feldspar
	Mineral feldspar;
	with(feldspar) {
		humanName = "feldspar";
		components = [
		new Mineral.Composition(isotopeLookup.lookupByStandardname("h"), 0.0024f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("b"), 0.0255f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("n"), 0.033f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("o"), 0.0377f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("na"), 0.0542f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("al"), 0.0636f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("si"), 0.0662f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("k"), 0.0922f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("ca"), 0.0945f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("sr"), 0.2066f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("ba"), 0.3239f),
		];
	}

	assert(false, "TODO - add feldspar to database");

	// https://www.mineralienatlas.de/lexikon/index.php/MineralData?mineral=Corundum
	Mineral corundum;
	with(corundum) {
		humanName = "corundum";
		components = [
		new Mineral.Composition(isotopeLookup.lookupByStandardname("o"), 0.4707f),
		new Mineral.Composition(isotopeLookup.lookupByStandardname("al"), 0.5293f),
		];
	}

}


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

// slash just means that its the maincomponent

// https://en.wikipedia.org/wiki/H_chondrite
static const StellarComponent[] compositionHchondrite = [
	StellarComponent.makeElement("iron", 25, 31),
	StellarComponent.make("bronzite"),
	StellarComponent.make("olivine/fayalite", 16, 20),
	StellarComponent.makeElement("nickel,iron", 15, 19),
	StellarComponent.make("troilite", 5)
];

// https://en.wikipedia.org/wiki/L_chondrite
static const StellarComponent[] compositionLchondrite = [
	StellarComponent.make("olivine/fayalite", 21, 25),
	StellarComponent.make("orthopyroxene/hypersthene"),
	StellarComponent.makeElement("nickel,iron", 4, 10),
	StellarComponent.make("troilite"),
	StellarComponent.make("chromite"),
	StellarComponent.make("feldspar")
]; // and after wikipedia Ca-phosphates, no idea what this means at all

// https://en.wikipedia.org/wiki/LL_chondrite
static const StellarComponent[] compositionLLchondrite = [
	StellarComponent.make("iron", 19, 22),
	StellarComponent.make("olivine/fayalite", 26, 32),
	StellarComponent.make("orthopyroxene/hypersthene"),
	StellarComponent.makeElement("nickel,iron"),
	StellarComponent.make("troilite"),
	StellarComponent.make("feldspar"),
	StellarComponent.make("chromite"),
	// TODO< phosophates
];



// https://en.wikipedia.org/wiki/Carbonaceous_chondrite
// TODO< composition of all of them >
// BEGIN 

// https://en.wikipedia.org/wiki/CI_chondrite#Chemical_composition
static const StellarComponent[] CarbonaceousChondrite_CI = [
	StellarComponent.make("water", 17, 22),
	StellarComponent.make("iron", 25),

	// from now on mixed because no one knows how high the distribution is
	StellarComponent.make("pyrrhotite"), // TODO
	StellarComponent.make("pentlandite"), // TODO
	StellarComponent.make("troilite"),
	StellarComponent.make("cubanite"), // TODO
];

// CV-group
// http://new.meteoris.de/class/CV-Group.html
static const StellarComponent[] CarbonaceousChondrite_CV = [
	StellarComponent.make("olivine/fayalite", 20, 60), // roll dice because no one knows
	StellarComponent.make("olivine/forsterite"), // let it fill up the mass, is magnesium rich

	// now the 
	// https://en.wikipedia.org/wiki/Calcium%E2%80%93aluminium-rich_inclusion
	// follow, should be ~ 5% so we just share a few percentages to the components, plus minus some minor "boost"
	StellarComponent.make("anorthite", 0.4, 0.6),
	StellarComponent.make("melilite", 0.4, 0.6),
	StellarComponent.make("perovskite", 0.4, 0.6),
	StellarComponent.make("corundum", 0.4, 0.6), // aluminous spinel, we just take Corundum, see "Calcium-Aluminum-rich Inclusions: Major Unanswered Questions " https://geosci.uchicago.edu/~grossman/MSD05.pdf   pdf page 3
	StellarComponent.make("hibonite", 0.4, 0.6),
	StellarComponent.make("TODO", 0.4, 0.6), // calcic pyroxene
	StellarComponent.make("TODO", 0.4, 0.6), // forsterite-rich olivine

	// TODO< maybe somewhere are better compositions of this damn group
];

// TODO< remaining members of the group >
// TODO TODO TODO TODO

// CR-group
//    http://new.meteoris.de/class/CR-Group.html
// -> https://en.wikipedia.org/wiki/Kaidun_meteorite
// -> http://www.lpi.usra.edu/meetings/sssr2011/presentations/lee.pdf  page 9
// TODO< mix and match >



// CM-group
//    http://new.meteoris.de/class/CM-Group.html
// -> http://adsabs.harvard.edu/full/1973SSRv...14..832V
// TODO< read and extract >



// END





// https://en.wikipedia.org/wiki/Enstatite_chondrite
// TODO< composition of all of them >

// https://en.wikipedia.org/wiki/Primitive_achondrite
// TODO< composition of all of them >


// TODO< Differentiated achondrites >

// TODO< Stony-irons >





// overall composition in solar system, see http://www.geology.cz/bulletin/fulltext/01burbinefinal.pdf
// title "Asteroids: Their composition and impact threat"