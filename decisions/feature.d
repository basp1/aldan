module decisions.feature;

import std.math;

struct Tag
{
	int id;
}

struct Feature
{
	string name;
    double spanBegin;
    double spanEnd;

    this(string name, double spanBegin, double spanEnd)
	{
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