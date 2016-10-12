module whiteSphereEngine.scheduler.SchedulerSubsystem;

import whiteSphereEngine.scheduler.Scheduler;
import whiteSphereEngine.scheduler.Task;

/** \brief is the whole Schedueler fur concurrent tasks
 *
 */
class SchedulerSubsystem {
	private Scheduler scheduler;

	enum EnumReturnCode {
		DUMMY // TODO
	}

	final this() {
		// TODO< for multiple threads >

		scheduler = new Scheduler();
	}

	/** \brief do all work
	 *
	 * This Method pokes the doIt Method of all Threads/Cores and waits until all exited
	 *
	 */
	final void doIt() {
		// TODO< start the work for all threads >

		scheduler.doIt();
	}

	/** \brief ...
	 */
	final bool startUp() {
		// TODO
		return true;
	}

	/** \brief ...
	 */
	final void shutDown() {
		// TODO
	}

	/** \brief adds Thread-safe a task to the Tasklist
	 *
	 * \param PTask the Task to add
	 */
	final void addTaskSync(Task pTask) {
		// TODO< for multiple threads >

		scheduler.addTaskSync(pTask);
	}

	/** \brief removes Thread-safe a task
	 *
	 * \param PTask the Task to remove
	 */
	final void removeTaskSync(Task pTask) {
		// TODO< for multiple threads >

		scheduler.removeTaskSync(pTask);
	}
}
