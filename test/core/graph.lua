local graph = require "src/core/graph"

local test = {}

test[#test + 1] = function()
    local g = graph.new()
    local a = g:add_vertex('a')
    local b = g:add_vertex('b')
    local c = g:add_vertex('c')

    g:add_edge(a, a, '-')
    g:add_edge(b, a, '-')

    assert(g:has_edge(a, a))
    assert(g:has_edge(b, a))

    assert(not g:has_edge(a, b))
    assert(not g:has_edge(b, b))
    assert(not g:has_edge(c, a))
    assert(not g:has_edge(c, b))
end

test[#test + 1] = function()
    local g = graph.new()
    local a = g:add_vertex('a')
    local b = g:add_vertex('b')
    local c = g:add_vertex('c')

    g:add_edge(a, a, '-')
    g:add_edge(a, b, '-')
    g:add_edge(b, a, '-')

    assert(3 == g:length())

    g:add_edge(b, b, '-')
    assert(4 == g:length())

    assert(g:has_edge(a, b))
    g:remove_edge(a, b)

    assert(not g:has_edge(a, b))

    g:add_edge(c, a, '-')
    g:add_edge(c, b, '-')

    assert(g:has_edge(a, a))
    assert(g:has_edge(b, a))
    assert(g:has_edge(b, b))
    assert(g:has_edge(c, a))
    assert(g:has_edge(c, b))

    assert(not g:has_edge(a, b))
end

test[#test + 1] = function()
    local g = graph.new()
    local a = g:add_vertex('a')
    local b = g:add_vertex('b')
    local c = g:add_vertex('c')

    g:add_edge(a, a, '-')
    g:add_edge(a, b, '-')
    g:add_edge(b, a, '-')
    g:add_edge(b, b, '-')
    g:add_edge(c, a, '-')
    g:add_edge(c, b, '-')

    g:remove_edge(a, b)
    g:remove_edge(b, b)
    g:remove_edge(c, a)
    g:remove_edge(c, b)

    local e = graph.new()
    a = e:add_vertex('a')
    b = e:add_vertex('b')
    c = e:add_vertex('c')

    e:add_edge(a, a, '-')
    e:add_edge(b, a, '-')

    g:sort()
    e:sort()

    assert(e:equals(g))
end

test[#test + 1] = function()
    local g = graph.new()
    local a = g:add_vertex('a')
    local b = g:add_vertex('b')
    local c = g:add_vertex('c')

    g:add_edge(a, a, '-')
    g:add_edge(a, b, '-')
    g:add_edge(b, a, '-')
    g:add_edge(b, b, '-')
    g:add_edge(c, a, '-')
    g:add_edge(c, b, '-')

    g:remove_edge(a, b)
    g:remove_edge(b, b)
    g:remove_edge(c, a)
    g:remove_edge(c, b)

    g:remove_edge(a, a)
    g:add_edge(a, a, '-')

    local e = graph.new()
    a = e:add_vertex('a')
    b = e:add_vertex('b')
    c = e:add_vertex('c')

    e:add_edge(a, a, '-')
    e:add_edge(b, a, '-')

    g:sort()
    e:sort()

    assert(e:equals(g))
end

test[#test + 1] = function()
    local g = graph.new()
    local a = g:add_vertex('a')
    local b = g:add_vertex('b')
    local c = g:add_vertex('c')

    g:add_edge(a, a, '-')
    g:add_edge(a, b, '-')
    g:add_edge(b, a, '-')
    g:add_edge(b, b, '-')
    g:add_edge(c, a, '-')
    g:add_edge(c, b, '-')

    assert(6 == g:length())

    local e = g:clone()

    g:remove_edge(a, a)
    g:remove_edge(a, b)
    g:remove_edge(b, a)
    g:remove_edge(b, b)
    g:remove_edge(c, a)
    g:remove_edge(c, b)

    assert(0 == g:length())

    g:add_edge(a, a, '-')
    g:add_edge(a, b, '-')
    g:add_edge(b, a, '-')
    g:add_edge(b, b, '-')
    g:add_edge(c, a, '-')
    g:add_edge(c, b, '-')

    g:sort()
    e:sort()

    assert(e:equals(g))
end

test[#test + 1] = function()
    local g = graph.new()
    local a = g:add_vertex('a')
    local b = g:add_vertex('b')
    local c = g:add_vertex('c')

    g:add_edge(a, a, '-')
    g:add_edge(a, b, '-')
    g:add_edge(b, a, '-')
    g:add_edge(b, b, '-')
    g:add_edge(c, a, '-')
    g:add_edge(c, b, '-')

    assert(6 == g:length())

    local e = g:clone()

    g:remove_edges(a)
    g:remove_edges(b)
    g:remove_edges(c)

    assert(0 == g:length())

    g:add_edge(a, a, '-')
    g:add_edge(a, b, '-')
    g:add_edge(b, a, '-')
    g:add_edge(b, b, '-')
    g:add_edge(c, a, '-')
    g:add_edge(c, b, '-')

    g:sort()
    e:sort()

    assert(e:equals(g))
end

return test
