module helpers.Unique;

Type[] calcUnique(Type)(Type[] input) {
	Type[] result;
	
	foreach( iterationInput; input ) {
		bool alreadyContained = false;
		foreach( iterationResult; result ) {
			if( iterationResult is iterationInput ) {
				alreadyContained = true;
				break;
			}
		}
		
		if( !alreadyContained ) {
			result ~= iterationInput;
		}
	}
	
	return result;
}
