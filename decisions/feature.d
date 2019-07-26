module decisions.feature;

import std.math;
import std.uuid;

struct Tag
{
	string name;
	UUID id;

	this(string name)
	{
		id = randomUUID();
		this.name = name;
	}
}

struct Feature
{
	UUID id;
	string name;
    double spanBegin;
    double spanEnd;

    this(string name, double spanBegin, double spanEnd)
	{
		id = randomUUID();
        this.name = name;
        this.spanBegin = spanBegin;
        this.spanEnd = spanEnd;
    }

    double distance(double value)
	{
        if (value > spanBegin && value < spanEnd)
		{
            return 0;
        }
		else
		{
            return fmin(abs(value - spanBegin), abs(value - spanEnd));
        }
    }
}