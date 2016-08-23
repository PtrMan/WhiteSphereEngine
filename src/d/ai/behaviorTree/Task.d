module ai.behaviorTree.Task;

import ai.behaviorTree.EntityContext;

/** \brief is a task from the behaviour tree which does some AI related stuff
 *
 */
interface Task {
	enum EnumReturn {
		FINISHED,
		ERROR, // task ended with error, see ErrorMessage
		RUNNING, // should be called the next tick again
	}
	
	/** \brief is called from outer code and it executes the task
	 *
	 * \param Context the Context of the entity
	 * \param ErrorMessage if an error happened this will contain the error message
	 * \param ErrorDepth if an error happend this will give the depth in which the error happend
	 * \return Status code of the execution
	 */
	EnumReturn run(EntityContext context, ref string errorMessage, ref uint errorDepth);
	
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
