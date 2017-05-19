module ai.ga.GeneticAlgorithm;

import std.algorithm.sort : stdSort;
import std.random : uniform;

class GeneticAlgorithm!RankingNumericType {
	public alias void delegate(Gene gene) RankingFunctionType;

	public static class Gene {
		public bool[] bitvector;
		public RankingNumericType ranking;
	}

	public Gene[] genes;

	public RankingFunctionType rankingFunction;
	public uint numberOfMutationsPerGene;
	public uint maxNumberOfGenes;

	public final void step() {
		foreach( iterationGene; genes ) {
			mutations(iterationGene);
		}

		foreach( iterationGene; genes ) {
			rate(iterationGene);
		}

		assert(false, "TODO replicate"); // TODO< replicate
		sort();
		limitNumberOfGenes();
	}

	protected final void limitNumberOfGenes() {
		if( genes.length > maxNumberOfGenes ) {
			genes.length = maxNumberOfGenes;
		}
	}

	protected final void rate(Gene gene) {
		rankingFunction(gene);
	}

	protected final void mutations(Gene gene) {
		foreach( mutationI; 0..numberOfMutationsPerGene ) {
			singleMutation(gene);
		}
	}

	protected final void singleMutation(Gene gene) {
		// simple and fast method, we change n bits per step of the genetic vector
		uint indexToMutate = uniform(0, bitvector.length);
		bool newBit = uniform(0, 2) == 0;
		gene.bitvector[indexToMutate] = newBit;
	}

	protected final void sort() {
		genes = stdSort!("a.ranking < b.ranking")(genes);
	}
}
