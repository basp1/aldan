local priority_queue = require "src/core/priority_queue"

local test = {}

test[#test + 1] = function()
    local pq = priority_queue.new(math.min)

    pq:push(3)
    assert(3 == pq:top())
    assert(1 == pq:height())

    pq:push(4)
    assert(3 == pq:top())
    assert(2 == pq:height())

    pq:push(5)
    assert(3 == pq:top())
    assert(2 == pq:height())

    pq:push(2)
    assert(2 == pq:top())
    assert(3 == pq:height())

    pq:push(1)
    assert(1 == pq:top())
    assert(3 == pq:height())
end

test[#test + 1] = function()
    local pq = priority_queue.new(math.min)

    for i = 8, 0, -1 do
        pq:push(i)
    end

    assert(0 == pq:top())
    assert(4 == pq:height())

    pq:push(9)
    assert(0 == pq:top())
    assert(4 == pq:height())
end

test[#test + 1] = function()
    local pq = priority_queue.new(math.min)

    pq:push(18)
    pq:push(19)
    pq:push(20)
    assert(18 == pq:top())

    pq:pop()
    assert(19 == pq:top())

    pq:pop()
    assert(20 == pq:top())

    pq:pop()
    assert(0 == pq.length)
end

test[#test + 1] = function()
    local pq = priority_queue.new(math.min)

    for i = 8, 0, -1 do
        pq:push(i)
    end

    assert(0 == pq:top())
    assert(4 == pq:height())

    pq:pop()
    assert(1 == pq:top())
    assert(4 == pq:height())

    pq:pop()
    assert(2 == pq:top())
    assert(3 == pq:height())

    pq:pop()
    assert(3 == pq:top())
    assert(3 == pq:height())

    pq:pop()
    assert(4 == pq:top())
    assert(3 == pq:height())
end

test[#test + 1] = function()
    local pq = priority_queue.new(math.min)

    local N = 20

    for i = N, 1, -1 do
        pq:push(i)
    end

    assert(1 == pq:top())

    for i = 0, math.floor(N / 2 - 1) do
        pq:pop()
    end

    assert(math.floor(N / 2 + 1) == pq:top())

    for i = 0, math.floor(N / 2 - 2) do
        pq:pop()
    end

    assert(N == pq:top())
end

return test
