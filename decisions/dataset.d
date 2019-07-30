module decisions.dataset;

import std.container.array;
import std.exception;
import std.typecons;
import std.conv;
import std.uuid;

import core.flatmap;
import decisions.feature;

struct Sample(T)
{
    Array!Feature features;
    T output;
}

class Dataset(T)
{
    Array!Sample samples;
    FlatMap!(UUID, Tag) tags;

    this()
    {
        tags = new FlatMap!(UUID, Tag)();
    }

    void add(ref Sample sample)
    {
        samples ~= sample;
        foreach (feature; sample.fatures)
        {
            tags[feature.tag.id] = feature.tag;
        }
    }

    Sample!T first() const
    {
        enforce(samples.length > 0);

        return samples[0];
    }

    bool any(bool delegate(ref Sample!T) predicate)
    {
        foreach (sample; samples)
        {
            if (predicate(sample))
            {
                return true;
            }
        }

        return false;
    }

    Array!U map(U)(U delegate(ref Sample!T) func)
    {
        Array!U mapped;
        mapped.reserve(samples.length);

        foreach (sample; samples)
        {
            mapped ~= func(sample);
        }

        return mapped;
    }

    Dataset!T filter(bool delegate(ref Sample!T) predicate)
    {
        auto that = new Dataset!T();

        foreach (sample; samples)
        {
            if (predicate(sample))
            {
                that.add(sample);
            }
        }

        return that;
    }
}
