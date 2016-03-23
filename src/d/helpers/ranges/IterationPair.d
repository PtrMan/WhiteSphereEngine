module helpers.ranges.ForwardPair;

static struct Pair(Type) {
	this(Type first, Type second) {
		this.first = first;
		this.second = second;
	}
	
	public Type first;
	public Type second;
}

// creates pairs of the neightbor elements with warparound
auto forwardPair(InputRange)(InputRange data) pure nothrow
{
    static struct ForwardPair {
        InputRange r;
        uint currentIndex = 0;
        
        @property bool empty() {
        	return currentIndex == r.length;
        }
        @property auto front() {
            return Pair!(typeof(r[currentIndex]))(r[currentIndex], r[(currentIndex+1)%r.length]);
        }
        void popFront() {
            currentIndex++;
        }
    }
    return ForwardPair(data);
}


// creates pairs of the neightbor elements with warparound
auto backwardPair(InputRange)(InputRange data) pure nothrow
{
    static struct BackwardPair {
        InputRange r;
        uint currentIndex = 0;
        
        @property bool empty() {
        	return currentIndex == r.length;
        }
        @property auto front() {
            return Pair!(typeof(r[currentIndex]))(r[(currentIndex-1 + r.length) %r.length], r[currentIndex]);
        }
        void popFront() {
            currentIndex++;
        }
    }
    return BackwardPair(data);
}

unittest {
	import std.array : array;
	
	int[] data = [0,5,3];
	
	Pair!(int)[] paired = array(forwardPair(data));
	
	assert(paired.length == 3);
	
	assert(paired[0].first == 0);
	assert(paired[0].second == 5);
	
	assert(paired[1].first == 5);
	assert(paired[1].second == 3);
	
	assert(paired[2].first == 3);
	assert(paired[2].second == 0);
}