module decisions.feature;

import std.exception;
import std.math;
import std.uuid;

import core.flatmap;

class Tag
{
    UUID id;
    string name;
    FlatMap!(UUID, Feature) features;

    this(string name)
    {
        id = randomUUID();
        features = new FlatMap!(UUID, Feature)();
        this.name = name;
    }

    void add(Feature feature)
    {
        enforce(!features.contains(feature.id));

        features[feature.id] = feature;
    }
}

class Feature
{
    UUID id;
    string name;
    Tag tag;
    double spanBegin;
    double spanEnd;

    this(Tag tag, string name, double spanBegin, double spanEnd)
    {
        id = randomUUID();
        this.tag = tag;
        this.name = name;
        this.spanBegin = spanBegin;
        this.spanEnd = spanEnd;

        tag.add(this);
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
