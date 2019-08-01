local flatmap = require "src/core/flatmap"

local test = {}

test[#test+1] = function()
  local map = flatmap:new()

  map:insert(1, 'a')
  map:insert(5, 'e')
  map:insert(3, 'c')

  assert(3 == map:length())
  assert('a' == map:get(1))
  assert('c' == map:get(3))
  assert('e' == map:get(5))

  map:insert(2, 'b')
  map:insert(4, 'd')
  assert(5 == map:length())
  assert('a' == map:get(1))
  assert('b' == map:get(2))
  assert('c' == map:get(3))
  assert('d' == map:get(4))
  assert('e' == map:get(5))

  map:insert(4, 'D')
  assert(5 == map:length())
  assert('a' == map:get(1))
  assert('b' == map:get(2))
  assert('c' == map:get(3))
  assert('D' == map:get(4))
  assert('e' == map:get(5))
end

test[#test+1] = function()
  local map = flatmap:new()

  map:insert(1, 'a')
  map:insert(5, 'e')
  map:insert(3, 'c')
  map:insert(2, 'b')
  map:insert(4, 'd')

  map:remove(3)
  assert(4 == map:length())
  assert('a' == map:get(1))
  assert('b' == map:get(2))
  assert('d' == map:get(4))
  assert('e' == map:get(5))
  assert(not map:contains(3))

  map:remove(1)
  map:remove(4)
  map:remove(5)
  assert(1 == map:length())
  assert('b' == map:get(2))
  assert(not map:contains(3))
  assert(not map:contains(1))
  assert(not map:contains(4))
  assert(not map:contains(5))
end

return test
