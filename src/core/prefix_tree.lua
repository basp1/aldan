require "src/core/arrays"
local Tree = require "src/core/tree"

local prefix_tree = {}
prefix_tree.__index = prefix_tree

function prefix_tree.new()
    local self = setmetatable({}, prefix_tree)

    self.tree = Tree.new()

    return self
end

-- TODO
-- add vertex join
-- add vertex split
function prefix_tree.add(self, path, value)
    local vertex = self.tree.root

    for _, x in pairs(path) do
        local adjacent = self.tree:get_adjacent(vertex)

        local adj = find_if(adjacent, function(a)
            return x == a.edge
        end)

        if nil ~= adj then
            vertex = adj.vertex
        else
            vertex = self.tree:add(vertex, nil, x)
        end
    end

    self.tree:set_vertex(vertex, value)
end

function prefix_tree.find(self, path)
    local vertex = self.tree.root

    for _, x in pairs(path) do
        local adjacent = self.tree:get_adjacent(vertex)

        local adj = find_if(adjacent, function(a)
            return a.edge == x
        end)

        if nil == adj then
            return nil
        end

        vertex = adj.vertex
    end

    return self.tree:get_vertex(vertex)
end

function prefix_tree.all_paths(self)
    if not self.tree:has_successors(self.tree.root) then
        return {}
    else
        return self.tree:all_paths()
    end
end

return prefix_tree