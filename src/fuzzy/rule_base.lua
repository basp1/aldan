require "src/core/arrays"
local closure = require "src/core/closure"
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
            local old_answer = answers[var_id]
            answers[var_id].set:set_func(closure.new(
                    function(self, x)
                        return self.basis.fuzzy_or(self.f(x), self.g(x))
                    end,
                    { f = old_answer.set.func, g = answer.set.func, basis = basis }))
        end
    end

    local answer
    local max = 0
    for _, val in pairs(answers) do
        local height = val:get_height()
        if height >= max then
            max = height
            answer = val
        end
    end

    answer.var.attached = answer:defuzzy()

    return answer
end

return rule_base