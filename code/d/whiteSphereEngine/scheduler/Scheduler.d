module whiteSphereEngine.scheduler.Scheduler;

import std.algorithm.mutation : remove;
import core.sync.mutex : Mutex;

import whiteSphereEngine.scheduler.SchedulerSubsystem;
import whiteSphereEngine.scheduler.Task;


// TODO< move this to utilities >

import std.algorithm.searching : find;

size_t indexOf(Type)(Type[] a, Type b) {
return a.length - a.find(b).length;
}

unittest {
	assert(indexOf([1, 2], 1) == 0);
	assert(indexOf([1, 2], 2) == 1);

	assert(indexOf([4, 3, 5], 3) == 1);
}


/** \brief Schedueler which is running on one Core/Thread
 *
 */
class Scheduler {
	private Task []tasks;
	private bool inLoop = false;
	private Mutex sync;

	final this() {
		sync = new Mutex;
	}

	/** \brief do all work
	 *
	 * This Method do the work for all Tasks which are running
	 *
	 * \param ReturnCode indicates if some error happened
	 * \param ErrorDescription contains the Error message if an error happend
	 */
	final void doIt(out SchedulerSubsystem.EnumReturnCode ReturnCode, out string ErrorDescription) {
		foreach( iterationTask; tasks ) {
			Task.EnumTaskStates TaskState;
			uint Delay;

			iterationTask.doTask(this, Delay, TaskState);
		}

		// TODO
	}

	/** \brief adds Thread-safe a task to the Tasklist
	 *
	 * \param pTask the Task to add
	 * \param success was the adding successfull?
	 */
	final void addTaskSync(Task pTask, out bool success) {
		synchronized(sync) {
			success = false;

			tasks ~= pTask;
			
			success = true;
		}
	}

	/** \brief removes Thread-safe a task
	 *
	 * \param pTask the Task to remove
	 */
	final void removeTaskSync(Task pTask) {
		synchronized(sync) {
			tasks = tasks.remove(tasks.indexOf(pTask));
		}
	}
}
