require "src/core/arrays"

local test = {}

test[#test + 1] = function()
    local array = { [0] = 0, 1, 2, 3, 4, 5, 6, 8, 9, 10 }

    assert(-1 == binary_search(array, -10))

    assert(-1 ~= binary_search(array, 0))

    assert(-1 ~= binary_search(array, 4))

    assert(-1 ~= binary_search(array, 5))

    assert(-1 ~= binary_search(array, 9))

    assert(-1 == binary_search(array, 7))

    assert(-1 == binary_search(array, 100))
end

test[#test + 1] = function()
    local array = { [0] = 0, 1, 2, 3, 4, 5, 6, 8, 9, 10 }

    assert(0 == lower_bound(array, -10))

    assert(0 == lower_bound(array, 0))

    assert(4 == lower_bound(array, 4))

    assert(5 == lower_bound(array, 5))

    assert(8 == lower_bound(array, 9))

    assert(7 == lower_bound(array, 7))

    assert(9 == lower_bound(array, 10))

    assert(10 == lower_bound(array, 100))
end

return test