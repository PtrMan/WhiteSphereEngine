module common.Hashtable;

class Hashtable(Type, uint Buckets) {
	protected static struct Bucket {
		public BucketElement[] content;
	}

	protected static class BucketElement {
		public final this(Type element, uint hash) {
			this.element = element;
			this.hash = hash;
		}

		public Type element;
		public uint hash;
	}
	
	public alias uint function(Type element) HashFunctionType;

	final this(HashFunctionType hashFunction) {
		this.protectedHashFunction = hashFunction;
	}

	final public void insert(Type element) {
		uint hashForElement = protectedHashFunction(element);
		uint bucketIndex = hashForElement % Buckets;
		buckets[bucketIndex].content ~= new BucketElement(element, hashForElement);
	}

	final public bool contains(Type element) {
		uint hashForElement = protectedHashFunction(element);
		uint bucketIndex = hashForElement % Buckets;
		
		foreach( BucketElement iterationBucketElement; buckets[bucketIndex].content ) {
			if( iterationBucketElement.hash == hashForElement && iterationBucketElement.element.isEqual(element) ) {
				return true;
			}
		}

		return false;
	}
	
	final public Type[] get(uint hash) {
		Type[] result;
		
		uint bucketIndex = hash % Buckets;
		
		foreach( BucketElement iterationBucketElement; buckets[bucketIndex].content ) {
			if( iterationBucketElement.hash == hash ) {
				result ~= iterationBucketElement.element;
			}
		}
		
		return result;
	}
	
	// uncommented because its not used, code is fine
	//final public @property HashFunctionType hashFunction() {
	//	return protectedHashFunction;
	//}

	protected Bucket[Buckets] buckets;
	protected HashFunctionType protectedHashFunction;
}
