module decisions.id3;

import std.container.array;
import std.math;
import std.uuid;

import decisions.dataset;
import decisions.feature;

class Id3
{
    this()
	{
    }

    static double entropy(Array!Feature features)
	{
        double[UUID] probs;

		foreach (feature ; features)
		{
            if (feature.id !in probs)
			{
                probs[feature.id] = 0;
            }
            probs[feature.id] += 1;
        }

        double count = features.length;
        foreach (id ; probs.byKey())
		{
            probs[id] /= count;
        }

        double sum = 0;
        foreach (probability ; probs)
		{
            sum += -probability * log(probability) / LN2;
        }

        return sum;
    }
}