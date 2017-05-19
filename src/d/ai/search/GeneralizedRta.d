module ai.search.GeneralizedRta;

/*
 * Implementation of "real time A-star" and "learning real time A-star" with some genetic programming flexibility for our planning algorithm(s)
 * which use the implementation.
 */




import std.algorithm : min;

protected class ValueImplementationFirstBest(ContentType) {
	public final this(ContentType initial) {
		bestValue = initial;
	}

	public final opOpAssign!("~")((ContentType value) {
		bestValue = min(bestValue, value);
	}

	public final ContentType calcValue() {
		return bestValue;
	}

	protected ContentType bestValue;
}

import std.typecon : Tuple, scoped;

import common.datastructures.IBidirectionalAdjacent : IBidirectionalAdjacent;
import common.Hashtable : Hashtable : HashtableImplementation;

// hashtable with accessor and which returns only one result
protected class HashtableForIntegers(Type) {
	protected const uint NUMBEROFBUCKETS = 256;

	protected HashtableImplementation!(Type, NUMBEROFBUCKETS) hashtable = new HashtableImplementation!(Type, NUMBEROFBUCKETS)(hashIdentity);

	public final Type opIndexAssign(Type value, uint index) {
		hashtable.insertOrReplace(index, value);
	}

	public final Type opIndex(uint index) {
		Type[] result = hashtable.get(index);
		assert(result.length == 1);
		return result[0];
	}

	public final void flush() {
		hashtable.flush();
	}
    
    // used as a identity function
    protected static uint hashIdentity(Type value) {
    	return cast(uint)Type;
    }
}


// see
// "New Strategies in Learning Real Time Heuristic Search"
//    http://www.tzi.de/~edelkamp/publications/conf/aaai/Edelkamp97.pdf
protected class GeneralizedRta(ValueImplementation, ContentType) {
	//private Stack!ContentType open;

	protected IBidirectionalAdjacent!float g; // graph is unidirected
	protected HashtableForIntegers!uint h = new HashtableForIntegers!uint();

	public final void reset() {
		h.flush(); // flush hashmap for weights of nodes
	}

	public final void step() {
		// TODO< check if done >

		stepInternal();
	}

	protected final void stepInternal() {
		updateHeuristicValueAt(u);
		commitToMove(u);
	}

	protected final void updateHeuristicValueAt(uint u) {
		auto setOfSuccessors = getAdjacentNodeIndices(u);

		// value implementation gets the nTh value or the default value which is set with the constructor
		auto valueImplementation = scoped!(ValueImplementation!float)(infinity);
		foreach( v ;setOfSuccessors ) {
			valueImplementation ~= (h[v] + getWeightBetween(u, v));
		}

		h[u] = valueImplementation.calcValue();
	}

	protected final void commitToMove(uint u) {
		Tuple!(float, "rating", int "action") bestPair;
		bestPair.rating = infinity;
		bestPair.action = -1;

		auto setOfSuccessors = g.getAdjacentNodeIndices(u);
		foreach( v ;setOfSuccessors ) {
			float ratingForV = h[v] + getWeightBetween(u, v);
			if( ratingForV < bestPair.rating ) {
				bestPair.rating = ratingForV;
				bestPair.action = v;
			}
		}

		assert(bestPair.action != -1);

		// TODO< apply action >
	}

	protected final float getWeightBetween(uint a, uint b) {
		return g.getWeigthBetween(a, b);
	}

	protected final uint[] getAdjacentNodeIndices(uint u) {
		return g.getAdjacentNodeIndices(u);
	}


	//private float alpha;

	/*

	public final void evaluate(uint move, uint limit) {
		reset(move);

		for(;;) {
			if( open.isEmpty ) {
				return;
			}

			uint node = open.pop();

			expand node, for each children {
				g[child] = g[node] + calcMoveCost(node, child);
				f[child] = g[child] + h[child];

				pruneDepending(child);
			}
		}
	}

	protected final void pruneDepending(uint child) {
		if( f[child] < alpha ) {
			// TODO
		}
	}

	protected final void reset(uint move) {
		open = [move];
		float alpha = INF;
		f[move] = g[move] + h[move];


	}
	*/
}

// see
// "New Strategies in Learning Real Time Heuristic Search"
//    http://www.tzi.de/~edelkamp/publications/conf/aaai/Edelkamp97.pdf

// the difference of LTRA to RTA is that the first best value is taken
public class Lrta(ContentType) : GeneralizedRta(ValueImplementationFirstBest, ContentType) {
}
