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
	private Task[] tasks;
	private bool inLoop = false;
	private Mutex sync;

	final this() {
		sync = new Mutex;
	}

	/** \brief do all work
	 *
	 * This Method do the work for all Tasks which are running
	 *
	 */
	final void doIt() {
		foreach( iterationTask; tasks ) {
			Task.EnumTaskStates taskState;
			uint delay;

			iterationTask.doTask(this, delay, taskState);
		}

		// TODO
	}

	/** \brief adds Thread-safe a task to the Tasklist
	 *
	 * \param pTask the Task to add
	 */
	final void addTaskSync(Task pTask) {
		synchronized(sync) {
			tasks ~= pTask;
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
