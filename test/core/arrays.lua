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

test.any = function()
    local predicate = function(a)
        return a >= 30
    end

    local array = { }
    assert(not any(array, predicate))

    array = { 10 }
    assert(not any(array, predicate))

    array = { 20, 10 }
    assert(not any(array, predicate))

    array = { 30 }
    assert(any(array, predicate))

    array = { 10, 20, 30 }
    assert(any(array, predicate))

    array = { 30, 30, 30 }
    assert(any(array, predicate))
end

test.all = function()
    local predicate = function(a)
        return a == 30
    end

    local array = { }
    assert(all(array, predicate))

    array = { 10 }
    assert(not all(array, predicate))

    array = { 10, 20 }
    assert(not all(array, predicate))

    array = { 10, 20, 30 }
    assert(not all(array, predicate))

    array = { 30, 30, 10 }
    assert(not all(array, predicate))

    array = { 30 }
    assert(all(array, predicate))

    array = { 30, 30, 30 }
    assert(all(array, predicate))
end

test.equals = function()
    local a = { }
    local b = a
    assert(equals(a, b))

    a = { }
    b = {}
    assert(equals(a, b))

    a = { 10 }
    b = {}
    assert(not equals(a, b))

    a = { }
    b = { 10 }
    assert(not equals(a, b))

    a = { 10 }
    b = { 10 }
    assert(equals(a, b))

    a = { 10, 20 }
    b = { 10, 20 }
    assert(equals(a, b))

    a = { 10, 20 }
    b = { 10, 30 }
    assert(not equals(a, b))
end

test.map = function()
    local func = function(a)
        return a + 1
    end

    local array = { }
    assert(equals({}, map(array, func)))

    local array = { 10 }
    assert(equals({ 11 }, map(array, func)))

    local array = { 10, 20 }
    assert(equals({ 11, 21 }, map(array, func)))

    local array = { 20, 10 }
    assert(equals({ 21, 11 }, map(array, func)))
end

test.filter = function()
    local predicate = function(a)
        return a >= 30
    end

    local array = { }
    assert(equals({}, filter(array, predicate)))

    local array = { 10 }
    assert(equals({}, filter(array, predicate)))

    local array = { 10, 20 }
    assert(equals({}, filter(array, predicate)))

    local array = { 10, 20, 30 }
    assert(equals({ 30 }, filter(array, predicate)))

    local array = { 30 }
    assert(equals({ 30 }, filter(array, predicate)))

    local array = { 10, 20, 30, 40, 0, 30, 30, 10, 40 }
    assert(equals({ 30, 40, 30, 30, 40 }, filter(array, predicate)))
end

test.find_if = function()
    local predicate = function(a)
        return a >= 30
    end

    local array = { }
    assert(nil == find_if(array, predicate))

    array = { 10 }
    assert(nil == find_if(array, predicate))

    array = { 10, 20 }
    assert(nil == find_if(array, predicate))

    array = { 30 }
    assert(30 == find_if(array, predicate))

    array = { 10, 20, 30 }
    assert(30 == find_if(array, predicate))

    array = { 10, 20, 30, 30, 10 }
    assert(30 == find_if(array, predicate))
end

test.copy = function()
    local array = { }
    assert(equals({}, copy(array)))

    array = { 10 }
    assert(equals({ 10 }, copy(array)))

    array = { 10, 20 }
    assert(equals({ 10, 20 }, copy(array)))

    array = { 10 }
    assert(equals({ 10 }, copy(array, 1)))

    array = { 10, 20, 30 }
    assert(equals({ 10, 20, 30 }, copy(array, 1)))

    array = { 10, 20, 30 }
    assert(equals({ 10, 20, 30 }, copy(array, 1, 3)))

    array = { 10, 20, 30 }
    assert(equals({ 10, 20 }, copy(array, 1, 2)))

    array = { 10, 20, 30 }
    assert(equals({ 10 }, copy(array, 1, 1)))

    array = { 10, 20, 30 }
    assert(equals({  }, copy(array, 1, 0)))

    array = { 10, 20, 30 }
    assert(equals({ 20, 30 }, copy(array, 2)))

    array = { 10, 20, 30 }
    assert(equals({ 20 }, copy(array, 2, 1)))

    array = { 10, 20, 30 }
    assert(equals({ 20, 30 }, copy(array, 2, 2)))
end

test.concat = function()
    assert(equals({}, concat({}, {})))

    assert(equals({ 10 }, concat({}, { 10 })))

    assert(equals({ 10 }, concat({ 10 }, {})))

    assert(equals({ 10, 20 }, concat({ 10 }, { 20 })))

    assert(equals({ 10, 20, 30 }, concat({ 10, 20 }, { 30 })))

    assert(equals({ 10, 20, 30 }, concat({ 10 }, { 20, 30 })))
end

test.remove = function()
    assert(equals({}, remove({ 10 }, 1)))

    assert(equals({ 20 }, remove({ 10, 20 }, 1)))

    assert(equals({ 10 }, remove({ 10, 20 }, 2)))

    assert(equals({ 10, 20, 40 }, remove({ 10, 20, 30, 40 }, 3)))
end

test.insert = function()
    assert(equals({ 10 }, insert({ }, 1, 10)))

    assert(equals({ 10, 20 }, insert({ 20 }, 1, 10)))

    assert(equals({ 10, 20 }, insert({ 10 }, 2, 20)))

    assert(equals({ 10, 20, 30, 40 }, insert({ 10, 20, 40 }, 3, 30)))
end

test.iota = function()
    assert(equals({ 1 }, iota(1)))

    assert(equals({ 1 }, iota(1, 1)))

    assert(equals({ 1 }, iota(1, 1, 1)))

    assert(equals({ 1, 2, 3, 4 }, iota(1, 4)))

    assert(equals({ 1, 2, 3, 4 }, iota(4)))
end

test.sort = function()
    local keys = {}
    local values = {}
    sort(keys)
    assert(equals({}, keys))

    keys = { 10 }
    sort(keys)
    assert(equals({ 10 }, keys))

    keys = { 30, 10, 40, 20 }
    sort(keys)
    assert(equals({ 10, 20, 30, 40 }, keys))

    keys = { 30, 10, 40, 20 }
    values = { 'a', 'b', 'c', 'd' }
    sort(keys, values)
    assert(equals({ 10, 20, 30, 40 }, keys))
    assert(equals({ 'b', 'd', 'a', 'c' }, values))
end

return test