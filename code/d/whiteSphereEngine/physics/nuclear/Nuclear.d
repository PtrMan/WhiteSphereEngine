module whiteSphereEngine.physics.nuclear.Nuclear;


alias double DecayConstant; 
alias double Halflife; // TODO< not just alias but own type

alias double Seconds;
alias double Mass;


// http://hyperphysics.phy-astr.gsu.edu/hbase/nuclear/halfli2.html
DecayConstant convertHalflifeToDecayConstant(Halflife halflife) {
	return 0.693 / halflife;
}

import std.math : exp;

// https://youtu.be/FGJvPKo2e6c?t=5m13s
Mass calcDecayRemainingMassAfterT(Mass massT0, DecayConstant alpha, Seconds t) {
	return massT0*exp(-alpha*t);
}



import std.regex;
import std.stdio : writeln;
import std.array : split;

class Isotope {
	final this(string name, string order) {
		this.name = name;
		this.order = order;
	}

	string name, order;
}

class NuclearParserException : Exception {
	final this(string message) {
		super(message);
	}
}

class NuclearParser {
	protected final void matchIsotope(string text, out string name, out string order) {
		auto matchIsotope = matchFirst("Chlorine36", regexIsotope);
		
		if( !matchIsotope ) {
			throw new NuclearParserException("Expected valid isotope");
		}

		name = matchIsotope[1];
		order = matchIsotope[2];
	}

	// adds null when its missing
	protected final Isotope[] matchDaugther(string text) {
		Isotope[] result;

		//auto matchDaugter = matchFirst("\tdaughter={Fermium250, Mendelevium254, Missing[Variable]}", regexDaugther);
		auto matchDaugter = matchFirst(text, regexDaugther);

		if( !matchDaugter ) {
			throw new NuclearParserException("Expected valid daugther");
		}

		string matchString = matchDaugter[1];
		foreach( string iterationDaughter; matchString.split(", ")) {
			bool isMissing = iterationDaughter == "Missing[Variable]";

			if( isMissing ) {
				result ~= null;
			}
			else {
				string name, order;
				matchIsotope(iterationDaughter, name, order);
				result ~= new Isotope(name, order);
			}
		}

		return result;
	}

	protected const string regexNumber = `([0-9]+\.[0-9]*(e\-?[0-9]+)?)`;
	protected const string regexList = `\{([\w\[\], ]*)\}`;

	protected auto regexIsotope = regex(`^([a-zA-Z]+)([0-9]+)$`);
	protected auto regexDaugther = regex(`\tdaughter=` ~ regexList ~ `$`);

	// uncommented because it conflicts with toher variable private auto regexIsotope = regex(`^([a-zA-Z]+)([0-9]+)$`);
}

void testParse() {
	const string regexNumber = `([0-9]+\.[0-9]*(e\-?[0-9]+)?)`;
	const string regexList = `\{([\w\[\], ]*)\}`;

	auto regexIsotope = regex(`^([a-zA-Z]+)([0-9]+)$`);
	auto regexHalflife = regex(`^\thalflife=` ~ regexNumber ~ `$`);
	auto regexAtomicMass = regex(`^\tatomicMass=` ~ regexNumber ~ `$`);

	auto regexModes = regex(`\tmodes=` ~ regexList ~ `$`);

	auto regexDaugther = regex(`\tdaughter=` ~ regexList ~ `$`);


	auto matchIsotope = matchFirst("Chlorine36", regexIsotope);
	
	if( matchIsotope ) {
		writeln(matchIsotope[1]);
		writeln(matchIsotope[2]);
	}
	else {
		writeln("<no match>");
	}

	auto matchHalflife = matchFirst("\thalflife=9.5e12", regexHalflife);

	if( matchHalflife ) {
		writeln(matchHalflife[1]);
	}
	else {
		writeln("<no match>");
	}

	matchHalflife = matchFirst("\thalflife=9.5", regexHalflife);

	if( matchHalflife ) {
		writeln(matchHalflife[1]);
	}
	else {
		writeln("<no match>");
	}

	matchHalflife = matchFirst("\thalflife=2.e-7", regexHalflife);

	if( matchHalflife ) {
		writeln(matchHalflife[1]);
	}
	else {
		writeln("<no match>");
	}

	matchHalflife = matchFirst("\thalflife=1069.", regexHalflife);

	if( matchHalflife ) {
		writeln(matchHalflife[1]);
	}
	else {
		writeln("<no match>");
	}

	// atomic mass test
	auto matchAtomicMass = matchFirst("\tatomicMass=124.92844", regexAtomicMass);

	if( matchAtomicMass ) {
		writeln(matchAtomicMass[1]);
	}
	else {
		writeln("<no match>");
	}

	
}

/* uncommented because it contains a main
import std.stdio : writeln;
import std.format : format;
import std.math : abs;

void main() {
	testParse();

	Halflife testHalflife = 50000000000.0;
	DecayConstant decayConstant = convertHalflifeToDecayConstant(testHalflife);

	Mass startmass = 10000.0;
	Mass massAfter0ms = calcDecayRemainingMassAfterT(startmass, decayConstant, 0.0);
	Mass massAfter1ms = calcDecayRemainingMassAfterT(startmass, decayConstant, 0.001);

	double iterationMass = massAfter0ms;
	double massRatioPerTick = massAfter1ms / massAfter0ms;

	foreach( t; 0..100000 ) {
		iterationMass *= massRatioPerTick;
	}

	Mass massAfternCycles = calcDecayRemainingMassAfterT(startmass, decayConstant, 0.001*cast(double)100000);

	writeln(format("%.60g", massRatioPerTick));
	writeln(format("%.60g", abs(iterationMass - massAfternCycles)));
}*/


// general helper
void multiplyVector(double *target, double *source, uint length) {
	for( uint i = 0; i < length; i++ ) {
		target[i] *= source[i];
	}
}

// general helper
void addVector(double *target, double *source, uint length) {
	for( uint i = 0; i < length; i++ ) {
		target[i] += source[i];
	}
}

// stepFactors is the factor  [0, 1) which which the masses are multiplied in each step
private void multiplyMassesByStepFactor(double *masses, double *stepFactors, uint length) {
	multiplyVector(masses, stepFactors, length);
}

private void calcMassDiff(double *beforeDecay, double *afterDecay, double *diff, uint length) {
  for( uint i = 0; i < length; i++ ) {
    diff[i] = beforeDecay[i] - afterDecay[i];
  }
}



class DecayContext {
	public double[] isotopeMasses;

	public double[] previousIsotopeMasses;

	public final void saveIsotopeMasses() {
		previousIsotopeMasses = isotopeMasses.dup;
	}
}

// class which is used to calculate the decay paths and released energy
class DecayManager {

	private double[] decayedIsotopeMasses;
	private double[] decayStepFactors; // [0, 1) values which depend on the halflifetime of the isotopes

	public double[] releasedEnergiesOfDecayInJoules;

	public IsotopeInfo[] isotopeInfos;

	private double[] deltaIsotopeMasses; // used to add the decay products to the masses


	public void iteration(DecayContext context) {
		assert( releasedEnergiesOfDecayInJoules.length == numberOfIsotopes );
		assert( decayedIsotopeMasses.length == numberOfIsotopes );
		assert( decayStepFactors.length == numberOfIsotopes );

		assert( context.isotopeMasses.length == numberOfIsotopes );
		assert( context.previousIsotopeMasses.length == numberOfIsotopes );
		assert( isotopeInfos.length == numberOfIsotopes );

		context.saveIsotopeMasses();
		multiplyMassesByStepFactor(context.isotopeMasses.ptr, decayStepFactors.ptr, numberOfIsotopes);
		calcMassDiff(context.previousIsotopeMasses.ptr, context.isotopeMasses.ptr, decayedIsotopeMasses.ptr, numberOfIsotopes);

		foreach( isotopeIndex; 0..numberOfIsotopes ) {
			calcDecayedRatios(isotopeInfos[isotopeIndex], decayedIsotopeMasses.ptr, deltaIsotopeMasses.ptr);
			releasedEnergiesOfDecayInJoules[isotopeIndex] = calcDecayEnergyInJoules(isotopeInfos[isotopeIndex], decayedIsotopeMasses.ptr);
		}

		// add the decay products back to the vector
		addVector(context.isotopeMasses.ptr, deltaIsotopeMasses.ptr, numberOfIsotopes);
	}


	private static void calcDecayedRatios(IsotopeInfo isotope, double *decayedIsotopeMasses, double *deltaIsotopeMasses) {
		// we need to go from back to front and subtract the remaining ratio because of some precision issues in the tables

		double remainingRatio = 1.0;

		for( int i = isotope.decayInfos.length-1; i >= 1; i-- ) {
			double ratio = isotope.decayInfos[i].ratio;
			IsotopeIndex destinationIsotope = isotope.decayInfos[i].destinationIsotope;
	    
			deltaIsotopeMasses[destinationIsotope] += (decayedIsotopeMasses[isotope.index] * ratio);

			remainingRatio -= ratio;
		}

		// for first one
		{
			int i = 0;

			double ratio = remainingRatio;
			IsotopeIndex destinationIsotope = isotope.decayInfos[i].destinationIsotope;
	    
			deltaIsotopeMasses[destinationIsotope] += (decayedIsotopeMasses[isotope.index] * ratio);
		}
	}

	private double calcDecayEnergyInJoules(IsotopeInfo isotope, double *decayedIsotopeMasses) {
		double energyInJoules = 0.0;

		double remainingRatio = 1.0;

		for( int i = isotope.decayInfos.length-1; i >= 1; i-- ) {
			double ratio = isotope.decayInfos[i].ratio;
			IsotopeIndex destinationIsotopeIndex = isotope.decayInfos[i].destinationIsotope;
	    
			double decayedMassOfDecayProcess = decayedIsotopeMasses[isotope.index] * ratio;
			energyInJoules += calcProducedEnergyOfDecayInJoules(isotope, isotopeInfos[destinationIsotopeIndex], isotope.decayInfos[i], decayedMassOfDecayProcess);

			remainingRatio -= ratio;
		}

		// for first one
		{
			int i = 0;

			double ratio = remainingRatio;
			IsotopeIndex destinationIsotopeIndex = isotope.decayInfos[i].destinationIsotope;
	    
			double decayedMassOfDecayProcess = decayedIsotopeMasses[isotope.index] * ratio;
			energyInJoules += calcProducedEnergyOfDecayInJoules(isotope, isotopeInfos[destinationIsotopeIndex], isotope.decayInfos[i], decayedMassOfDecayProcess);
		}

		return energyInJoules;
	}

	private static double calcProducedEnergyOfDecayInJoules(IsotopeInfo decayedIsotopeInfo, IsotopeInfo decayProductIsotopeInfo, DecayInfo decayInfo, double massInKilogram) {
		if( decayInfo.decayType == DecayInfo.EnumDecayType.BETAMINUS ) {
			return calcReleasedEnergyOfBetaMinusDecayInJoule(massInKilogram, decayedIsotopeInfo.massInAtomicMass, decayProductIsotopeInfo.massInAtomicMass);
		}
		else if( decayInfo.decayType == DecayInfo.EnumDecayType.BETAPLUS ) {
			return calcReleasedEnergyOfBetaPlusDecayInJoule(massInKilogram, decayedIsotopeInfo.massInAtomicMass, decayProductIsotopeInfo.massInAtomicMass);
		}
		else {
			// TODO< throw something >
			assert(false, "internal error: not implemeneted decay type");
		}
	}

	private uint numberOfIsotopes;
}





alias uint IsotopeIndex;

struct DecayInfo {
	double ratio;
	IsotopeIndex destinationIsotope;
	  
	EnumDecayType decayType;

	public enum EnumDecayType {
		BETAMINUS,
		BETAPLUS
	}

	public final this(double ratio, EnumDecayType decayType, IsotopeIndex destinationIsotope) {
		this.ratio = ratio;
		this.decayType = decayType;
		this.destinationIsotope = destinationIsotope;
	}
}

class IsotopeInfo {
	DecayInfo[] decayInfos;
	
	IsotopeIndex index; // index of this isotope

	double massInAtomicMass;
}


// TODO<
//    decay types and energy release with decay
// >

// is a small hack to simplify things, how much energy do have the delayed neutrons for a delayed neutron decay
// https://en.wikipedia.org/wiki/Delayed_neutron
const double STANDARD_ENERGY_DELAYED_NEUTRON_IN_ELECTRONVOLT = 400000.0;

// https://en.wikipedia.org/wiki/Alpha_decay
const double STANDARD_ENERGY_ALPHA_DECAY_IN_ELECTRONVOLT = 5e6; // 5 MeV

// https://de.wikipedia.org/wiki/Atomare_Masseneinheit
const double KILOGRAM_TO_ATOMIC_MASS = 6.022140857e26;
double kilogramToAtomicMass(double kilogram) {
	return kilogram * KILOGRAM_TO_ATOMIC_MASS;
}


double atomicMassToKilogram(double atomicMass) {
	return atomicMass * (1.0 / kilogramToAtomicMass(1.0));
}

const double LIGHTSPEED = 2.998e8;

double kilogramToEquivalentJoule(double kilogram) {
	// e = mc^2
	return kilogram*LIGHTSPEED*LIGHTSPEED;
}

double jouleToEquivalentKilogram(double joule) {
	return (1.0 / kilogramToEquivalentJoule(1.0)) * joule;
}



// https://de.wikipedia.org/wiki/Elektronenvolt
double electronvoltToJoule(double kilovolt) {
	return kilovolt * 1.6021766208e-19;
}

/*
double electronvoltToEquivalentAutomicMass(double kilovolt) {

}*/

double jouleToEquivalentAtomicMass(double joule) {
	return kilogramToAtomicMass(jouleToEquivalentKilogram(joule));
}


double calcMassLossOfDecay(double decayedMassInKilogram, double atomicMassOfAtomBeforeDecay, double masslossPerAtomInKilogram) {
	// calculate the ratio of massloss
	double masslossRatio = (atomicMassOfAtomBeforeDecay - atomicMassToKilogram(masslossPerAtomInKilogram)) / atomicMassOfAtomBeforeDecay;

	double lostMass = decayedMassInKilogram * masslossRatio;
	return lostMass;
}


// nonrelativistic mass/energy calculations
double calcEmittedEnergyOfDecayInJoule(double inputMassInKilogram, double atomicMassOfAtomBeforeDecayInAtomicMass, double emittedEnergyPerAtomInJoule) {
	double ratio = (atomicMassOfAtomBeforeDecayInAtomicMass - jouleToEquivalentAtomicMass(emittedEnergyPerAtomInJoule)) / atomicMassOfAtomBeforeDecayInAtomicMass;
	double releasedEquivalentMassInKilogram = inputMassInKilogram * (1.0 - ratio);
	return kilogramToEquivalentJoule(releasedEquivalentMassInKilogram);
}






// ===========================
//  decay energy calculations
// all are nonrelativistic and don't take the velocity into account
// they just calculate the released energy

// https://en.wikipedia.org/wiki/Alpha_decay
// TODO< correct me >
double calcReleasedEnergyOfAlphaDecayInJoule(double inputMassInKilogram, double atomicMassOfAtomBeforeDecayInAtomicMass) {
	const double massWithoutAlphaParticleInAtomicMass = atomicMassOfAtomBeforeDecayInAtomicMass - MASS_HELIUM_IN_ATOMICMASS;
	assert(massWithoutAlphaParticleInAtomicMass > 0.0);
	return calcEmittedEnergyOfDecayInJoule(inputMassInKilogram, massWithoutAlphaParticleInAtomicMass, electronvoltToJoule(STANDARD_ENERGY_ALPHA_DECAY_IN_ELECTRONVOLT));
}

// https://en.wikipedia.org/wiki/Beta_decay
// corrected
double calcReleasedEnergyOfBetaMinusDecayInJoule(double inputMassInKilogram, double atomicMassOfAtomBeforeDecayInAtomicMass, double atomicMassOfAtomAfterDecayInAtomicMass) {
	double massLossInAtomicMass = atomicMassOfAtomBeforeDecayInAtomicMass - atomicMassOfAtomAfterDecayInAtomicMass;
	double ratio = massLossInAtomicMass / atomicMassOfAtomBeforeDecayInAtomicMass;
	return kilogramToEquivalentJoule(inputMassInKilogram*ratio);
}

// https://en.wikipedia.org/wiki/Beta_decay
// corrected
double calcReleasedEnergyOfBetaPlusDecayInJoule(double inputMassInKilogram, double atomicMassOfAtomBeforeDecayInAtomicMass, double atomicMassOfAtomAfterDecayInAtomicMass) {
	double massLossInAtomicMass = atomicMassOfAtomBeforeDecayInAtomicMass - atomicMassOfAtomAfterDecayInAtomicMass - 2.0 * MASSOFELECTRON_IN_AOMICMASS;
	double ratio = massLossInAtomicMass / atomicMassOfAtomBeforeDecayInAtomicMass;
	return kilogramToEquivalentJoule(inputMassInKilogram*ratio);
}

// TODO< correct me >
double calcReleasedEnergyOfFissionInJoule(double inputMassInKilogram, double atomicMassOfAtomBeforeDecayInAtomicMass, double numberOfEmittedNeutronsPerDecay) {
	return calcEmittedEnergyOfDecayInJoule(inputMassInKilogram, atomicMassOfAtomBeforeDecayInAtomicMass, electronvoltToJoule(STANDARD_ENERGY_DELAYED_NEUTRON_IN_ELECTRONVOLT) * numberOfEmittedNeutronsPerDecay);
}

// TODO< correct me >
/* uncommented because this is named wrongly, TODO< rename and check if correct
double calcReleasedEnergyOfFissionInJoule(double inputMassInKilogram, double atomicMassOfAtomBeforeDecayInAtomicMass, double numberOfEmittedNeutronsPerDecay) {
	return calcReleasedEnergyOfFissionInJoule(inputMassInKilogram, atomicMassOfAtomBeforeDecayInAtomicMass, numberOfEmittedNeutronsPerDecay);
}
*/

// tables
const double MASS_HELIUM_IN_ATOMICMASS = 4.002602; // http://www.chemicalelements.com/elements/he.html
const double MASSOFELECTRON_IN_AOMICMASS = 5.4857990943e-4; // https://en.wikipedia.org/wiki/Electron_rest_mass
