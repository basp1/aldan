module core.flatmap;

import std.container.array;
import std.typecons;
import std.conv;
import core.arrays;

class FlatMap(Key, Value)
{
	Array!Key keys;
	Array!Value values;

	this()
	{
		keys = Array!Key();
		values = Array!Value();
	}

	@property bool empty() const
	{
		return keys.empty();
	}

	@property int length() const
	{
		return to!int(keys.length());
	}

	@property int capacity()
	{
		return to!int(keys.capacity());
	}

	void reserve(int capacity)
	{
		keys.reserve(capacity);
		values.reserve(capacity);
	}

	void clear()
	{
		keys.clear();
		values.clear();
	}

	bool contains(Key key)
	{
		Value value = Value.init;
		return find(key, value);
	}

	Value get(Key key)
	{
		Value value = Value.init;

		if (!find(key, value))
		{
			throw new Exception("'key' not found");
		}

		return value;
	}

	void insert(Key key, Value value)
	{
		int index = lowerBound(keys, key);

		if (index >= 0 && index < length && key == keys[index])
		{
			keys[index] = key;
			values[index] = value;
		}
		else
		{
			keys.insertAfter(keys[index..index], key);
			values.insertAfter(values[index..index], value);
		}
	}

	void remove(Key key)
	{
		int index = lowerBound(keys, key);

		if (index >= 0 && index < length && key == keys[index])
		{
			keys.linearRemove(keys[index..index+1]);
			values.linearRemove(values[index..index+1]);
		}
	}

	Value opIndex(Key key)
	{
		return get(key);
	}

	void opIndexAssign(Value value, Key key)
	{
		insert(key, value);
	}

	bool find(Key key, ref Value value)
	{
		int index = lowerBound(keys, key);

		if (index >= 0 && index < length() && key == keys[index])
		{
			value = values[index];
			return true;
		}

		return false;
	}
}

unittest
{
	auto map = new FlatMap!(int, char)();

	map[1] = 'a';
	map[5] = 'e';
	map[3] = 'c';

	assert(3 == map.length);
	assert('a' == map[1]);
	assert('c' == map[3]);
	assert('e' == map[5]);

	map[2] = 'b';
	map[4] = 'd';
	assert(5 == map.length);
	assert('a' == map[1]);
	assert('b' == map[2]);
	assert('c' == map[3]);
	assert('d' == map[4]);
	assert('e' == map[5]);

	map[4] = 'D';
	assert(5 == map.length);
	assert('a' == map[1]);
	assert('b' == map[2]);
	assert('c' == map[3]);
	assert('D' == map[4]);
	assert('e' == map[5]);
}

unittest
{
	auto map = new FlatMap!(int, char)();

	map[1] = 'a';
	map[5] = 'e';
	map[3] = 'c';
	map[2] = 'b';
	map[4] = 'd';

	map.remove(3);
	assert(4 == map.length);
	assert('a' == map[1]);
	assert('b' == map[2]);
	assert('d' == map[4]);
	assert('e' == map[5]);
	assert(!map.contains(3));

	map.remove(1);
	map.remove(4);
	map.remove(5);
	assert(1 == map.length);
	assert('b' == map[2]);
	assert(!map.contains(3));
	assert(!map.contains(1));
	assert(!map.contains(4));
	assert(!map.contains(5));
}