module ai.behaviorTree.EntityContext;

/** \brief Class that tells the behavior tree something about the context of usage, contains needed variables
 *
 */
abstract class EntityContext {
	protected final this(string type) {
		this.projectedType = type;
	}
	
	pure final @property string type() {
		return projectedType;
	}
	
	private string projectedType;
}

import whiteSphereEngine.common.Blackboard;

abstract class EntityContextWithBlackboard : EntityContext {
	Blackboard blackboard = new Blackboard;
}
