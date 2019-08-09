function equals(a, b)
    if a == b then
        return true
    end

    if #a ~= #b then
        return false
    end

    for i = 1, #a do
        if a[i] ~= b[i] then
            return false
        end
    end

    return true
end

function empty(array)
    return nil == array or 0 == #(array)
end

function first(array)
    assert(#(array) > 0)

    return array[1]
end

function last(array)
    assert(#(array) > 0)

    return array[#(array)]
end

function max(array, func)
    return array[max_index(array, func)]
end

function max_index(array, func)
    assert(#(array) > 0)

    if nil == func then
        func = function(x)
            return x
        end
    end

    local m = 1
    local x = func(array[1])
    for i = 2, #(array) do
        local a = func(array[i])
        if a > x then
            m = i
            x = a
        end
    end

    return m
end

function min(array, func)
    return array[min_index(array, func)]
end

function min_index(array, func)
    assert(#(array) > 0)

    if nil == func then
        func = function(x)
            return x
        end
    end

    local m = 1
    local x = func(array[1])
    for i = 2, #(array) do
        local a = func(array[i])
        if a < x then
            m = i
            x = a
        end
    end

    return m
end

function any(array, predicate)
    for i = 1, #(array) do
        if predicate(array[i]) then
            return true
        end
    end
    return false
end

function all(array, predicate)
    for i = 1, #(array) do
        if not predicate(array[i]) then
            return false
        end
    end
    return true
end

function map(array, func)
    local mapped = {}

    for i = 1, #(array) do
        table.insert(mapped, func(array[i]))
    end

    return mapped
end

function filter(array, predicate)
    local filtered = {}

    for i = 1, #(array) do
        if predicate(array[i]) then
            table.insert(filtered, array[i])
        end
    end

    return filtered
end

function find_if(array, predicate)
    for i = 1, #(array) do
        if predicate(array[i]) then
            return array[i]
        end
    end
    return nil
end

function copy(array, from, to)
    local t = {}

    if nil == from then
        from = 1
    end
    if nil == to then
        to = #(array)
    end

    for i = from, to do
        table.insert(t, array[i])
    end

    return t
end

function concat(array1, array2)
    local t = copy(array1)

    for i = 0, #(array2) do
        table.insert(t, array2[i])

    end

    return t
end

function remove(array, index)
    local t = {}

    for i = 1, #(array) do
        if i ~= index then
            table.insert(t, array[i])
        end
    end

    return t
end

function insert(array, index, value)
    local t = {}

    if index == (1 + #(array)) then
        t = copy(array)
        table.insert(t, value)
    else
        for i = 1, #(array) + 1 do
            if i == index then
                table.insert(t, value)
            end
            table.insert(t, array[i])
        end
    end

    return t
end

function lower_bound(array, item)
    local n = #(array)
    local l = 1
    local r = n

    while l <= r do
        local m = math.floor(l + (r - l) / 2)
        if item == array[m] then
            return m
        end

        if item < array[m] then
            r = m - 1
        else
            l = m + 1
        end
    end

    return l
end

function binary_search(array, item)
    assert(#(array) > 0)

    local l = 1
    local r = #(array)

    while l <= r do
        local m = math.floor(l + (r - l) / 2)

        if item == array[m] then
            return m
        elseif item < array[m] then
            r = m - 1
        else
            l = m + 1
        end
    end

    return 0
end

function iota(from, count, step)
    if nil == step then
        step = 1
    end

    array = {}

    for i = from, (from + count), step do
        table.insert(array, i)
    end

    return array
end

function sort(keys, values)
    if nil == values then
        table.sort(keys)
        return
    end

    assert(#(keys) == #(values))

    local sorted = iota(1, #(keys))
    table.sort(sorted, function(a, b)
        return keys[a] < keys[b]
    end)

    permute(keys, sorted)
    permute(values, sorted)
end

function unique(array)
    local set = {}
    local j = 1
    for i = 1, #(array) do
        if nil == set[array[i]] then
            set[array[i]] = true
            array[j] = array[i]
            j = j + 1
        end
    end
    local n = #(array)
    for i = j, n do
        array[i] = nil
    end

    return array
end

function permute(array, indices)
    assert(#(array) == #(indices))

    local n = #(array)
    local t = {}

    for i = 1, n do
        t[i] = array[indices[i]]
    end

    for i = 1, n do
        array[i] = t[i]
    end
end
