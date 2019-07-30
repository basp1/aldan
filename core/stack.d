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
