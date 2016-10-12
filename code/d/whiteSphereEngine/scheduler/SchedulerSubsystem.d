module whiteSphereEngine.scheduler.SchedulerSubsystem;

import whiteSphereEngine.scheduler.Scheduler;
import whiteSphereEngine.scheduler.Task;

/** \brief is the whole Schedueler fur concurrent tasks
 *
 */
class SchedulerSubsystem {
	private Scheduler MScheduler;

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
	 * \param ReturnCode indicates if some error happened
	 * \param ErrorDescription contains the Error message if an error happend
	 */
	final void doIt(out EnumReturnCode ReturnCode, out string ErrorDescription) {
		// TODO< start the work for all threads >

		scheduler.doIt(ReturnCode, ErrorDescription);
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
	 * \param Success was the adding successfull?
	 */
	final void addTaskSync(Task pTask, out bool success) {
		// TODO< for multiple threads >

		scheduler.addTaskSync(pTask, success);
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
