module whiteSphereEngine.scheduler.Task;

import whiteSphereEngine.scheduler.Scheduler;

/** \brief Is a task that can run on any CPU/Thread in the System parallel to other Tasks
 *
 */
abstract Task {
	protected bool isCurrentTaskProtected = false;

	enum EnumTaskStates {
		FINISHED, // this will be returned if the task did termintate itself
		RUNNING, // this will be returned if the task should be restarted in this frame
		WAITNEXTFRAME // this will be returned if this task should be executed again in the next frame
	}

	/* pure virtual */ abstract void doTask(ref Scheduler PScheduler, out uint Delay, out EnumTaskStates State);

	/** \brief sets if the Task is the current Task
    *
    * \param CurrentTask ...
    */
	final @property bool isCurrentTask(bool value) {
		isCurrentTaskProtected = value;
	}

	/** \brief gets if the Task is the current Task
	 *
	 * \return ...
	 */
	final @property bool isCurrentTask() {
		return isCurrentTaskProtected;
	}
}
