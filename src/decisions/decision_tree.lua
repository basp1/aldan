require "src/core/arrays"
local Tree = require "src/core/tree"

local decision_tree = {}
decision_tree.__index = decision_tree

function decision_tree.new()
  local self = setmetatable({}, decision_tree)

  self.tree = Tree.new()

  return self
end

local node = {}
node.__index = node

function node.new(type, value)
  assert('feature' == type or 'case' == type or 'item' == type)

  local self = setmetatable({}, node)

  self.type = type
  self.value = value

  return self
end

function decision_tree.add(self, parent, type, value)
  return self.tree:add(parent, node.new(type, value))
end

function decision_tree.root(self)
  return self.tree.root
end

return decision_tree