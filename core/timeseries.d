module core.timeseries;

import std.container.array;
import std.datetime.date;
import std.typecons;
import std.conv;
import core.arrays;

class TimeSeries(T)
{
	Array!DateTime dates;
	Array!T items;

	this()
	{
		dates = Array!DateTime();
		items = Array!T();
	}

	@property Tuple!(DateTime, T) first()
	{
		assert(!items.empty());

		return tuple(dates[0], items[0]);
	}

	@property Tuple!(DateTime, T) last()
	{
		assert(!items.empty());

		return tuple(dates[$ - 1], items[$ - 1]);
	}

	@property int length() const
	{
		return to!int(items.length());
	}

	void append(DateTime date, T item)
	{
		if (length() > 0 && date < dates[$ - 1])
		{
			throw new Exception("'date' should be < " ~ dates[$ - 1].toString());
		}

		dates.insert(date);
		items.insert(item);
	}

	void insert(DateTime date, T item)
	{
		int index = lowerBound(dates, date);

		if (index >= 0 && index < length() && date == dates[index])
		{
			dates[index] = date;
			items[index] = item;
		}
		else
		{
			dates.insertAfter(dates[index..index], date);
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