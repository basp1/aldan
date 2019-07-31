require "src/core/arrays"

local graph = {}
graph.__index = graph

local NIL = -1

function graph.new()
  local self = setmetatable({}, graph)

  self.n = 0
  self.m = 0
  self.free = NIL

  self.from = {}
  self.vertices = {}

  self.next = {}
  self.to = {}
  self.edges = {}

  return self
end

function graph.length(self)
  return self.m
end

function graph.clear(self)
  self.m = 0
  self.free = NIL

  for i=0,self.n - 1 do
    self.from[i] = NIL
    self.vertices[i] = nil
  end

  self.next = {}
  self.to = {}
  self.edges = {}
end

function graph.addVertex(self, vertex)
  self.from[self.n] = NIL
  self.vertices[self.n] = vertex
  self.n = self.n + 1

  return self.n - 1
end

function graph.getVertex(self, vertex)
  assert(vertex >= 0 and vertex < self.n)

  return self.vertices[vertex]
end

function graph.hasEdges(self, vertex)
  assert(vertex >= 0 and vertex < self.n)

  if NIL == self.from[vertex] then
    return false
  else
    return true
  end
end

function graph.hasEdge(self, from, to)
  assert(from >= 0 and from < self.n)
  assert(to >= 0)

  if not self:hasEdges(from) then
    return false
  end


  local j = self.from[from]
  while NIL ~= j do
    if to == self.to[j] then
      return true
    end
    j = self.next[j]
  end

  return false
end

function graph.addEdge(self, from, to, edge)
  assert(from >= 0 and from < self.n)
  assert(to >= 0)

  local n = NIL
  if self.free >= 0 then
    n = self.free
    self.to[self.free] = to
    self.edges[self.free] = edge
    self.free = self.next[self.free]
  else
    n = self.m
    self.next[self.m] = NIL
    self.to[self.m] = to
    self.edges[self.m] = edge
  end

  if NIL == self.from[from] then
    self.from[from] = NIL
  end

  self.next[n] = self.from[from]
  self.from[from] = n

  self.m = self.m + 1
end

function graph.removeEdge(self, from, to)
  assert(from >= 0 and from < self.n)
  assert(to >= 0)

  if not self:hasEdges(from) then
    return
  end

  local k = NIL
  local p = NIL
  local j = self.from[from]

  while NIL ~= j do
    if to == self.to[j] then
      k = j
      break
    end
    p = j
    j = self.next[j]
  end

  if NIL == k then
    return
  end

  if self.from[from] == k then
    self.from[from] = self.next[k]
    self.next[k] = self.free
    self.free = k
  else
    self.next[p] = self.next[k]
    self.next[k] = self.free
    self.free = k
  end

  self.m = self.m - 1
end

function graph.removeEdges(self, vertex)
  assert(vertex >= 0 and vertex < self.n)

  if not self:hasEdges(vertex) then
    return
  end

  local n = 1
  local p = self.from[vertex]

  while NIL ~= self.next[p] do
    p = self.next[p]
    n = n+ 1
  end

  self.next[p] = self.free
  self.free = self.from[vertex]
  self.from[vertex] = NIL
  self.m = self.m - n
end

function graph.getAdjacent(self, vertex)
  assert(vertex >= 0 and vertex < self.n)

  local adjacent = {}
  local i = 0
  local j = self.from[vertex]
  while NIL ~= j do
    adjacent[i] = self.to[j]
    j = self.next[j]
    i = i + 1
  end

  return adjacent
end

function graph.isLeaf(self, vertex)
  assert(vertex >= 0 and vertex < self.n)

  if not self:hasEdges(vertex) then
    return true
  end

  local first = vertex

  local i = self.from[vertex]
  while NIL ~= i do
    if vertex ~= self.to[i] then
      first = self.to[i]
      break
    end
    i = self.next[i]
  end

  if vertex == first then
    return true
  end

  i = self.from[vertex]
  while NIL ~= i do
    if first ~= self.to[i] and vertex ~= self.to[i] then
      return false
    end
    i = self.next[i]
  end

  return true
end

function graph.clone(self)
  local that = graph.new()

  that.from = copy(self.from)
  that.next = copy(self.next)
  that.to = copy(self.to)
  that.vertices = copy(self.vertices)
  that.edges = copy(self.edges)

  that.n = self.n
  that.m = self.m
  that.free = self.free

  return that
end

function graph.sort(self)
  local sorted = {}
  local index = {}

  local n = len(self.from)
  for i = 0, (n-1) do
    sorted = {}
    index = {}
    local j = self.from[i]

    while NIL ~= j do
      sorted[len(sorted)] = self.to[j]
      index[len(index)] = j
      j = self.next[j]
    end

    if len(sorted) >= 2 then

      sort(sorted, index)

      for j = 1, len(sorted) do
        self.next[index[j - 1]] = index[j]

        self.from[i] = index[0]
        self.next[index[len(sorted) - 1]] = NIL
      end
    end
  end
end

function graph.equals(self, that)
  if self.n ~= that.n then
    return false
  end
  if self.m ~= that.m then
    return false
  end

  for i = 0, (self.n-1) do
    local j = self.from[i]
    local k = that.from[i]

    if self.vertices[i] ~= that.vertices[i] then
      return false
    end

    while NIL ~= j and NIL ~= k do
      if self.to[j] ~= that.to[k] then
        return false
      end
      if self.edges[j] ~= that.edges[k] then
        return false
      end

      j = self.next[j]
      k = that.next[k]
    end

    if NIL ~= j or NIL ~= k then
      return false
    end
  end

  return true
end


return graph
