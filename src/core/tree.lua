require "src/core/arrays"
local graph = require "src/core/graph"
local stack = require "src/core/stack"

local tree = {}
tree.__index = tree

function tree.new()
  local self = setmetatable({}, tree)

  self.graph = graph:new()
  self.root = self.graph:addVertex(nil)

  return self
end

function tree.add(self, parent, value, weight)
  if nil == weight then
    weight = 1
  end

  local vertex = self.graph:addVertex({parent=parent, value=value})
  self.graph:addEdge(parent, vertex, weight)
  return vertex
end

function tree.getVertex(self, vertex)
  return self.graph:getVertex(vertex).value
end

function tree.getSuccessors(self, vertex)
  return self.graph:getAdjacent(vertex)
end

function tree.hasSuccessors(self, vertex)
  return self.graph:hasEdges(vertex)
end

function tree.getParent(self, vertex)
  return self.graph:getVertex(vertex).parent
end

function tree.allPaths(self)
  local paths = stack:new()
  local path = stack:new()
  local queue = stack:new()

  queue:push(self.root)
  local backward = false

  while not queue:empty() do
    local vertex = queue:pop()

    if backward then
      local parent = self:getParent(vertex)
      while not path:empty() and parent ~= self:getParent(path:pop()) do end
      backward = false
    end

    path:push(vertex)

    if not self:hasSuccessors(vertex) then
      local array = path:toArray()
      paths:push(array)
      backward = true
    end

    local suc = self:getSuccessors(vertex)
    for i = 0,len(suc)-1 do
      queue:push(suc[i])
    end
  end


  return paths
end

return tree
