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

    Stack!(Array!Id) allPaths()
    {
        Stack!(Array!Id) paths;

        Stack!int path;
        Stack!int queue;

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
                paths.push(move(path.toArray()));
                backward = true;
            }

            foreach (vertex; hasSuccessors(vertex))
            {
                queue.push(vertex);
            }
        }

        destroy(queue);
        destroy(path);

        return paths;
    }
}
