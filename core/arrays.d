module core.arrays;

import std.container.array;
import std.conv;

int binarySearch(T)(Array!T array, T item)
{
    assert(!array.empty());

    int l = 0;
    int r = to!int(array.length()) - 1;

    while (l <= r)
    {
        int m = l + (r - l) / 2;

        if (item == array[m])
        {
            return m;
        }
        else if (item < array[m])
        {
            r = m - 1;
        }
        else
        {
            l = m + 1;
        }
    }

    return -1;
}

unittest
{
    auto array = Array!int(0, 1, 2, 3, 4, 5, 6, 8, 9, 10);

    assert(-1 == binarySearch(array, -10));

    assert(-1 != binarySearch(array, 0));

    assert(-1 != binarySearch(array, 4));

    assert(-1 != binarySearch(array, 5));

    assert(-1 != binarySearch(array, 9));

    assert(-1 == binarySearch(array, 7));

    assert(-1 == binarySearch(array, 100));
}

int lowerBound(T)(Array!T array, T item)
{
    int n = to!int(array.length()) - 1;
    int l = 0;
    int r = n;

    while (l <= r)
    {
        int m = l + (r - l) / 2;
        if (item == array[m])
        {
            return m;
        }

        if (item < array[m])
        {
            r = m - 1;
        }
        else
        {
            l = m + 1;
        }
    }

    return l;
}

unittest
{
    auto array = Array!int(0, 1, 2, 3, 4, 5, 6, 8, 9, 10);

    assert(0 == lowerBound(array, -10));

    assert(0 == lowerBound(array, 0));

    assert(4 == lowerBound(array, 4));

    assert(5 == lowerBound(array, 5));

    assert(8 == lowerBound(array, 9));

    assert(7 == lowerBound(array, 7));

    assert(9 == lowerBound(array, 10));

    assert(10 == lowerBound(array, 100));
}

void sorting(Key, Value)(ref Array!Key keys, ref Array!Value values, size_t from, size_t to)
{
    import std.algorithm;

    assert(keys.length == values.length);
    assert(to >= from && to <= keys.length);

    Array!size_t indices;
    indices.length = to - from;
    for (int i = 0; i < indices.length; i++)
    {
        indices[i] = from + i;
    }

    auto sorted = indices.dup;
    sort!((a, b) => keys[a] < keys[b])(sorted[]);

    reindex(values, indices, sorted);
    reindex(keys, indices, sorted);

    destroy(indices);
    destroy(sorted);
}

void reindex(T)(ref Array!T values, ref Array!size_t oldIndices, ref Array!size_t newIndices)
{
    assert(oldIndices.length == newIndices.length);
    assert(oldIndices.length <= values.length);

    size_t n = oldIndices.length;
    auto t = values.dup;

    for (int i = 0; i < n; i++)
    {
        t[i] = values[oldIndices[i]];
    }

    for (int i = 0; i < n; i++)
    {
        values[newIndices[i]] = t[i];
    }

    destroy(t);
}
