local intlist = require "src/core/intlist"

local test = {}

test[#test + 1] = function()
    local ii = intlist.new(10)

    ii:push(1)
    ii:push(7)
    ii:push(3)
    ii:push(2)

    assert(10 == ii.capacity)
    assert(4 == ii.length)
end

test[#test + 1] = function()
    local ii = intlist.new(10)

    ii:push(1)
    ii:push(7)
    ii:push(3)
    ii:push(2)
    ii:push(0)

    assert(ii:contains(1))
    assert(ii:contains(2))
    assert(ii:contains(3))
    assert(ii:contains(7))

    assert(ii:contains(0))
    assert(not ii:contains(5))
end

test[#test + 1] = function()
    local ii = intlist.new(10)

    ii:push(1)
    ii:push(7)
    ii:push(3)
    ii:push(2)

    assert(2 == ii:pop())
    assert(3 == ii:pop())
    assert(7 == ii:pop())
    assert(1 == ii:pop())
end

test[#test + 1] = function()
    local ii = intlist.new(10)

    ii:push(1)
    ii:push(7)
    ii:push(3)
    ii:push(2)

    local values = ii:pop_all()

    assert(0 == ii.length)
    assert(4 == #(values))

    assert(2 == values[1])
    assert(3 == values[2])
    assert(7 == values[3])
    assert(1 == values[4])
end

return test
