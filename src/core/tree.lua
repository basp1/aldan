require "src/core/arrays"
local graph = require "src/core/graph"
local stack = require "src/core/stack"

local tree = {}
tree.__index = tree

function tree.new()
    local self = setmetatable({}, tree)

    self.graph = graph:new()
    self.root = self.graph:add_vertex(nil)

    return self
end

function tree.add(self, parent, value, weight)
    if nil == weight then
        weight = 1
    end

    local vertex = self.graph:add_vertex({ parent = parent, value = value })
    self.graph:add_edge(parent, vertex, weight)
    return vertex
end

function tree.get_vertex(self, vertex)
    return self.graph:get_vertex(vertex).value
end

function tree.get_successors(self, vertex)
    return self.graph:get_adjacent(vertex)
end

function tree.has_successors(self, vertex)
    return self.graph:has_edges(vertex)
end

function tree.get_parent(self, vertex)
    return self.graph:get_vertex(vertex).parent
end

function tree.all_paths(self)
    local paths = stack:new()
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
            paths:push(array)
            backward = true
        end

        local suc = self:get_successors(vertex)
        for i = 0, len(suc) - 1 do
            queue:push(suc[i])
        end
    end

    return paths
end

return tree
