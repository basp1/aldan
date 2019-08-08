require "src/core/arrays"

local test = {}

test[#test + 1] = function()
    local array = { 0, 1, 2, 3, 4, 5, 6, 8, 9, 10 }

    assert(0 == binary_search(array, -10))

    assert(0 ~= binary_search(array, 0))

    assert(0 ~= binary_search(array, 4))

    assert(0 ~= binary_search(array, 5))

    assert(0 ~= binary_search(array, 9))

    assert(0 == binary_search(array, 7))

    assert(0 == binary_search(array, 100))
end

test[#test + 1] = function()
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

test[#test + 1] = function()
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
return test