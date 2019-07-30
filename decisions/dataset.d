module decisions.dataset;

import core.lifetime;
import std.container.array;
import std.exception;
import std.typecons;
import std.conv;
import std.uuid;

import core.flatmap;
import decisions.feature;

class Sample(T)
{
    Array!Feature features;
    T output;

    this(Array!Feature features, T output)
    {
        this.features = features;
        this.output = output;
    }

    Feature opIndex(ref const Tag tag)
    {
        foreach (feature; features)
        {
            if (feature.tag.id == tag.id)
            {
                return feature;
            }
        }

        throw new Exception("tag not found");
    }
}

class Dataset(T)
{
    Array!(Sample!T) samples;
    FlatMap!(UUID, Tag) tags;

    this()
    {
        tags = new FlatMap!(UUID, Tag)();
    }

    void add(Sample!T sample)
    {
        samples ~= sample;
        foreach (feature; sample.features)
        {
            tags[feature.tag.id] = feature.tag;
        }
    }

    @property Sample!T first()
    {
        enforce(samples.length > 0);

        return samples[0];
    }

    @property bool empty()
    {
        return samples.empty;
    }

    @property size_t length()
    {
        return samples.length;
    }

    bool any(bool delegate(Sample!T) predicate)
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

    Array!U map(U)(U delegate(Sample!T) func)
    {
        Array!U mapped;
        mapped.reserve(samples.length);

        foreach (sample; samples)
        {
            mapped ~= func(sample);
        }

        return move(mapped);
    }

    Dataset!T filter(bool delegate(Sample!T) predicate)
    {
        auto that = new Dataset!T();

        foreach (sample; samples)
        {
            if (predicate(sample))
            {
                that.add(sample);
            }
        }

        return move(that);
    }
}
