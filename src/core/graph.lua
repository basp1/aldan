require "src/core/arrays"

local graph = {}
graph.__index = graph

local NIL = 0

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

    for i = 1, self.n do
        self.from[i] = NIL
        self.vertices[i] = nil
    end

    self.next = {}
    self.to = {}
    self.edges = {}
end

function graph.add_vertex(self, vertex)
    self.n = self.n + 1

    self.from[self.n] = NIL
    self.vertices[self.n] = vertex

    return self.n
end

function graph.get_vertex(self, vertex)
    assert(vertex > 0 and vertex <= self.n)

    return self.vertices[vertex]
end

function graph.set_vertex(self, vertex, value)
    assert(vertex > 0 and vertex <= self.n)

    self.vertices[vertex] = value
end

function graph.has_edges(self, vertex)
    assert(vertex > 0 and vertex <= self.n)

    if NIL == self.from[vertex] then
        return false
    else
        return true
    end
end

function graph.has_edge(self, from, to)
    assert(from > 0 and from <= self.n)
    assert(to > 0)

    if not self:has_edges(from) then
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

function graph.add_edge(self, from, to, edge)
    assert(from > 0 and from <= self.n)
    assert(to > 0)

    local n
    if self.free > 0 then
        n = self.free
        self.to[self.free] = to
        self.edges[self.free] = edge
        self.free = self.next[self.free]
    else
        n = self.m + 1
        self.next[n] = NIL
        self.to[n] = to
        self.edges[n] = edge
    end

    self.next[n] = self.from[from]
    self.from[from] = n

    self.m = self.m + 1
end

function graph.remove_edge(self, from, to)
    assert(from > 0 and from <= self.n)
    assert(to > 0)

    if not self:has_edges(from) then
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

function graph.remove_edges(self, vertex)
    assert(vertex > 0 and vertex <= self.n)

    if not self:has_edges(vertex) then
        return
    end

    local n = 1
    local p = self.from[vertex]

    while NIL ~= self.next[p] do
        p = self.next[p]
        n = n + 1
    end

    self.next[p] = self.free
    self.free = self.from[vertex]
    self.from[vertex] = NIL
    self.m = self.m - n
end

function graph.get_adjacent(self, vertex)
    assert(vertex > 0 and vertex <= self.n)

    local adjacent = {}
    local i = 1
    local j = self.from[vertex]
    while NIL ~= j do
        adjacent[i] = { vertex = self.to[j], edge = self.edges[j] }
        j = self.next[j]
        i = i + 1
    end

    return adjacent
end

function graph.is_leaf(self, vertex)
    assert(vertex > 0 and vertex <= self.n)

    if not self:has_edges(vertex) then
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
    local sorted
    local index

    local n = #(self.from)
    for i = 1, n do
        sorted = {}
        index = {}
        local j = self.from[i]

        while NIL ~= j do
            sorted[#(sorted)] = self.to[j]
            index[#(index)] = j
            j = self.next[j]
        end

        if #(sorted) >= 2 then

            sort(sorted, index)

            for j = 1, #(sorted) do
                self.next[index[j]] = index[j + 1]

                self.from[i] = index[1]
                self.next[index[#(sorted)]] = NIL
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

    for i = 1, self.n do
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
