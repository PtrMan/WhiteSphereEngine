module Array;

// from ProjectSci

// TODO< contract >

/** \brief removes element at index Index from array
 *
 * \param array is the array
 * \param Index the index from that a element 
 * \return array without Elment
 */
Type[] removeAt(Type)(Type[] array, uint Index) {
   if( array.length == 0 ) {
      // error
      return [];
   }

   if( array.length == 1 ) {
      return [];
   }

   Type[] output = array;

   for( uint i = Index; i < array.length-1; i++ ) {
      output[i] = output[i+1];
   }

   output.length -= 1;

   return output;
}

/** \brief tries to find searchFor, if it was found return the index of it
 *
 * \param array ...
 * \param searchFor ...
 * \param found is true if searchFor was found
 * \return ...
 */
uint findIn(Type)(Type[] array, Type searchFor, out bool found) {
	uint Index;

	Index = 0;
	found = false;

	foreach( Type element; array ) {
		if( element == searchFor ) {
			found = true;
			return Index;
		}

		Index++;
	}

	return 0;
}