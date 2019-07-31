function len(array)
  local n = #array
  if nil ~= array[0] then
    n = n + 1
  end
  return n
end

function copy(array, from, to)
  local t = {}

  if nil == from then
    from = 0
  end
  if nil == to then
    to = len(array)
  end

  for i = from, (to-1) do
    t[len(t)] = array[i]
  end

  return t
end

function lowerBound(array, item)
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

function binarySearch(array, item)
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

  for i = from, (to-1) do
    array[len(array)] = i
  end

  return array
end

function sort(keys, values)
  assert(len(keys) == len(values))

  local sorted = iota(0, len(keys))
  table.sort(sorted, function(a,b) return keys[a] < keys[b] end)

  permute(keys, sorted)
  permute(values, sorted)
end

function permute(array, indices)
  assert(len(array) == len(indices))

  local n = len(array)
  local t = {}

  for i = 0, (n-1) do
    t[i] = array[indices[i]]
  end

  for i = 0, (n-1) do
    array[i] = t[i]
  end
end
