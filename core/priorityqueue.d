module core.priorityqueue;

import std.algorithm;
import std.container.array;
import std.exception;
import std.math;
import std.typecons;
import std.conv;

class PriorityQueue(T)
{
    Array!T values;
    T delegate(T, T) selectFunc;

    size_t length;

    this(T delegate(T, T) selectFunc, int capacity = 0)
    {
        values.reserve(capacity);
        this.selectFunc = selectFunc;
        this.length = 0;
    }

    void push(T value)
    {
        size_t index = length;

        if (values.length <= index)
        {
            values ~= value;
        }
        else
        {
            values[index] = value;
        }

        length += 1;

        promote(index);
    }

    T pop()
    {
        enforce(length > 0);

        T t = top();

        if (1 == length)
        {
            length = 0;
        }
        else
        {
            T last = values[length - 1];
            values[0] = last;
            length -= 1;

            demote(0);
        }

        return t;
    }

    @property T top() const
    {
        enforce(length > 0);

        return values[0];
    }

    @property int height() const
    {
        return 1 + to!int(log2(length));
    }

    void promote(size_t index)
    {
        assert(index >= 0 && index < length);

        if (0 == index)
        {
            return;
        }

        size_t parent = index / 2;

        while (index > 0)
        {
            T t = values[index];

            if (t != selectFunc(t, values[parent]))
            {
                break;
            }

            values[index] = values[parent];
            values[parent] = t;

            size_t next = parent;
            parent = index / 2;
            index = next;
        }
    }

    void demote(size_t index)
    {
        assert(index >= 0 && index < length);

        if (length == (1 + index))
        {
            return;
        }

        T value = values[index];

        while (index < length)
        {
            int right = cast(int)((1 + index) * 2);
            T rv = T.init;
            if (right < length)
            {
                rv = this.values[right];
            }

            int left = right - 1;
            T lv = T.init;
            if (left < length)
            {
                lv = this.values[left];
            }

            int child = -1;
            if (right < length && left < length && lv == selectFunc(lv, rv))
            {
                child = left;
            }
            else if (right < length)
            {
                child = right;
            }
            else if (left < length)
            {
                child = left;
            }

            if (child < 0 || value == selectFunc(value, values[child]))
            {
                break;
            }
            else
            {
                values[index] = values[child];
                values[child] = value;
                index = child;
            }
        }
    }
}

unittest
{
    auto pq = new PriorityQueue!int((x, y) => min(x, y));

    pq.push(3);
    assert(3 == pq.top);
    assert(1 == pq.height);

    pq.push(4);
    assert(3 == pq.top);
    assert(2 == pq.height);

    pq.push(5);
    assert(3 == pq.top);
    assert(2 == pq.height);

    pq.push(2);
    assert(2 == pq.top);
    assert(3 == pq.height);

    pq.push(1);
    assert(1 == pq.top);
    assert(3 == pq.height);
}

unittest
{
    auto pq = new PriorityQueue!int((x, y) => min(x, y));

    for (int i = 8; i >= 0; i--)
    {
        pq.push(i);
    }

    assert(0 == pq.top);
    assert(4 == pq.height);

    pq.push(9);
    assert(0 == pq.top);
    assert(4 == pq.height);
}

unittest
{
    auto pq = new PriorityQueue!int((x, y) => min(x, y), 5);
    for (int i = 8; i >= 0; i--)
    {
        pq.push(i);
    }

    assert(0 == pq.top);
    assert(4 == pq.height);

    pq.push(9);
    assert(0 == pq.top);
    assert(4 == pq.height);
}

unittest
{
    auto pq = new PriorityQueue!int((x, y) => min(x, y));

    pq.push(18);
    pq.push(19);
    pq.push(20);
    assert(18 == pq.top);

    pq.pop();
    assert(19 == pq.top);

    pq.pop();
    assert(20 == pq.top);

    pq.pop();
    assert(0 == pq.length);
}

unittest
{
    auto pq = new PriorityQueue!int((x, y) => min(x, y));
    for (int i = 8; i >= 0; i--)
    {
        pq.push(i);
    }

    assert(0 == pq.top);
    assert(4 == pq.height);

    pq.pop();
    assert(1 == pq.top);
    assert(4 == pq.height);

    pq.pop();
    assert(2 == pq.top);
    assert(3 == pq.height);

    pq.pop();
    assert(3 == pq.top);
    assert(3 == pq.height);

    pq.pop();
    assert(4 == pq.top);
    assert(3 == pq.height);
}

unittest
{
    const int N = 20;
    auto pq = new PriorityQueue!int((x, y) => min(x, y));

    for (int i = N; i > 0; i--)
    {
        pq.push(i);
    }

    assert(1 == pq.top);

    for (int i = 0; i < cast(int)(N / 2); i++)
    {
        pq.pop();
    }
    assert(1 + N / 2 == pq.top);

    for (int i = 0; i < cast(int)((N / 2) - 1); i++)
    {
        pq.pop();
    }

    assert(N == pq.top);
}
