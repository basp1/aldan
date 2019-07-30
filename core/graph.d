module core.graph;

import std.container.array;
import std.exception;
import std.typecons;
import std.conv;

import core.arrays;

class Graph(V, E)
{
    alias Id = int;

    const static int NIL = -1;

    Array!int begin;
    Array!int next;
    Array!int end;
    Array!V vertices;
    Array!E edges;

    int length;
    int free = NIL;

    this(size_t capacity = 0)
    {
        this.length = 0;
        free = NIL;

        begin.length = 0;
        vertices.length = 0;

        next.reserve(capacity);
        end.reserve(capacity);
        edges.reserve(capacity);
    }

    void clear()
    {
        length = 0;
        free = NIL;

        begin[] = NIL;
        vertices[] = V.init;

        next.length = 0;
        end.length = 0;
        edges.length = 0;
    }

    Id addVertex(const V vertex)
    {
        begin ~= NIL;
        vertices ~= vertex;

        return to!int(begin.length) - 1;
    }

    V getVertex(Id vertex)
    {
        enforce(vertex >= 0 && vertex < begin.length);

        return vertices[vertex];
    }

    bool hasEdges(Id vertex)
    {
        enforce(vertex >= 0 && vertex < begin.length);

        if (NIL == begin[vertex])
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    bool hasEdge(Id from, Id to)
    {
        enforce(from >= 0 && from < begin.length);
        enforce(to >= 0);

        if (!hasEdges(from))
        {
            return false;
        }

        for (int j = begin[from]; NIL != j; j = next[j])
        {
            if (to == end[j])
            {
                return true;
            }
        }

        return false;
    }

    void addEdge(Id from, Id to, E edge)
    {
        enforce(from >= 0 && from < begin.length);
        enforce(to >= 0);

        int n;
        if (free >= 0)
        {
            n = free;
            end[free] = to;
            edges[free] = edge;
            free = next[free];
        }
        else
        {
            n = length;
            next ~= NIL;
            end ~= to;
            edges ~= edge;
        }

        if (NIL == begin[from])
        {
            begin[from] = NIL;
        }

        next[n] = begin[from];
        begin[from] = n;

        length += 1;
    }

    void removeEdge(Id from, Id to)
    {
        enforce(from >= 0 && from < begin.length);
        enforce(to >= 0);

        if (!hasEdges(from))
        {
            return;
        }

        int k = NIL;
        int p = NIL;
        int j = begin[from];

        while (NIL != j)
        {
            if (to == end[j])
            {
                k = j;
                break;
            }
            p = j;
            j = next[j];
        }

        if (NIL == k)
        {
            return;
        }

        if (begin[from] == k)
        {
            begin[from] = next[k];
            next[k] = free;
            free = k;
        }
        else
        {
            next[p] = next[k];
            next[k] = free;
            free = k;
        }

        length -= 1;
    }

    void removeEdges(Id vertex)
    {
        enforce(vertex >= 0 && vertex < begin.length);

        if (!hasEdges(vertex))
        {
            return;
        }

        int n = 1;
        int p = begin[vertex];

        while (NIL != next[p])
        {
            p = next[p];
            n += 1;
        }

        next[p] = free;
        free = begin[vertex];
        begin[vertex] = NIL;
        length -= n;
    }

    Array!Id getAdjacent(Id vertex)
    {
        enforce(vertex >= 0 && vertex < begin.length);

        Array!Id adjacent;

        for (int j = begin[vertex]; NIL != j; j = next[j])
        {
            adjacent ~= end[j];
        }

        return adjacent;
    }

    bool isLeaf(Id vertex)
    {
        enforce(vertex >= 0 && vertex < begin.length);

        if (!hasEdges(vertex))
        {
            return true;
        }

        int firstNeighbor = vertex;

        for (int i = begin[vertex]; NIL != i; i = next[i])
        {
            if (vertex != end[i])
            {
                firstNeighbor = end[i];
                break;
            }
        }

        if (vertex == firstNeighbor)
        {
            return true;
        }

        for (int i = begin[vertex]; NIL != i; i = next[i])
        {
            if (firstNeighbor != end[i] && vertex != end[i])
            {
                return false;
            }
        }

        return true;
    }

    override bool opEquals(Object o)
    {
        if (this is o)
            return true;
        if (this is null || o is null)
            return false;
        if (typeid(this) != typeid(o))
            return false;

        auto that = cast(typeof(this))(o);

        if (length != that.length)
        {
            return false;
        }

        size_t n = begin.length;
        for (int i = 0; i < n; i++)
        {
            int j = begin[i];
            int k = that.begin[i];

            if (vertices[i] != that.vertices[i])
            {
                return false;
            }

            while (NIL != j && NIL != k)
            {
                if (end[j] != that.end[k])
                {
                    return false;
                }
                if (edges[j] != that.edges[k])
                {
                    return false;
                }

                j = next[j];
                k = that.next[k];
            }

            if (NIL != j || NIL != k)
            {
                return false;
            }
        }

        return true;
    }

    typeof(this) dup()
    {
        typeof(this) that = new Graph!(V, E)(to!size_t(length));

        that.begin = begin.dup;
        that.next = next.dup;
        that.end = end.dup;
        that.vertices = vertices.dup;
        that.edges = edges.dup;

        that.length = length;
        that.free = free;

        return that;
    }

    void sort()
    {
        Array!int sorted;
        Array!int index;

        size_t n = begin.length;
        for (int i = 0; i < n; i++)
        {
            int count = 0;

            sorted.length = 0;
            index.length = 0;
            int j = begin[i];

            while (NIL != j)
            {
                sorted ~= end[j];
                index ~= j;
                j = next[j];
                count += 1;
            }

            if (count < 2)
            {
                continue;
            }

            sorting(sorted, index, 0, count);

            for (j = 1; j < count; j++)
            {
                next[index[j - 1]] = index[j];

                begin[i] = index[0];
                next[index[count - 1]] = NIL;
            }
        }

        destroy(sorted);
        destroy(index);
    }
}

unittest
{
    auto g = new Graph!(char, char)();
    auto a = g.addVertex('a');
    auto b = g.addVertex('b');
    auto c = g.addVertex('c');

    g.addEdge(a, a, '-');
    g.addEdge(b, a, '-');

    assert(g.hasEdge(a, a));
    assert(g.hasEdge(b, a));

    assert(!g.hasEdge(a, b));
    assert(!g.hasEdge(b, b));
    assert(!g.hasEdge(c, a));
    assert(!g.hasEdge(c, b));
}

unittest
{
    auto g = new Graph!(char, char)();
    auto a = g.addVertex('a');
    auto b = g.addVertex('b');
    auto c = g.addVertex('c');

    g.addEdge(a, a, '-');
    g.addEdge(a, b, '-');
    g.addEdge(b, a, '-');

    assert(3 == g.length);

    g.addEdge(b, b, '-');
    assert(4 == g.length);

    assert(g.hasEdge(a, b));
    g.removeEdge(a, b);

    assert(!g.hasEdge(a, b));

    g.addEdge(c, a, '-');
    g.addEdge(c, b, '-');

    assert(g.hasEdge(a, a));
    assert(g.hasEdge(b, a));
    assert(g.hasEdge(b, b));
    assert(g.hasEdge(c, a));
    assert(g.hasEdge(c, b));

    assert(!g.hasEdge(a, b));
}

unittest
{
    auto g = new Graph!(char, char)();
    auto a = g.addVertex('a');
    auto b = g.addVertex('b');
    auto c = g.addVertex('c');

    g.addEdge(a, a, '-');
    g.addEdge(a, b, '-');
    g.addEdge(b, a, '-');
    g.addEdge(b, b, '-');
    g.addEdge(c, a, '-');
    g.addEdge(c, b, '-');

    g.removeEdge(a, b);
    g.removeEdge(b, b);
    g.removeEdge(c, a);
    g.removeEdge(c, b);

    auto e = new Graph!(char, char)();
    a = e.addVertex('a');
    b = e.addVertex('b');
    c = e.addVertex('c');

    e.addEdge(a, a, '-');
    e.addEdge(b, a, '-');

    g.sort();
    e.sort();

    assert(g == e);
}

unittest
{
    auto g = new Graph!(char, char)();
    auto a = g.addVertex('a');
    auto b = g.addVertex('b');
    auto c = g.addVertex('c');

    g.addEdge(a, a, '-');
    g.addEdge(a, b, '-');
    g.addEdge(b, a, '-');
    g.addEdge(b, b, '-');
    g.addEdge(c, a, '-');
    g.addEdge(c, b, '-');

    g.removeEdge(a, b);
    g.removeEdge(b, b);
    g.removeEdge(c, a);
    g.removeEdge(c, b);

    g.removeEdge(a, a);
    g.addEdge(a, a, '-');

    auto e = new Graph!(char, char)();
    a = e.addVertex('a');
    b = e.addVertex('b');
    c = e.addVertex('c');

    e.addEdge(a, a, '-');
    e.addEdge(b, a, '-');

    g.sort();
    e.sort();

    assert(g == e);
}

unittest
{
    auto g = new Graph!(char, char)();
    auto a = g.addVertex('a');
    auto b = g.addVertex('b');
    auto c = g.addVertex('c');

    g.addEdge(a, a, '-');
    g.addEdge(a, b, '-');
    g.addEdge(b, a, '-');
    g.addEdge(b, b, '-');
    g.addEdge(c, a, '-');
    g.addEdge(c, b, '-');

    assert(6 == g.length);

    auto e = g.dup;

    g.removeEdge(a, a);
    g.removeEdge(a, b);
    g.removeEdge(b, a);
    g.removeEdge(b, b);
    g.removeEdge(c, a);
    g.removeEdge(c, b);

    assert(a == g.length);

    g.addEdge(a, a, '-');
    g.addEdge(a, b, '-');
    g.addEdge(b, a, '-');
    g.addEdge(b, b, '-');
    g.addEdge(c, a, '-');
    g.addEdge(c, b, '-');

    g.sort();
    e.sort();

    assert(g == e);
}

unittest
{
    auto g = new Graph!(char, char)();
    auto a = g.addVertex('a');
    auto b = g.addVertex('b');
    auto c = g.addVertex('c');

    g.addEdge(a, a, '-');
    g.addEdge(a, b, '-');
    g.addEdge(b, a, '-');
    g.addEdge(b, b, '-');
    g.addEdge(c, a, '-');
    g.addEdge(c, b, '-');

    assert(6 == g.length);

    auto e = g.dup;

    g.removeEdges(a);
    g.removeEdges(b);
    g.removeEdges(c);

    assert(a == g.length);

    g.addEdge(a, a, '-');
    g.addEdge(a, b, '-');
    g.addEdge(b, a, '-');
    g.addEdge(b, b, '-');
    g.addEdge(c, a, '-');
    g.addEdge(c, b, '-');

    g.sort();
    e.sort();

    assert(g == e);
}
