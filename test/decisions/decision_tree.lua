local decision_tree = require "src/decisions/decision_tree"
local feature = require "src/decisions/feature"

local test = {}

test[#test + 1] = function()
    local dt = decision_tree.new()

    local temp = feature.new("Temp")
    local cool = temp:add("cool", -100, 0)
    local mild = temp:add("mild", 0, 15)
    local hot = temp:add("hot", 15, 100)

    local temp_node = dt:add(dt:root(), 'feature', temp)
    local cool_node = dt:add(temp_node, 'case', cool)
    local mild_node = dt:add(temp_node, 'case', mild)
    local hot_node = dt:add(temp_node, 'case', hot)

    dt:add(cool_node, 'item', { -10, -20, -30 })

end

return test
