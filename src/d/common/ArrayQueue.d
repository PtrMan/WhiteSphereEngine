module common.ArrayQueue;

import std.algorithm.mutation : remove;

void enqueue(Type)(Type[] arr, Type element) {
	arr ~= element;
}

Type dequeue(Type)(Type[] arr) {
	Type result = arr[0];
	arr.remove(0);
}
