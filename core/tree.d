module core.tree;

import core.lifetime;
import std.container.array;
import std.exception;
import std.typecons;
import std.conv;

import core.stack;
import core.graph;

class Tree(T)
{
    alias Id = int;
    alias Node = Tuple!(Id, "parent", T, "value");

    Id root;
    Graph!(Node, float) graph;

    this()
    {
        graph = new Graph!(Node, float)();
        root = graph.addVertex(Node.init);
    }

    Id add(Id parent, const T value, float weight = 1)
    {
        auto vertex = graph.addVertex(tuple!(Id, "parent", T, "value")(parent, value));
        graph.addEdge(parent, vertex, weight);
        return vertex;
    }

    Array!Id getSuccessors(Id vertex)
    {
        return graph.getAdjacent(vertex);
    }

    bool hasSuccessors(Id vertex)
    {
        return graph.hasEdges(vertex);
    }

    Id getParent(Id vertex)
    {
        return graph.getVertex(vertex).parent;
    }

    Stack!(Array!Id) allPaths()
    {
        auto paths = new Stack!(Array!Id)();

        auto path = new Stack!int();
        auto queue = new Stack!int();

        queue.push(root);
        bool backward = false;

        while (!queue.empty)
        {
            int vertex = queue.pop();

            if (backward)
            {
                auto parent = getParent(vertex);
                while (!path.empty && parent != getParent(path.pop()))
                {
                }
                backward = false;
            }

            path.push(vertex);

            if (!hasSuccessors(vertex))
            {
                auto array = path.toArray();
                paths.push(array);
                backward = true;
            }

            foreach (suc; getSuccessors(vertex))
            {
                queue.push(suc);
            }
        }

        destroy(queue);
        destroy(path);

        return paths;
    }
}

unittest
{
    auto t = new Tree!char();

    auto a = t.add(t.root, 'a');
    auto b = t.add(t.root, 'b');
    auto c = t.add(a, 'c');
    auto d = t.add(a, 'd');
    auto e = t.add(b, 'e');
    auto f = t.add(c, 'f');
    auto g = t.add(d, 'g');
    auto h = t.add(d, 'h');
    auto i = t.add(d, 'i');
    auto j = t.add(e, 'j');

    assert(t.hasSuccessors(t.root));
    assert(2 == t.getSuccessors(t.root).length);
    assert(2 == t.getSuccessors(a).length);
    assert(1 == t.getSuccessors(b).length);
    assert(1 == t.getSuccessors(c).length);
    assert(3 == t.getSuccessors(d).length);
    assert(1 == t.getSuccessors(e).length);
    assert(!t.hasSuccessors(f));
    assert(0 == t.getSuccessors(f).length);
    assert(!t.hasSuccessors(g));
    assert(0 == t.getSuccessors(g).length);
    assert(!t.hasSuccessors(h));
    assert(0 == t.getSuccessors(h).length);
    assert(!t.hasSuccessors(i));
    assert(0 == t.getSuccessors(i).length);
    assert(!t.hasSuccessors(j));
    assert(0 == t.getSuccessors(j).length);

    assert(t.root == t.getParent(a));
    assert(t.root == t.getParent(b));
    assert(a == t.getParent(c));
    assert(a == t.getParent(d));
    assert(b == t.getParent(e));
    assert(c == t.getParent(f));
    assert(d == t.getParent(g));
    assert(d == t.getParent(h));
    assert(d == t.getParent(i));
    assert(e == t.getParent(j));

    auto paths = t.allPaths();
    assert(!paths.empty);

    assert(5 == paths.length);

}
