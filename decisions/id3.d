module decisions.id3;

import std.container.array;
import std.math;
import std.uuid;

import core.arrays;
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

        this(Type type, Tag tag)
        {
            this.type = type;
            this.tag = tag;
        }

        this(Type type, Feature feature)
        {
            this.type = type;
            this.feature = feature;
        }

        this(Type type, Array!T* outputs)
        {
            this.type = type;
            this.outputs = outputs;
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

    Tree!Node build(Dataset!T dataset)
    {
        auto tree = new Tree!Node();

        build(dataset, dataset.tags.values, tree, tree.root);

        return tree;
    }

    void build(Dataset!T dataset, Array!Tag tags, Tree!Node tree, Tree!Node.Id parent)
    {
        auto first = dataset.first.output;

        bool allTheSame = !dataset.any(sample => first != sample.output);
        if (allTheSame)
        {
            auto outputs = dataset.map(sample => sample.output);
            tree.add(parent, Node(Node.Type.Leaf, &outputs));

            return;
        }

        Tag winner = null;
        double min = double.max;
        foreach (tag; tags)
        {
            double metric = entropy(dataset.map(sample => sample[tag]));
            if (metric > 0 && metric < min)
            {
                winner = tag;
                min = metric;
            }
        }

        if (null is winner)
        {
            auto outputs = dataset.map(sample => sample.output);
            tree.add(parent, Node(Node.Type.Leaf, &outputs));
        }
        else
        {
            auto node = tree.add(parent, Node(Node.Type.Tag, winner));

            foreach (feature; winner.features.values)
            {
                auto sucDataset = dataset.filter(sample => sample[winner] == feature);

                Array!Tag sucTags;
                foreach (tag; tags)
                {
                    if (tag != winner)
                    {
                        sucTags ~= tag;
                    }
                }

                if (sucDataset.empty)
                {
                    continue;
                }

                auto suc = tree.add(node, Node(Node.Type.Feature, feature));

                build(sucDataset, sucTags, tree, suc);
            }
        }
    }
}

unittest
{
    auto outlook = new Tag("Outlook");
    auto sunny = new Feature(outlook, "sunny", 0);
    auto overcast = new Feature(outlook, "overcast", 1);
    auto rainy = new Feature(outlook, "rainy", 2);

    auto temp = new Tag("Temp");
    auto cool = new Feature(temp, "cool", -100, 0);
    auto mild = new Feature(temp, "mild", 0, 15);
    auto hot = new Feature(temp, "hot", 15, 100);

    auto humidity = new Tag("Humidity");
    auto low = new Feature(humidity, "low", 0);
    auto normal = new Feature(humidity, "normal", 1);
    auto high = new Feature(humidity, "high", 2);

    auto wind = new Tag("Wind");
    auto calm = new Feature(wind, "calm", 0);
    auto windy = new Feature(wind, "windy", 1);

    auto dataset = new Dataset!double();
    dataset.add(new Sample!double(Array!Feature(rainy, hot, high, calm), 26));
    dataset.add(new Sample!double(Array!Feature(rainy, hot, high, windy), 30));
    dataset.add(new Sample!double(Array!Feature(overcast, hot, high, calm), 48));
    dataset.add(new Sample!double(Array!Feature(sunny, mild, high, calm), 46));
    dataset.add(new Sample!double(Array!Feature(sunny, cool, normal, calm), 62));
    dataset.add(new Sample!double(Array!Feature(sunny, cool, normal, windy), 23));
    dataset.add(new Sample!double(Array!Feature(overcast, cool, normal, windy), 43));
    dataset.add(new Sample!double(Array!Feature(rainy, mild, high, calm), 36));
    dataset.add(new Sample!double(Array!Feature(rainy, cool, normal, calm), 38));
    dataset.add(new Sample!double(Array!Feature(sunny, mild, normal, calm), 48));
    dataset.add(new Sample!double(Array!Feature(rainy, mild, normal, windy), 48));
    dataset.add(new Sample!double(Array!Feature(overcast, mild, high, windy), 62));
    dataset.add(new Sample!double(Array!Feature(overcast, hot, normal, calm), 44));
    dataset.add(new Sample!double(Array!Feature(sunny, mild, high, windy), 30));

    auto id3 = new Id3!double();
    auto tree = id3.build(dataset);
}
