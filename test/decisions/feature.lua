local feature = require "src/decisions/feature"

local test = {}

test[#test + 1] = function()
    local f = feature.new()

    local a = f:add('name1', 3)
    local b = f:add('name2', 3, 3)
    local c = f:add('name3', 2, 5)

    assert(a.from == 3)
    assert(a.to == 3)
    assert(a.from == b.from)
    assert(a.to == b.to)
    assert(c.from == 2)
    assert(c.to == 5)

    assert(a.id ~= b.id)
    assert(a.id ~= c.id)
    assert(b.id ~= c.id)

    assert(a.feature == b.feature)
    assert(b.feature == c.feature)
end

test[#test + 1] = function()
    local f = feature.new()

    local a = f:add('a', 2, 4)

    assert(0 == a:distance(2))
    assert(0 == a:distance(3))
    assert(0 == a:distance(3.5))
    assert(0 == a:distance(4))

    assert(a:distance(0.5) > 0)
    assert(a:distance(1) > 0)
    assert(a:distance(5) > 0)
    assert(a:distance(1) == a:distance(5))
    assert(a:distance(0.5) > a:distance(5))
end

return test
