module core.timeseries;

import std.container.array;
import std.datetime.date;
import std.datetime.interval;
import std.exception;
import std.typecons;
import std.conv;
import core.arrays;

class TimeException : Exception
{
	this(string message, string file = __FILE__, size_t line = __LINE__)
	{
		super(message, file, line);
	}
}

class TimeSeries(T)
{
	alias Time = DateTime;

	Array!Time times;
	Array!T items;

	this()
	{
		times = Array!Time();
		items = Array!T();
	}

	@property Tuple!(Time, T) first()
	{
		enforce(!items.empty());

		return tuple(times[0], items[0]);
	}

	@property Tuple!(Time, T) last()
	{
		enforce(!items.empty());

		return tuple(times[$ - 1], items[$ - 1]);
	}

	@property int length() const
	{
		return to!int(items.length());
	}

	void append(Time time, T item)
	{
		if (length() > 0 && time < times[$ - 1])
		{
			throw new TimeException("'time' should be < " ~ times[$ - 1].toString());
		}

		times.insert(time);
		items.insert(item);
	}

	void insert(Time time, T item)
	{
		int index = lowerBound(times, time);

		if (index >= 0 && index < length() && time == times[index])
		{
			times[index] = time;
			items[index] = item;
		}
		else
		{
			times.insertAfter(times[index..index], time);
			items.insertAfter(items[index..index], item);
		}
	}
}

unittest
{
	auto ts = new TimeSeries!int();
	
	assert(0 == ts.length());

	ts.append(DateTime(2000, 3, 17, 10, 30, 0), 1);
	assert(1 == ts.length());

	ts.append(DateTime(2000, 3, 17, 10, 31, 0), 2);
	assert(2 == ts.length());
}