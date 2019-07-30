module core.stack;

import std.container.slist;

class Stack(T)
{
    SList!T list;

    this()
    {
    }

    void push(ref const T value)
    {
        list.insertFront(value);
    }

    T pop()
    {
        T value = top();

        list.removeFront();

        return value;
    }

    @property T top() const
    {
        return list.front;
    }

    @property bool empty() const
    {
        return list.empty;
    }

    Array!T toArray() const
    {
        Array!T array;
        foreach (value; list)
        {
            array ~= value;
        }

        return array;
    }

    string toString() const
    {
        return list.toString();
    }
}
