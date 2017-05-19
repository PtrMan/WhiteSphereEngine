import std.math : isNaN;
import std.algorithm.iteration : filter, map, reduce;
import std.array : array;
import std.random : uniform;

// paper [1] "Controlling Procedural Modeling Programs with Stochastically-Ordered Sequential Monte Carlo"
//           http://stanford.edu/~dritchie/procmod-smc.pdf

alias float ProceduralModelRandomChoiceType;
alias uint ExecutionChoiceType;

// is a part of the distribution called p in the paper
class Particle {
	// called x because its called x in the paper
	public static class x {
		public enum EnumType {
			EXECUTIONORDERCHOICE, // execution order choice, called o in the paper
			PROCEDURALMODELRANDOMCHOICE; // procedural models random choices, called r in the paper
		}

		public EnumType type;

		ExecutionChoiceType executionOrderChoice; // called o in the paper
		ProceduralModelRandomChoiceType programOwnRandomChoiceVariable; // called r in the paper
		                                      // TODO< change datatype? >
	}

	public x[] x_n; // done program execution choices (for generating new elements)

	// returns just the procedural model random choices, called r_n in the paper
	public final @property ProceduralModelRandomChoiceType[] r_n() {
		auto filterResult = filter!(xElement => xElement.type == x.EnumType.PROCEDURALMODELRANDOMCHOICE)(x_n);
		return array(map!(xElement => xElement.executionOrderChoice)(filterResult));
	}

	// returns just the ordering choices, called o_n in the paper
	public final @property ExecutionChoiceType[] o_n() {
		auto filterResult = filter!(xElement => xElement.type == x.EnumType.EXECUTIONORDERCHOICE)(x_n);
		return array(map!(xElement => xElement.programOwnRandomChoiceVariable)(filterResult));
	}

	public float rating;
}

abstract class Sosmc : Smc!Particle {
	public alias float delegate(ProceduralModelRandomChoiceType[]) ScoreFunctionType;

	public final this(ScoreFunctionType scoreFunction) {
		this.scoreFunction = scoreFunction;
	}

	// described in the paper [1] in chapter 4 SOSMC
	// this is nonsense, because it doesn't make mathematical sense
	protected final void p_n_high_pi(Particle particle, out uint chosenElementIndex) {
		float z_n_high_pi = calc_z_h_high_pi(particle, chosenElementIndex);
		return (p_n(particle.x_n) * scoreFunction(particle.r_n)) / z_n_high_pi;
	}

	// this does make a choice
	protected final float calc_z_h_high_pi(Particle particle, out uint chosenElementIndex) {
		float chosenRandomValue = uniform01(); // exclusive 1

		float accumulated = 0.0f;
		foreach( i; 0..distribution.length ) {
			accumulated += calcOrderingPolicy(particle);
			if( accumulated >= chosenRandomValue ) {
				chosenElementIndex = i;
				return;
			}
		}

		// is unreachable because one choice has to be made
		assert(false, "unreachable");
	}

	// described in the paper [1] in chapter 4 SOSMC
	// is the stochastic ordering policy
	protected final float calcOrderingPolicy(Particle particle) {
		return 1.0f / cast(float)state.numberOfPossibleSubcomputationsToContinue;
	}

	// TODO
	protected final float p_n(Particle particle) {
		// TODO 01.05.2016 : do we throw this out or not?
	}

	// uses interpreter and select random action
	protected abstract void simulateParticle(Particle particle);

	protected ScoreFunctionType scoreFunction;


	// inherited from Smc
	protected final void simulate() {
		foreach( iterationParticle; distribution.elements ) {
			simulateParticle(iterationParticle);
		}
	}

	// inherited from Smc
	protected final void weightParticle(ParticleType particle) pure {
		iterationParticle.rating = scoreFunction(particle.r_n);
	}

}











class Distribution(ParticleType) {
	public ParticleType[] elements;
}

// particle filter  also known as  sequential monte carlo
class Smc(ParticleType) {
	public Distribution!ParticleType distribution;
	public uint numberOfParticles;

	// does a simulation of the particles for whatever purpose
	protected abstract void simulate();

	protected abstract void weightParticle(ParticleType particle) pure;

	// rates all particles of the distribution
	protected final void weight() {
		foreach( iterationParticle; distribution.elements ) {
			weightParticle(iterationParticle.rating);
		}
	}


	public final void singleIteration() {
		simulate();
		weight();
		resample();
	}

	// resamples based on choosing the particles based on the relative weight to the other particles
	private final void resample() {
		float sum = reduce!((a, b) => a.weight + b.weight)(0.0f, distribution.elements);

		ParticleType[] newElements;

		foreach( i; 0..numberOfParticles ) {
			float chosenRandomValue = uniform(0.0f, sum); // all inclusive

			float accumulator = 0.0f;
			bool chosen = false;
			foreach( iterationParticle; distribution.elements ) {
				accumulator += iterationParticle.weight;
				if( accumulator >= chosenRandomValue ) { // equal seems important
					newElements ~= iterationParticle;
					chosen = true;
					break;
				}
			}
			assert(chosen, "Resample logic is wrong"); // should never happen
		}

		distribution.elements = newElements;
	}
}
