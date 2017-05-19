module ArrayStack;

// functions to handle an array as a stack

void push(Type)(ref Type[] arr, Type value) {
	arr ~= value;
}

Type pop(Type)(ref Type[] arr) {
	Type topValue = arr.top();
	arr.length--;
	return topValue;
}

Type top(Type)(Type[] arr) {
	assert(arr.length > 0);
	return arr[$-1];
}
