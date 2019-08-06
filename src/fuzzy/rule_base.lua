require "src/core/arrays"
local rule = require "src/fuzzy/rule"
local variable = require "src/core/variable"

local rule_base = {}
rule_base.__index = rule_base

function rule_base.new(rules)
    local self = setmetatable({}, rule_base)

    self.rules = rules

    return self
end

function rule_base.infer(self, basis)
    local answers = {}

    for i = 0, len(self.rules) - 1 do
        local rule = self.rules[i]
        local answer = rule:infer(basis)

        answers[answer.id] = answer

        if nil == answer.var.attached then
            answer.var.attached = answer:defuzzy()
        else
            answer.var.attached = basis.fuzzy_or(answer.var.attached, answer:defuzzy())
        end
    end

    local answer
    local max = 0
    for id, val in answers do
        local height = val.set:get_height()
        if height >= max then
            max = height
            answer = val
        end
    end

    return answer
end

return rule_base