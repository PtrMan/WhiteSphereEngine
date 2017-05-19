module whiteSphereEngine.ai.weak.qlearning.QLearning;

import common.ValueMatrix;
import std.random;

private alias float ScalarType;

// for debugging
import std.stdio;

struct QLearning {
	ValueMatrix!ScalarType
		q,
		r; // instant reward table

	ScalarType 
		alpha, // learning rate
		gamma; // discount factor

	alias uint StateType;

	StateType goalState;

	//alias ScalarType delegate(uint action, uint state) RewardFunctionType;
	//RewardFunctionType rewardFunction;

	final void resetQ() {
		foreach(i; 0..numberOfActions) foreach(j; 0..numberOfActions) {
			q[i, j] = 0;
		}
	}

	final void episode() {
		uint s = uniform(0, numberOfActions);

		while( s != goalState ) {
			// select one of the possible action
			
			
			

			// TODO< choose action after policy >
			//uint a = uniform(0, 6); // we choose an random action for testing

			// take action, observe reward and sTick
			uint a = uniform(0, numberOfActions);
			const ScalarType reward = r[a, s];
			

			const uint[] possibleNextActions = calcPossibleActionsOfState(a);
			uint sTick = possibleNextActions[uniform(0, possibleNextActions.length)];


			//uint sTick = uniform(0, numberOfActions); // for now we just observe a random sTick

			// see https://webdocs.cs.ualberta.ca/~sutton/book/ebook/node65.html
			// uses temporal difference learning conrol

			// http://www.cse.unsw.edu.au/~cs9417ml/RL1/algorithms.html
			// is the most correct
			q[a, s] = q[a, s] + alpha * (reward + gamma * maxQOverAllActions(sTick) - q[a, s]);

			s = sTick;
		}
	}

	private final ScalarType maxQOverAllActions(StateType state) {
		ScalarType maxQ = q[0, state];

		foreach( i; 1..numberOfActions ) {
			if( q[i, state] > maxQ ) {
				maxQ = q[i, state];
			}
		}

		//assert(maxQ >= 0.0f);

		return maxQ;
	}

	
	// TODO< this can be accelerated either via precomputation or a better datastructure >
	private final uint[] calcPossibleActionsOfState(uint state) {
		uint[] possibleActions;

		foreach( iterationAction; 0..numberOfActions ) {
			if( r[iterationAction, state] != -1 ) {
				possibleActions ~= iterationAction;
			} 
		}

		writeln(possibleActions);

		return possibleActions;
	}

	private final @property uint numberOfActions() pure {
		return q.width;
	}
}

// for testing the algorithm
void main() {
	float rewardFunction(uint action, uint state) {
		if( (state == 1 && action == 5) || (state == 4 && action == 5) ) {
			return -10.0f; // reward it for going outside
		}

		return -500.0f;
	}


	QLearning* qlearning = new QLearning;

	//qlearning.rewardFunction = &rewardFunction;

	qlearning.alpha = 0.8f; // learning rate
	qlearning.gamma = 0.1f; // discount factor
	qlearning.q = new ValueMatrix!float(6, 6);
	qlearning.r = new ValueMatrix!float(6, 6);
	// fill r with alues from the example
	foreach( i; 0..6 ) foreach(j; 0..6) {
		qlearning.r[i, j] = -1.0f;
	}
	qlearning.r[4, 0] = 0.0f;
	qlearning.r[3, 1] = 0.0f;
	qlearning.r[5, 1] = 100.0f;
	qlearning.r[3, 2] = 0.0f;
	qlearning.r[1, 3] = 0.0f;
	qlearning.r[2, 3] = 0.0f;
	qlearning.r[4, 3] = 0.0f;
	qlearning.r[0, 4] = 0.0f;
	qlearning.r[3, 4] = 0.0f;
	qlearning.r[5, 4] = 100.0f;
	qlearning.r[1, 5] = 0.0f;
	qlearning.r[4, 5] = 0.0f;
	qlearning.r[5, 5] = 100.0f;

	qlearning.resetQ();

	qlearning.goalState = 5;

	foreach( episode; 0..10000 ) {
		import std.stdio;
		writeln("ep#", episode);
		qlearning.episode();

	}

	// dump q matrix to console
	import std.stdio;

	foreach( y; 0..6 ) {
		foreach( x; 0..6 ) {
			write(qlearning.q[x, y], " ");
		}

		writeln();
	}
}
