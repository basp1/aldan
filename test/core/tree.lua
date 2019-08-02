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

  assert(t:has_successors(t.root))
  assert(2 == len(t:get_successors(t.root)))
  assert(2 == len(t:get_successors(a)))
  assert(1 == len(t:get_successors(b)))
  assert(1 == len(t:get_successors(c)))
  assert(3 == len(t:get_successors(d)))
  assert(1 == len(t:get_successors(e)))
  assert(not t:has_successors(f))
  assert(0 == len(t:get_successors(f)))
  assert(not t:has_successors(g))
  assert(0 == len(t:get_successors(g)))
  assert(not t:has_successors(h))
  assert(0 == len(t:get_successors(h)))
  assert(not t:has_successors(i))
  assert(0 == len(t:get_successors(i)))
  assert(not t:has_successors(j))
  assert(0 == len(t:get_successors(j)))

  assert('a' == t:get_vertex(a))
  assert('b' == t:get_vertex(b))
  assert('c' == t:get_vertex(c))
  assert('d' == t:get_vertex(d))
  assert('e' == t:get_vertex(e))
  assert('f' == t:get_vertex(f))
  assert('g' == t:get_vertex(g))
  assert('h' == t:get_vertex(h))
  assert('i' == t:get_vertex(i))
  assert('j' == t:get_vertex(j))

  assert(t.root == t:get_parent(a))
  assert(t.root == t:get_parent(b))
  assert(a == t:get_parent(c))
  assert(a == t:get_parent(d))
  assert(b == t:get_parent(e))
  assert(c == t:get_parent(f))
  assert(d == t:get_parent(g))
  assert(d == t:get_parent(h))
  assert(d == t:get_parent(i))
  assert(e == t:get_parent(j))

  local paths = t:all_paths()
  assert(not paths:empty())

  assert(5 == paths:length())
end

return test
