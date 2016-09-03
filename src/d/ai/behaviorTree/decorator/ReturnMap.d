module ai.bahaviorTree.decorator.ReturnMap;

import ai.behaviorTree.Task;

class ReturnMap : Task {
	Task children;

	Task.EnumReturn mapSuccess;
	Task.EnumReturn mapFailure;
	Task.EnumReturn mapRunning;

	Task.EnumReturn run(EntityContext context) {
		Task.EnumReturn calleeReturn = children.run(context, errorMessage, errorDepth);
		final switch( calleeReturn ) with (Task.EnumReturn) {
			case SUCCESS: return mapSuccess;
			case FAILURE: return mapFailure;
			case RUNNING: return mapRunning;
		}
	}

	void reset() {
	}
	
	Task clone() {
		ReturnMap clone = new ReturnMap;
		clone.children = children.clone();
		clone.mapSuccess = mapSuccess;
		clone.mapFailure = mapFailure;
		clone.mapRunning = mapRunning;
		return clone;
	}

	// makes a succeeder node, returns always success even if it failed
	static ReturnMap makeSucceeder(Task children) {
		ReturnMap result = new ReturnMap;
		result.children = children;
		with (Task.EnumReturn) {
			result.mapSuccess = SUCCESS;
			result.mapFailure = SUCCESS;
			result.mapRunning = RUNNING;
		}
		return result;
	}

	// makes a inverter node, returns failiure on success and vice versa
	static ReturnMap makeInverter(Task children) {
		ReturnMap result = new ReturnMap;
		result.children = children;
		with (Task.EnumReturn) {
			result.mapSuccess = FAILURE;
			result.mapFailure = SUCCESS;
			result.mapRunning = RUNNING;
		}
		return result;
	}
}
