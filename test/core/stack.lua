local stack = require "src/core/stack"

local test = {}

test[#test + 1] = function()
    local s = stack.new()

    assert(s:empty())
    assert(0 == s:length())

    s:push(1)
    assert(not s:empty())
    assert(1 == s:length())
    assert(1 == s:top())

    s:push(2)
    assert(2 == s:length())
    assert(2 == s:top())

    local x = s:pop()
    assert(2 == x)
    assert(1 == s:length())
    assert(1 == s:top())

    s:push(2)
    s:push(3)
    local xs = s:to_array()
    assert(3 == #(xs))
    assert(1 == xs[1])
    assert(2 == xs[2])
    assert(3 == xs[3])
    assert(3 == s:length())
end

return test
