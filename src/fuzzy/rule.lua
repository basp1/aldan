require "src/core/arrays"
local fuzzyset = require "src/core/fuzzyset"
local variable = require "src/core/variable"

local rule = {}
rule.__index = rule

function rule.new(antecedent, consequent)
    assert(len(antecedent) > 0)

    local self = setmetatable({}, rule)

    self.antecedent = antecedent
    self.consequent = consequent

    return self
end

function rule.deduct(self, basis)
    local acc = first(self.antecedent).attached

    for i = 1, len(self.antecedent) - 1 do
        local a = self.antecedent[i].attached
        acc = basis:fuzzy_and(acc, a)
    end

    local alpha = acc

    local x = copy(self.consequent.set.x)
    local y = copy(self.consequent.set.y)

    for i = 0, len(y) - 1 do
        y[i] = basis:fuzzy_impl(alpha, y[i])
    end

    local answer = self.consequent.var:add("random_name", fuzzyset.linear(x, y))
    answer = answer:defuzzy()

    return answer
end

return rule