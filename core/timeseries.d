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

    void add(Time time, T item)
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
            times.insertAfter(times[index .. index], time);
            items.insertAfter(items[index .. index], item);
        }
    }

    Tuple!(Time, T) get(Time time)
    {
        int index = lowerBound(times, time);

        enforce!DateTimeException(index >= 0 && index < length());

        return tuple(times[index], items[index]);
    }

    bool getExact(Time time, ref T item)
    {
        auto x = get(time);

        if (x[0] != time)
        {
            return false;
        }
        else
        {
            item = x[1];
            return true;
        }
    }

    typeof(this) interval(Interval!Time interval)
    {
        auto ts = new TimeSeries!T();

        int index = lowerBound(times, interval.begin());

        int n = length();
        for (int i = index; i < n && times[i] < interval.end(); i++)
        {
            ts.insert(times[i], items[i]);
        }

        return ts;
    }
}

unittest
{
    auto ts = new TimeSeries!int();

    assert(0 == ts.length());

    auto time1 = DateTime(2000, 3, 17, 10, 30, 0);
    {
        ts.add(time1, 10);

        assert(1 == ts.length());
        assert(10 == ts.get(time1)[1]);

        int x;
        assert(ts.getExact(time1, x));
        assert(10 == x);

        auto t = time1;
        t.roll!"minutes"(-1);
        assert(10 == ts.get(t)[1]);

        assert(!ts.getExact(t, x));
    }

    auto time2 = DateTime(2000, 3, 17, 10, 31, 0);
    {
        ts.add(time2, 20);

        assert(2 == ts.length());
        assert(20 == ts.get(time2)[1]);

        int x;
        assert(ts.getExact(time2, x));
        assert(20 == x);

        auto t = time1;
        t.roll!"seconds"(25);
        assert(20 == ts.get(t)[1]);

        assert(!ts.getExact(t, x));
    }
}
