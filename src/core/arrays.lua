function len(array)
    local n = #array
    if array[0] then
        n = n + 1
    end
    return n
end

function first(array)
    assert(len(array) > 0)

    return array[0]
end

function last(array)
    assert(len(array) > 0)

    return array[len(array) - 1]
end

function max(array)
    assert(len(array) > 0)

    local m = array[0]
    for i = 1, len(array) - 1 do
        if array[i] > m then
            m = array[i]
        end
    end

    return m
end

function min(array)
    assert(len(array) > 0)

    local m = array[0]
    for i = 1, len(array) - 1 do
        if array[i] < m then
            m = array[i]
        end
    end

    return m
end

function any(array, predicate)
    for i = 0, len(array) - 1 do
        if predicate(array[i]) then
            return true
        end
    end
    return false
end

function all(array, predicate)
    for i = 0, len(array) - 1 do
        if not predicate(array[i]) then
            return false
        end
    end
    return true
end

function map(array, func)
    local mapped = {}

    for i = 0, len(array) - 1 do
        mapped[len(mapped)] = func(array[i])
    end

    return mapped
end

function filter(array, predicate)
    local filtered = {}

    for i = 0, len(array) - 1 do
        if predicate(array[i]) then
            filtered[len(filtered)] = array[i]
        end
    end

    return filtered
end

function find_if(array, predicate)
    for i = 0, len(array) - 1 do
        if predicate(array[i]) then
            return array[i]
        end
    end
    return nil
end

function copy(array, from, to)
    local t = {}

    if nil == from then
        from = 0
    end
    if nil == to then
        to = len(array)
    end

    for i = from, (to - 1) do
        t[len(t)] = array[i]
    end

    return t
end

function concat(array1, array2)
    local t = copy(array1)

    for i = 0, len(array2) do
        t[len(t)] = array2[i]
    end

    return t
end

function remove(array, index)
    local t = {}

    for i = 0, len(array) do
        if i ~= index then
            t[len(t)] = array[i]
        end
    end

    return t
end

function insert(array, index, value)
    local t = {}

    for i = 0, len(array) do
        if i == index then
            t[len(t)] = value
        end
        t[len(t)] = array[i]

    end

    return t
end

function lower_bound(array, item)
    local n = len(array) - 1
    local l = 0
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
    assert(len(array) > 0)

    local l = 0
    local r = len(array) - 1

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

    return -1
end

function iota(from, to)
    array = {}

    for i = from, (to - 1) do
        array[len(array)] = i
    end

    return array
end

function sort(keys, values)
    assert(len(keys) == len(values))

    local sorted = iota(0, len(keys))
    table.sort(sorted, function(a, b)
        return keys[a] < keys[b]
    end)

    permute(keys, sorted)
    permute(values, sorted)
end

function permute(array, indices)
    assert(len(array) == len(indices))

    local n = len(array)
    local t = {}

    for i = 0, (n - 1) do
        t[i] = array[indices[i]]
    end

    for i = 0, (n - 1) do
        array[i] = t[i]
    end
end
