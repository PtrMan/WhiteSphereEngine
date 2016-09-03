module ai.behaviorTree.Task;

import ai.behaviorTree.EntityContext;

/** \brief is a task from the behaviour tree which does some AI related stuff
 *
 */
interface Task {
	enum EnumReturn {
		SUCCESS,
		FAILURE,
		RUNNING, // should be called the next tick again
	}
	
	/** \brief is called from outer code and it executes the task
	 *
	 * \param Context the Context of the entity
	 * \return Status code of the execution
	 */
	EnumReturn run(EntityContext context);
	
	/** \brief resets the variables to its defaults
	 *
	 */
	void reset();
	
	/** \brief is cloning the objeect on which it got called
	 *
	 * \return ...
	 */
	Task clone();
	
	/** \brief returns the minmal ticks between updates
	 *
	 * \return ...
	 */
	final uint getRefreshtimeInTicks() {
		// TODO< add a variable for this >
		return 1;
	}
}
