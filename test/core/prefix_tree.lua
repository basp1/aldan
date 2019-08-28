local prefix_tree = require "src/core/prefix_tree"

local test = {}

test[#test + 1] = function()
    local pt = prefix_tree.new()
    assert(nil ~= pt)

    pt:add({ 'a' }, 'a')
    assert('a' == pt:find({ 'a' }))
    assert(nil == pt:find({ 'b' }))
    assert(nil == pt:find({ 'a', 'b' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'c' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'd' }))
    assert(1 == #pt:all_paths())

    pt:add({ 'a' }, 'a!')
    assert('a!' == pt:find({ 'a' }))
    assert(nil == pt:find({ 'b' }))
    assert(nil == pt:find({ 'a', 'b' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'c' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'd' }))
    assert(1 == #pt:all_paths())

    pt:add({ 'b' }, 'b')
    assert('a!' == pt:find({ 'a' }))
    assert('b' == pt:find({ 'b' }))
    assert(nil == pt:find({ 'a', 'b' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'c' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'd' }))
    assert(2 == #pt:all_paths())

    pt:add({ 'a', 'b' }, 'ab')
    assert('a!' == pt:find({ 'a' }))
    assert('b' == pt:find({ 'b' }))
    assert('ab' == pt:find({ 'a', 'b' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'c' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'd' }))
    assert(2 == #pt:all_paths())

    pt:add({ 'a', 'b', 'b', 'c' }, 'abbc')
    assert('a!' == pt:find({ 'a' }))
    assert('b' == pt:find({ 'b' }))
    assert('ab' == pt:find({ 'a', 'b' }))
    assert('abbc' == pt:find({ 'a', 'b', 'b', 'c' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'd' }))
    assert(2 == #pt:all_paths())

    pt:add({ 'a', 'b', 'b', 'd' }, 'abbd')
    assert('a!' == pt:find({ 'a' }))
    assert('b' == pt:find({ 'b' }))
    assert('ab' == pt:find({ 'a', 'b' }))
    assert('abbc' == pt:find({ 'a', 'b', 'b', 'c' }))
    assert('abbd' == pt:find({ 'a', 'b', 'b', 'd' }))
    assert(3 == #pt:all_paths())
end

test[#test + 1] = function()
    local pt = prefix_tree.new()
    assert(nil ~= pt)

    pt:add({ 'a', 'b', 'b', 'd' }, 'abbd')
    assert(nil == pt:find({ 'a' }))
    assert(nil == pt:find({ 'b' }))
    assert(nil == pt:find({ 'a', 'b' }))
    assert(nil == pt:find({ 'a', 'b', 'b', 'c' }))
    assert('abbd' == pt:find({ 'a', 'b', 'b', 'd' }))

    pt:add({ 'a', 'b', 'b', 'c' }, 'abbc')
    assert(nil == pt:find({ 'a' }))
    assert(nil == pt:find({ 'b' }))
    assert(nil == pt:find({ 'a', 'b' }))
    assert('abbc' == pt:find({ 'a', 'b', 'b', 'c' }))
    assert('abbd' == pt:find({ 'a', 'b', 'b', 'd' }))

    pt:add({ 'a' }, 'a')
    assert('a' == pt:find({ 'a' }))
    assert(nil == pt:find({ 'b' }))
    assert(nil == pt:find({ 'a', 'b' }))
    assert('abbc' == pt:find({ 'a', 'b', 'b', 'c' }))
    assert('abbd' == pt:find({ 'a', 'b', 'b', 'd' }))

    pt:add({ 'a' }, 'a!')
    assert('a!' == pt:find({ 'a' }))
    assert(nil == pt:find({ 'b' }))
    assert(nil == pt:find({ 'a', 'b' }))
    assert('abbc' == pt:find({ 'a', 'b', 'b', 'c' }))
    assert('abbd' == pt:find({ 'a', 'b', 'b', 'd' }))

    pt:add({ 'b' }, 'b')
    assert('a!' == pt:find({ 'a' }))
    assert('b' == pt:find({ 'b' }))
    assert(nil == pt:find({ 'a', 'b' }))
    assert('abbc' == pt:find({ 'a', 'b', 'b', 'c' }))
    assert('abbd' == pt:find({ 'a', 'b', 'b', 'd' }))

    pt:add({ 'a', 'b' }, 'ab')
    assert('a!' == pt:find({ 'a' }))
    assert('b' == pt:find({ 'b' }))
    assert('ab' == pt:find({ 'a', 'b' }))
    assert('abbc' == pt:find({ 'a', 'b', 'b', 'c' }))
    assert('abbd' == pt:find({ 'a', 'b', 'b', 'd' }))
end

return test
