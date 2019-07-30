module core.stack;

import std.container.array;
import std.container.slist;

class Stack(T)
{
    size_t n;
    SList!T list;

    this()
    {
        n = 0;
    }

    void push(ref T value)
    {
        list.insertFront(value);
        n++;
    }

    void push(T value)
    {
        list.insertFront(value);
        n++;
    }

    T pop()
    {
        T value = top();

        list.removeFront();
        n--;

        return value;
    }

    @property size_t length()
    {
        return n;
    }

    @property T top()
    {
        return list.front;
    }

    @property bool empty() const
    {
        return list.empty;
    }

    Array!T toArray()
    {
        Array!T array;
        foreach (value; list)
        {
            array ~= value;
        }

        return array;
    }
}

unittest
{
    auto s = new Stack!int();

    assert(s.empty);
    assert(0 == s.length);

    s.push(1);
    assert(!s.empty);
    assert(1 == s.length);
    assert(1 == s.top);

    s.push(2);
    assert(2 == s.length);
    assert(2 == s.top);

    int x = s.pop();
    assert(2 == x);
    assert(1 == s.length);
    assert(1 == s.top);

    s.push(2);
    s.push(3);
    auto xs = s.toArray();
    assert(3 == xs.length);
    assert(3 == xs[0]);
    assert(2 == xs[1]);
    assert(1 == xs[2]);
    assert(3 == s.length);
}
