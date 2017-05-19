module world.ai.BehaviorTreeConstellationAi;

// TODO< move into own file >

import math.NumericSpatialVectors;
import math.VectorAlias;

struct TrajectoryInstruction {
	enum EnumType {
		WAIT,
		ACCELERATIONTODIRECTIONFORDURATION,
	}

	static TrajectoryInstruction makeWait(Ticks duration) {
		TrajectoryInstruction result;
		result.protectedType = EnumType.WAIT;
		result.protectedTiming = duration;
		return result;
	}

	// \param direction direction, has to be normalized
	static TrajectoryInstruction makeAccelerateToDirectionForTime(Vector3p direction, Ticks duration) {
		TrajectoryInstruction result;
		result.protectedType = EnumType.ACCELERATIONTODIRECTIONFORDURATION;
		result.protectedAccelerationDirection = direction;
		result.protectedTiming = duration;
		return result;
	}

	final @property EnumType type() {
		return protectedType;
	}

	final @property Ticks duration() {
		if( !(type == EnumType.WAIT && type == EnumType.ACCELERATIONTODIRECTIONFORDURATION) ) {
			throw new Exception("property duration requested for invalid type!");
		}

		return protectedTiming;
	}

	final @property Vector3p accelerationDirection() {
		if( type != EnumType.ACCELERATIONTODIRECTIONFORDURATION ) {
			throw new Exception("property accelerationDirection requested for invalid type!");
		}

		return protectedAccelerationDirection;
	}

	protected EnumType protectedType;

	protected Ticks protectedTiming;
	protected Vector3p protectedAccelerationDirection;
}



// Behaviour Tree nodes of a constelation(which is a group of ships)

import std.variant : Variant;

import whiteSphereEngine.common.Ticks;

import common.ArrayQueue;
import common.Array;
import ai.behaviorTree.Task : BehaviorTreeTask = Task;
import ai.behaviorTree.EntityContext;

class RecalcTrajectory : BehaviorTreeTask {
	BehaviorTreeTask.EnumReturn run(EntityContext parameterContext) {
		auto context = cast(EntityContextWithBlackboard)parameterContext;

		// TODO< do real calculations here >
		// push dummy values
		TrajectoryInstruction[] trajectoryInstructions;
		trajectoryInstructions ~= TrajectoryInstruction.makeWait(Ticks.makeHoursMinutesSeconds(0, 0, 5));
		trajectoryInstructions ~= TrajectoryInstruction.makeAccelerateToDirectionForTime(Vector3p.make(1.0, 0.0, 0.0), Ticks.makeHoursMinutesSecondsStandardTicks(0, 0, 50, 5));

		context.blackboard.update("trajectoryInstructionsQueue", Variant(trajectoryInstructions));

		return BehaviorTreeTask.EnumReturn.SUCCESS;
	}

	void reset() {
		
	}

	BehaviorTreeTask clone() {
		RecalcTrajectory clone = new RecalcTrajectory;
		return clone;
	}
}

import std.typecons : Nullable;

class PopTrajectoryInstructionAndExecute : BehaviorTreeTask {
	BehaviorTreeTask.EnumReturn run(EntityContext parameterContext) {
		auto context = cast(EntityContextWithBlackboard)parameterContext;

		if( !executingInstruction.isNull ) {
			return executeInstruction();
		}

		TrajectoryInstruction[] trajectoryInstructions = context.blackboard.access("trajectoryInstructionsQueue").get!(TrajectoryInstruction[]);
		if( trajectoryInstructions.isEmpty ) {
			return BehaviorTreeTask.EnumReturn.SUCCESS;
		}

		executingInstruction = trajectoryInstructions.dequeue();
		context.blackboard.update("trajectoryInstructionsQueue", Variant(trajectoryInstructions)); // update because its not an reference

		return BehaviorTreeTask.EnumReturn.RUNNING; // we have to return running
	}

	// has to set executingInstruction to null if it is done with it
	final protected BehaviorTreeTask.EnumReturn executeInstruction() {
		// TODO

		import std.stdio;
		// we just print it out
		import std.conv;

		writeln("PopTrajectoryInstructionAndExecute executeInstruction() type = ", executingInstruction.type.to!string);

		// we set it to null to indicate that the execution was done
		executingInstruction.nullify();

		return BehaviorTreeTask.EnumReturn.RUNNING;
	}

	void reset() {
		
	}

	BehaviorTreeTask clone() {
		PopTrajectoryInstructionAndExecute clone = new PopTrajectoryInstructionAndExecute;
		with(clone) {

		}
		return clone;
	}

	protected Nullable!TrajectoryInstruction executingInstruction;
}
