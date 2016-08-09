module memory.FreeList;

import std.algorithm.mutation : remove;

// simple implementation of freelist with a array
// a freelist is described here https://en.wikipedia.org/wiki/Free_list
struct FreeList(Type) {
	protected Type[] list;
	
	public final Type allocate(out bool isEmpty) {
		isEmpty = list.length == 0;
		if( isEmpty ) {
			return Type.init;
		}
		
		Type topElement = list[$];
		list.length--;
		
		return topElement;
	}
	
	public final void free(Type value) {
		addToList(value);
	}
	
	public enum EnumAllocateWhereResult {
		FOUND,
		COULDNTFIND,
		ISEMPTY
	}
	
	public final Type allocateWhere(CheckValueType)(bool function(Type value, CheckValueType) condition, CheckValueType value, out EnumAllocateWhereResult result) {
		result = EnumAllocateWhereResult.COULDNTFIND;
		
		bool isEmpty = list.length == 0;
		if( isEmpty ) {
			result = EnumAllocateWhereResult.ISEMPTY;
			return Type.init;
		}
		
		foreach( i, iterationValue; list ) {
			if( condition(iterationValue, value) ) {
				list.remove(i);
				
				result = EnumAllocateWhereResult.FOUND;
				return iterationValue;
			}
		}
		
		result = EnumAllocateWhereResult.COULDNTFIND;
		return Type.init;
	}
	
	// used to fill the Freelist
	public final void initAddAsFree(Type[] values) {
		foreach( iterationValue; values ) {
			addToList(iterationValue);
		}
	}
	
	protected final void addToList(Type value) {
		list ~= value;
	}
}

