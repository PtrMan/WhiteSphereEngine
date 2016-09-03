module ai.bahaviorTree.decorator.ReturnMap;

import ai.behaviorTree.Task;

class ReturnMap : Task {
	Task children;

	Task.EnumReturn mapSuccess;
	Task.EnumReturn mapError;
	Task.EnumReturn mapRunning;

	Task.EnumReturn run(EntityContext context, ref string errorMessage, ref uint errorDepth) {
		Task.EnumReturn calleeReturn = children.run(context, errorMessage, errorDepth);
		final switch( calleeReturn ) with (Task.EnumReturn) {
			case SUCCESS: return mapSuccess;
			case ERROR: return mapError;
			case RUNNING: return mapRunning;
		}
	}

	void reset() {
	}
	
	Task clone() {
		ReturnMap clone = new ReturnMap;
		clone.children = children.clone();
		clone.mapSuccess = mapSuccess;
		clone.mapError = mapError;
		clone.mapRunning = mapRunning;
		return clone;
	}

	// makes a succeeder node, returns always success even if it failed
	static ReturnMap makeSucceeder(Task children) {
		ReturnMap result = new ReturnMap;
		result.children = children;
		with (Task.EnumReturn) {
			result.mapSuccess = SUCCESS;
			result.mapError = SUCCESS;
			result.mapRunning = RUNNING;
		}
		return result;
	}

	// makes a inverter node, returns failiure on success and vice versa
	static ReturnMap makeInverter(Task children) {
		ReturnMap result = new ReturnMap;
		result.children = children;
		with (Task.EnumReturn) {
			result.mapSuccess = ERROR;
			result.mapError = SUCCESS;
			result.mapRunning = RUNNING;
		}
		return result;
	}
}
