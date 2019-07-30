module core.arrays;

import std.container.array;
import std.conv;

int binarySearch(T)(ref const Array!T array, T item)
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

int lowerBound(T)(ref const Array!T array, T item)
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

Array!int iota(int begin, int end)
{
    Array!int array;
    array.reserve(end - begin);

    for (int i = begin; i < end; i++)
    {
        array ~= i;
    }

    return array;
}

void sorting(Key, Value)(ref Array!Key keys, ref Array!Value values)
{
    import std.algorithm;

    assert(keys.length == values.length);

    auto sorted = iota(0, to!int(keys.length));
    sort!((a, b) => keys[a] < keys[b])(sorted[]);

    permute(values, sorted);
    permute(keys, sorted);

    destroy(sorted);
}

void permute(T)(ref Array!T array, ref const Array!int indices)
{
    assert(array.length == indices.length);

    auto t = array.dup;

    for (int i = 0; i < t.length; i++)
    {
        t[i] = array[indices[i]];
    }

    for (int i = 0; i < t.length; i++)
    {
        array[i] = t[i];
    }

    destroy(t);
}
