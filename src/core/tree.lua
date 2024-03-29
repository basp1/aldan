require "src/core/arrays"
local graph = require "src/core/graph"
local stack = require "src/core/stack"

local tree = {}
tree.__index = tree

function tree.new()
    local self = setmetatable({}, tree)

    self.graph = graph:new()
    self.root = self.graph:add_vertex({})

    return self
end

function tree.add(self, parent, value, edge)
    local vertex = self.graph:add_vertex({ parent = parent, value = value })
    self.graph:add_edge(parent, vertex, edge)
    return vertex
end

function tree.get_vertex(self, vertex)
    return self.graph:get_vertex(vertex).value
end

function tree.get_successors(self, vertex)
    return map(self:get_adjacent(vertex), function(a)
        return a.vertex
    end)
end

function tree.get_adjacent(self, vertex)
    return self.graph:get_adjacent(vertex)
end

function tree.has_successors(self, vertex)
    return self.graph:has_edges(vertex)
end

function tree.get_parent(self, vertex)
    return self.graph:get_vertex(vertex).parent
end

function tree.is_leaf(self, vertex)
    return self:has_successors(vertex)
end

function tree.set_vertex(self, vertex, value)
    self.graph:get_vertex(vertex).value = value
end

function tree.all_paths(self)
    local paths = {}
    local path = stack:new()
    local queue = stack:new()

    queue:push(self.root)
    local backward = false

    while not queue:empty() do
        local vertex = queue:pop()

        if backward then
            local parent = self:get_parent(vertex)
            while not path:empty() and parent ~= self:get_parent(path:pop()) do
            end
            backward = false
        end

        path:push(vertex)

        if not self:has_successors(vertex) then
            local array = path:to_array()
            table.insert(paths, array)
            backward = true
        end

        local suc = self:get_successors(vertex)
        for i = 1, #(suc) do
            queue:push(suc[i])
        end
    end

    return paths
end

return tree
