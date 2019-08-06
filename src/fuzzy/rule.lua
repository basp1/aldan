require "src/core/arrays"
local fuzzyset = require "src/fuzzy/fuzzyset"

local rule = {}
rule.__index = rule

function rule.new(antecedent, consequent)
    assert(len(antecedent) > 0)

    local self = setmetatable({}, rule)

    self.antecedent = antecedent
    self.consequent = consequent

    return self
end

function rule.infer(self, basis)
    local first = first(self.antecedent)
    local acc = first.set:get(first.var.attached)

    for i = 1, len(self.antecedent) - 1 do
        local a = self.antecedent[i].set:get(self.antecedent[i].var.attached)
        acc = basis.fuzzy_and(acc, a)
    end

    local alpha = acc

    local x = copy(self.consequent.set.x)
    local y = copy(self.consequent.set.y)

    for i = 0, len(y) - 1 do
        y[i] = basis.fuzzy_impl(alpha, y[i])
    end

    local answer = self.consequent.var:add("$" .. self.consequent.var.name, fuzzyset.linear(x, y))
    self.consequent.var:remove(answer)

    return answer
end

return rule