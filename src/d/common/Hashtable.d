module Hashtable;

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

	final this(uint function(Type element) calcHash) {
		this.calcHash = calcHash;
	}

	final public void insert(Type element) {
		uint hashForElement = calcHash(element);
		uint bucketIndex = hashForElement % Buckets;
		buckets[bucketIndex].content ~= new BucketElement(element, hashForElement);
	}

	final public bool contains(Type element) {
		uint hashForElement = calcHash(element);
		uint bucketIndex = hashForElement % Buckets;
		
		foreach( BucketElement iterationBucketElement; buckets[bucketIndex].content ) {
			if( iterationBucketElement.hash == hashForElement && iterationBucketElement.element.isEqual(element) ) {
				return true;
			}
		}

		return false;
	}

	protected Bucket[Buckets] buckets;
	protected uint function(Type element) calcHash;
}
