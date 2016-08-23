module ai.behaviorTree.EntityContext;

/** \brief Class that tells the behavior tree something about the context of usage, contains needed variables
 *
 */
abstract class EntityContext {
	protected final this(string type) {
		this.type = type;
	}
	
	pure final @property string type() {
		return projectedType;
	}
	
	private string projectedType;
}
