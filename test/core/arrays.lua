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

test[#test + 1] = function()
    local array = { }
    unique(array)
    assert(0 == len(array))

    array = { [0] = 10 }
    unique(array)
    assert(1 == len(array))
    assert(10 == array[0])

    array = { [0] = 10, 20 }
    unique(array)
    assert(2 == len(array))
    assert(10 == array[0])
    assert(20 == array[1])

    array = { [0] = 20, 10 }
    unique(array)
    assert(2 == len(array))
    assert(20 == array[0])
    assert(10 == array[1])

    array = { [0] = 10, 10, 10, 10 }
    unique(array)
    assert(1 == len(array))
    assert(10 == array[0])

    array = { [0] = 10, 10, 20, 10 }
    unique(array)
    assert(2 == len(array))
    assert(10 == array[0])
    assert(20 == array[1])

    array = { [0] = 10, 20, 10, 20, 10, 20, 30, 30, 30 }
    unique(array)
    assert(3 == len(array))
    assert(10 == array[0])
    assert(20 == array[1])
    assert(30 == array[2])
end
return test