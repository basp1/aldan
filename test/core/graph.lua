local graph = require "src/core/graph"

local test = {}

test[#test+1] = function()
  local g = graph.new()
  local a = g:addVertex('a')
  local b = g:addVertex('b')
  local c = g:addVertex('c')

  g:addEdge(a, a, '-')
  g:addEdge(b, a, '-')

  assert(g:hasEdge(a, a))
  assert(g:hasEdge(b, a))

  assert(not g:hasEdge(a, b))
  assert(not g:hasEdge(b, b))
  assert(not g:hasEdge(c, a))
  assert(not g:hasEdge(c, b))
end

test[#test+1] = function()
    local g = graph.new()
    local a = g:addVertex('a')
    local b = g:addVertex('b')
    local c = g:addVertex('c')

    g:addEdge(a, a, '-')
    g:addEdge(a, b, '-')
    g:addEdge(b, a, '-')

    assert(3 == g:length())

    g:addEdge(b, b, '-')
    assert(4 == g:length())

    assert(g:hasEdge(a, b))
    g:removeEdge(a, b)

    assert(not g:hasEdge(a, b))

    g:addEdge(c, a, '-')
    g:addEdge(c, b, '-')

    assert(g:hasEdge(a, a))
    assert(g:hasEdge(b, a))
    assert(g:hasEdge(b, b))
    assert(g:hasEdge(c, a))
    assert(g:hasEdge(c, b))

    assert(not g:hasEdge(a, b))
end

test[#test+1] = function()
    local g = graph.new()
    local a = g:addVertex('a')
    local b = g:addVertex('b')
    local c = g:addVertex('c')

    g:addEdge(a, a, '-')
    g:addEdge(a, b, '-')
    g:addEdge(b, a, '-')
    g:addEdge(b, b, '-')
    g:addEdge(c, a, '-')
    g:addEdge(c, b, '-')

    g:removeEdge(a, b)
    g:removeEdge(b, b)
    g:removeEdge(c, a)
    g:removeEdge(c, b)

    local e = graph.new()
    a = e:addVertex('a')
    b = e:addVertex('b')
    c = e:addVertex('c')

    e:addEdge(a, a, '-')
    e:addEdge(b, a, '-')

    g:sort()
    e:sort()

    assert(e:equals(g))
end

test[#test+1] = function()
    local g = graph.new()
    local a = g:addVertex('a')
    local b = g:addVertex('b')
    local c = g:addVertex('c')

    g:addEdge(a, a, '-')
    g:addEdge(a, b, '-')
    g:addEdge(b, a, '-')
    g:addEdge(b, b, '-')
    g:addEdge(c, a, '-')
    g:addEdge(c, b, '-')

    g:removeEdge(a, b)
    g:removeEdge(b, b)
    g:removeEdge(c, a)
    g:removeEdge(c, b)

    g:removeEdge(a, a)
    g:addEdge(a, a, '-')

    local e = graph.new()
    a = e:addVertex('a')
    b = e:addVertex('b')
    c = e:addVertex('c')

    e:addEdge(a, a, '-')
    e:addEdge(b, a, '-')

    g:sort()
    e:sort()

    assert(e:equals(g))
end

test[#test+1] = function()
    local g = graph.new()
    local a = g:addVertex('a')
    local b = g:addVertex('b')
    local c = g:addVertex('c')

    g:addEdge(a, a, '-')
    g:addEdge(a, b, '-')
    g:addEdge(b, a, '-')
    g:addEdge(b, b, '-')
    g:addEdge(c, a, '-')
    g:addEdge(c, b, '-')

    assert(6 == g:length())

    local e = g:clone()

    g:removeEdge(a, a)
    g:removeEdge(a, b)
    g:removeEdge(b, a)
    g:removeEdge(b, b)
    g:removeEdge(c, a)
    g:removeEdge(c, b)

    assert(a == g:length())

    g:addEdge(a, a, '-')
    g:addEdge(a, b, '-')
    g:addEdge(b, a, '-')
    g:addEdge(b, b, '-')
    g:addEdge(c, a, '-')
    g:addEdge(c, b, '-')

    g:sort()
    e:sort()

    assert(e:equals(g))
end

test[#test+1] = function()
    local g = graph.new()
    local a = g:addVertex('a')
    local b = g:addVertex('b')
    local c = g:addVertex('c')

    g:addEdge(a, a, '-')
    g:addEdge(a, b, '-')
    g:addEdge(b, a, '-')
    g:addEdge(b, b, '-')
    g:addEdge(c, a, '-')
    g:addEdge(c, b, '-')

    assert(6 == g:length())

    local e = g:clone()

    g:removeEdges(a)
    g:removeEdges(b)
    g:removeEdges(c)

    assert(a == g:length())

    g:addEdge(a, a, '-')
    g:addEdge(a, b, '-')
    g:addEdge(b, a, '-')
    g:addEdge(b, b, '-')
    g:addEdge(c, a, '-')
    g:addEdge(c, b, '-')

    g:sort()
    e:sort()

    assert(e:equals(g))
end

return test
