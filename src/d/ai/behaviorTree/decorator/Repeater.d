module ai.bahaviorTree.decorator.Repeater;

import ai.behaviorTree.Task;

/**
 * Repeats until a number of repetitions got done or until the child failed or a combination of both conditions.
 */
class Repeater : Task {
	Task children;

	int counterResetValue = -1; 
	int remainingCounter = 0;
	bool repeatUntilFail = false;

	Task.EnumReturn run(EntityContext context) {
		Task.EnumReturn calleeReturn = children.run(context, errorMessage, errorDepth);

		with( Task.EnumReturn ) {
			if( calleeReturn == FAILURE && repeatUntilFail ) {
				return Task.EnumReturn.SUCCESS;
			}

			if( calleeReturn != RUNNING && !runsInfinitly ) {
				remainingCounter--;

				if( remainingCounter <= 0 ) {
					return calleeReturn;
				}
			}
		}
	}

	/** \brief resets the variables to its defaults
	 *
	 */
	void reset() {
		remainingCounter = counterResetValue;
	}
	
	/** \brief is cloning the objeect on which it got called
	 *
	 * \return ...
	 */
	Task clone() {
		Repeater clone = new Repeater();
		clone.children = children.clone();
		clone.counterResetValue = counterResetValue;
		clone.remainingCounter = remainingCounter;
		clone.repeatUntilFail = repeatUntilFail;
		return clone;
	}

	final @property bool runsInfinitly() {
		return counterResetValue == -1;
	}
}