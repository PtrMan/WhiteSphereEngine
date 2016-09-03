module whiteSphereEngine.common.Blackboard;

import std.variant : Variant;

/**
 * Blackboard for communication
 *
 */
class Blackboard {
	/**
	 * updates the Value associated with the Key
	 *
	 * if the key doesn't exists it will added
	 *
	 * \param Key ...
	 * \param Value ...
	 */
	final void update(string key, Variant value) {
		dictionary[key] = value;
	}

	/**
	 * tries to return the data associated with the Key
	 * asserts if the Key is invalid 
	 *
	 * \param Key ...
	 * \return ...
	 */
	final Variant access(string key) {
		return dictionary[key];
	}

	Variant[string] dictionary;
}
