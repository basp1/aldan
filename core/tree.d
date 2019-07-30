module core.tree;

import std.container.array;
import std.container.slist;
import std.exception;
import std.typecons;
import std.conv;

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
        auto vertex = graph.addVertex(tuple(parent, value));
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
        return getVertex(vertex).parent;
    }

    Slist!(Array!Id) allPaths()
    {
        Slist!(Array!Id) paths;

        SList!int path;
        SList!int queue;

        queue.insertFront(root);
        bool backward = false;

        while (!queue.empty)
        {
            int vertex = queue.front;
            queue.removeFront();

            if (backward)
            {
                path.removeFront();
                auto parent = getParent(vertex);
                while (!path.empty && parent != getParent(path.front))
                {
                    path.removeFront();
                }
                backward = false;
            }

            path.insertFront(vertex);

            if (!hasSuccessors(vertex))
            {
                Array!Id p;
                foreach (vertex; path)
                {
                    p ~= vertex;
                }
                paths.insertFront(p);
                backward = true;
            }

            foreach (vertex; hasSuccessors(vertex))
            {
                queue.insertFront(vertex);
            }
        }

        return paths;
    }
}
