require "src/core/arrays"
local Tree = require "src/core/tree"

local decisions_tree = {}
decisions_tree.__index = decisions_tree

function decisions_tree.new()
  local self = setmetatable({}, decisions_tree)

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

function decisions_tree.add(self, parent, type, value)
  return self.tree:add(parent, node.new(type, value))
end

function decisions_tree.root(self)
  return self.tree.root
end

return decisions_tree