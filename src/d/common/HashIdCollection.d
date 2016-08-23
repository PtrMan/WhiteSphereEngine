module common.HashIdCollection;

import common.Hashtable;

class HashIdCollection(Type) {
	protected static uint hashById(ulong id) {
		return cast(uint)(id | (id >> 32));
	}
	
	protected static uint hashFunction(Type value) {
		return hashById(value.id);
	}

	
	final this() {
		hashtable = new typeof(hashtable)(&hashFunction);
	}
	
	// lookup hashtable and return if found
	final Type getById(ulong id, out bool found) {
		uint hash = hashById(id);
		Type[] hashResult = hashtable.get(id);
		assert(hashResult.length <= 1, "Multiple objects were associated with one id, this is invalid");
		found = hashResult.length > 0;
		if( !found ) {
			return Type.init;
		}
		return hashResult[0];
	}
	
	final Type getByIdMust(ulong id) {
		bool calleeSuccess;
		Type result = getById(id, calleeSuccess);
		if( !calleeSuccess ) {
			throw new EngineError(false, true, "Object by id was not found but must be found!");
		}
	}
	
	final void addElement(Type element) {
		hashtable.insert(element);
	}
	
	protected const uint NUMBEROFHASHTABLEBUCKETS = 64;
	protected Hashtable!(Type, NUMBEROFHASHTABLEBUCKETS) hashtable;
}
