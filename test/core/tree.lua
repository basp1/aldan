require "src/core/arrays"
local tree = require "src/core/tree"

local test = {}

test[#test+1] = function()
  local t = tree.new()

  local a = t:add(t.root, 'a')
  local b = t:add(t.root, 'b')
  local c = t:add(a, 'c')
  local d = t:add(a, 'd')
  local e = t:add(b, 'e')
  local f = t:add(c, 'f')
  local g = t:add(d, 'g')
  local h = t:add(d, 'h')
  local i = t:add(d, 'i')
  local j = t:add(e, 'j')

  assert(t:hasSuccessors(t.root))
  assert(2 == len(t:getSuccessors(t.root)))
  assert(2 == len(t:getSuccessors(a)))
  assert(1 == len(t:getSuccessors(b)))
  assert(1 == len(t:getSuccessors(c)))
  assert(3 == len(t:getSuccessors(d)))
  assert(1 == len(t:getSuccessors(e)))
  assert(not t:hasSuccessors(f))
  assert(0 == len(t:getSuccessors(f)))
  assert(not t:hasSuccessors(g))
  assert(0 == len(t:getSuccessors(g)))
  assert(not t:hasSuccessors(h))
  assert(0 == len(t:getSuccessors(h)))
  assert(not t:hasSuccessors(i))
  assert(0 == len(t:getSuccessors(i)))
  assert(not t:hasSuccessors(j))
  assert(0 == len(t:getSuccessors(j)))

  assert('a' == t:getVertex(a))
  assert('b' == t:getVertex(b))
  assert('c' == t:getVertex(c))
  assert('d' == t:getVertex(d))
  assert('e' == t:getVertex(e))
  assert('f' == t:getVertex(f))
  assert('g' == t:getVertex(g))
  assert('h' == t:getVertex(h))
  assert('i' == t:getVertex(i))
  assert('j' == t:getVertex(j))

  assert(t.root == t:getParent(a))
  assert(t.root == t:getParent(b))
  assert(a == t:getParent(c))
  assert(a == t:getParent(d))
  assert(b == t:getParent(e))
  assert(c == t:getParent(f))
  assert(d == t:getParent(g))
  assert(d == t:getParent(h))
  assert(d == t:getParent(i))
  assert(e == t:getParent(j))

  local paths = t:allPaths()
  assert(not paths:empty())

  assert(5 == paths:length())
end

return test
