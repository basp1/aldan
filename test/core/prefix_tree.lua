local prefix_tree = require "src/core/prefix_tree"

local test = {}

test[#test + 1] = function()
    local pt = prefix_tree.new()
    assert(nil ~= pt)
    assert(0 == #pt:all_paths())

    pt:add({ 'a' }, 'a')
    assert(1 == #pt:all_paths())

    pt:add({ 'a' }, '!')
    assert(2 == #pt:all_paths())

    pt:add({ 'b' }, 'b')
    assert(3 == #pt:all_paths())

    pt:add({ 'a', 'b' }, 'ab')
    assert(4 == #pt:all_paths())

    pt:add({ 'a', 'b', 'b', 'c' }, 'abbc')
    assert(5 == #pt:all_paths())

    pt:add({ 'a', 'b', 'b', 'd' }, 'abbd')
    assert(6 == #pt:all_paths())
end

return test
