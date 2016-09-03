module ai.behaviorTree.Sequence;

import ai.behaviorTree.EntityContext;
import ai.behaviorTree.Task;

class Sequence : Task {
	public Task[] children;
	
	final @property bool infinite(bool newInfinite) {
		return privateInfinite = newInfinite;
	}
	
	final Task.EnumReturn run(EntityContext context) {
		if( children.length == 0 ) {
			// uncommented because its old code, and we want to still have the information errorMessage = "this.Childrens does have a length of 0!";
			// uncommented because its old code, and we want to still have the information errorDepth = 0;
			return Task.EnumReturn.FAILURE;
		}
		
		for(;;) {
			if( currentIndex >= children.length ) {
				currentIndex = 0;
				
				if( !privateInfinite ) {
					return Task.EnumReturn.SUCCESS;
				}
			}
			
			Task.EnumReturn calleeReturn = children[currentIndex].run(context, errorMessage, errorDepth);
			
			if( calleeReturn == Task.EnumReturn.SUCCESS ) {
				// was already commented, dunno why
				//return Task.EnumReturn.SUCCESS;
			}
			else if( calleeReturn == Task.EnumReturn.FAILURE ) {
				// uncommented because its old code, and we want to still have the information errorDepth++;
				return Task.EnumReturn.FAILURE;
			}
			else {// Task.EnumReturn.RUNNING
				return Task.EnumReturn.RUNNING;
			}
			
			currentIndex++;
		}
	}
	
	final void reset() {
		currentIndex = 0;
		
		foreach( Task iterationChildren; children ) {
			iterationChildren.reset();
		}
	}
	
	final Task clone() {
		Sequence clonedSequence;
		
		clonedSequence = new Sequence();
		clonedSequence.currentIndex = currentIndex;
		clonedSequence.privateInfinite = privateInfinite;
		
		foreach( Task iterationChildren; children ) {
			clonedSequence.children ~= iterationChildren.clone();
		}
		
		return clonedSequence;
	}
	
	private uint currentIndex = 0;
	private bool privateInfinite = false;
}
