require "src/core/arrays"

local test = {}

test[#test+1] = function()
  local array = {[0]=0, 1, 2, 3, 4, 5, 6, 8, 9, 10}

  assert(-1 == binarySearch(array, -10))

  assert(-1 ~= binarySearch(array, 0))

  assert(-1 ~= binarySearch(array, 4))

  assert(-1 ~= binarySearch(array, 5))

  assert(-1 ~= binarySearch(array, 9))

  assert(-1 == binarySearch(array, 7))

  assert(-1 == binarySearch(array, 100))
end

test[#test+1] = function()
  local array = {[0]=0, 1, 2, 3, 4, 5, 6, 8, 9, 10}

  assert(0 == lowerBound(array, -10))

  assert(0 == lowerBound(array, 0))

  assert(4 == lowerBound(array, 4))

  assert(5 == lowerBound(array, 5))

  assert(8 == lowerBound(array, 9))

  assert(7 == lowerBound(array, 7))

  assert(9 == lowerBound(array, 10))

  assert(10 == lowerBound(array, 100))
end

return test