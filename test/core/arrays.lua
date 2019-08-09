require "src/core/arrays"

local test = {}

test.binary_search = function()
    local array = { 0, 1, 2, 3, 4, 5, 6, 8, 9, 10 }

    assert(0 == binary_search(array, -10))

    assert(0 ~= binary_search(array, 0))

    assert(0 ~= binary_search(array, 4))

    assert(0 ~= binary_search(array, 5))

    assert(0 ~= binary_search(array, 9))

    assert(0 == binary_search(array, 7))

    assert(0 == binary_search(array, 100))
end

test.lower_bound = function()
    local array = { 0, 1, 2, 3, 4, 5, 6, 8, 9, 10 }

    assert(1 == lower_bound(array, -10))

    assert(1 == lower_bound(array, 0))

    assert(5 == lower_bound(array, 4))

    assert(6 == lower_bound(array, 5))

    assert(9 == lower_bound(array, 9))

    assert(8 == lower_bound(array, 7))

    assert(10 == lower_bound(array, 10))

    assert(11 == lower_bound(array, 100))
end

test.unique = function()
    local array = { }
    unique(array)
    assert(0 == #(array))

    array = { 10 }
    unique(array)
    assert(1 == #(array))
    assert(10 == array[1])

    array = { 10, 20 }
    unique(array)
    assert(2 == #(array))
    assert(10 == array[1])
    assert(20 == array[2])

    array = { 20, 10 }
    unique(array)
    assert(2 == #(array))
    assert(20 == array[1])
    assert(10 == array[2])

    array = { 10, 10, 10, 10 }
    unique(array)
    assert(1 == #(array))
    assert(10 == array[1])

    array = { 10, 10, 20, 10 }
    unique(array)
    assert(2 == #(array))
    assert(10 == array[1])
    assert(20 == array[2])

    array = { 10, 20, 10, 20, 10, 20, 30, 30, 30 }
    unique(array)
    assert(3 == #(array))
    assert(10 == array[1])
    assert(20 == array[2])
    assert(30 == array[3])
end

test.empty = function()
    local array = nil
    assert(empty(array))

    array = {}
    assert(empty(array))

    array = { 1 }
    assert(not empty(array))

    array = { 1, 2, 3 }
    assert(not empty(array))
end

test.first = function()
    local array = { 1 }
    assert(1 == first(array))

    array = { 1, 2 }
    assert(1 == first(array))

    table.insert(array, 3)
    assert(1 == first(array))
end

test.last = function()
    local array = { 1 }
    assert(1 == last(array))

    array = { 1, 2 }
    assert(2 == last(array))

    table.insert(array, 3)
    assert(3 == last(array))
end

test.max = function()
    local array = { 10 }
    assert(10 == max(array))

    array = { 10, 20 }
    assert(20 == max(array))

    table.insert(array, 30)
    assert(30 == max(array))

    array = { 20, 10 }
    assert(20 == max(array))

    array = { 20, 10, 0 }
    assert(20 == max(array))

    array = { 10, 30, 20 }
    assert(30 == max(array))

    array = { 10, 20, 30 }
    assert(30 == max(array))
end

test.max_index = function()
    local array = { 10 }
    assert(1 == max_index(array))

    array = { 10, 20 }
    assert(2 == max_index(array))

    table.insert(array, 30)
    assert(3 == max_index(array))

    array = { 20, 10 }
    assert(1 == max_index(array))

    array = { 20, 10, 0 }
    assert(1 == max_index(array))

    array = { 10, 30, 20 }
    assert(2 == max_index(array))

    array = { 10, 20, 30, 40 }
    assert(4 == max_index(array))
end

test.min = function()
    local array = { 10 }
    assert(10 == min(array))

    array = { 10, 20 }
    assert(10 == min(array))

    table.insert(array, 30)
    assert(10 == min(array))

    array = { 20, 10 }
    assert(10 == min(array))

    array = { 20, 10, 0 }
    assert(0 == min(array))

    array = { 10, 30, 20 }
    assert(10 == min(array))

    array = { 30, 20, 10 }
    assert(10 == min(array))

    array = { 30, 10, 20, 10 }
    assert(10 == min(array))
end

test.min_index = function()
    local array = { 10 }
    assert(1 == min_index(array))

    array = { 10, 20 }
    assert(1 == min_index(array))

    table.insert(array, 30)
    assert(1 == min_index(array))

    array = { 20, 10 }
    assert(2 == min_index(array))

    array = { 20, 10, 0 }
    assert(3 == min_index(array))

    array = { 20, 30, 10 }
    assert(3 == min_index(array))

    array = { 40, 20, 30, 10 }
    assert(4 == min_index(array))
end

return test