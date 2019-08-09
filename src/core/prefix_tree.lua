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
    local node = self.tree.root

    for _, x in pairs(path) do
        local successors = self.tree:get_successors(node)

        local suc = find_if(successors, function(a)
            return self.tree:get_vertex(a) == x
        end)

        if nil == suc then
            suc = self.tree:add(node, x)
        end

        node = suc
    end

    self.tree:add(node, value)
end

function prefix_tree.all_paths(self)
    if not self.tree:has_successors(self.tree.root) then
        return {}
    else
        return self.tree:all_paths()
    end
end

return prefix_tree