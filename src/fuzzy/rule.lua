require "src/core/arrays"
local closure = require "src/core/closure"
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

    local answer = self.consequent:copy()
    local alpha = acc
    local f = self.consequent.set.func
    answer.set:set_func(function(x)
        return basis.fuzzy_impl(alpha, f(x))
    end)
    return answer
end

return rule