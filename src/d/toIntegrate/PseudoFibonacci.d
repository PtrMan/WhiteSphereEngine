module PseudoFibonacci;

// is a fibonacci like algrithm for the controled generation of random numbers
// the algorithm add the last two values and truncates the result

// described at http://www.theguardian.com/books/2003/oct/18/features.weekend
struct PseudoFibonacciState {
	uint a;
	uint b;
	
	uint mod;
	
	final public uint generateNext() {
		uint next = (a+b) % mod;
		a = b;
		b = next;
		
		return next;
	}
	
	final public uint[] generateNextN(uint n) {
		uint[] result;
		
		foreach( uint i; 0..n ) {
			result ~= generateNext();
		}
		
		return result;
	}
}
