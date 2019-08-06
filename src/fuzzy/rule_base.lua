require "src/core/arrays"
local rule = require "src/fuzzy/rule"
local variable = require "src/fuzzy/variable"

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
        local var_id = answer.var.id

        if nil == answers[var_id] then
            answers[var_id] = answer
        else
            local other = answers[var_id]
            local x = concat(other.set.x, answer.set.x)
            sort(x)
            local y = {}
            for i = 0, len(x) - 1 do
                y[i] = basis.fuzzy_or(answer.set:get(x[i]), other.set:get(x[i]))
            end
            answer.set.x = x
            answer.set.y = y
            answers[var_id] = answer
        end
    end

    local answer
    local max = 0
    for id, val in pairs(answers) do
        local height = val.set:get_height()
        if height >= max then
            max = height
            answer = val
        end
    end

    answer.var.attached = answer:defuzzy()

    return answer
end

return rule_base