module decisions.id3;

import std.container.array;
import std.math;
import std.uuid;

import core.tree;
import decisions.dataset;
import decisions.feature;

class Id3(T)
{
    struct Node
    {
        enum Type
        {
            Tag,
            Feature,
            Leaf
        }

        Type type;
        union
        {
            Tag tag;
            Feature feature;
            Array!T* outputs;
        }
    }

    this()
    {
    }

    static double entropy(Array!Feature features)
    {
        double[UUID] probs;

        foreach (feature; features)
        {
            if (feature.id !in probs)
            {
                probs[feature.id] = 0;
            }
            probs[feature.id] += 1;
        }

        foreach (id; probs.byKey())
        {
            probs[id] /= features.length;
        }

        double sum = 0;
        foreach (probability; probs)
        {
            sum += -probability * log(probability) / LN2;
        }

        return sum;
    }
}
