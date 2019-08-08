require "src/core/arrays"

local rule_base = {}
rule_base.__index = rule_base

function rule_base.new(rules)
    local self = setmetatable({}, rule_base)

    self.rules = rules

    return self
end

function rule_base.infer(self, basis)
    local answers = {}

    for i = 0, #(self.rules) - 1 do
        local rule = self.rules[i]

        local answer = rule:infer(basis)
        local var_id = answer.var.id

        if nil == answers[var_id] then
            answers[var_id] = answer
        else
            local old_answer = answers[var_id]
            local f = old_answer.set.func
            local g = answer.set.func
            answers[var_id].set:set_func(function(x)
                return basis.fuzzy_or(f(x), g(x))
            end)
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

    answer.name = "$" .. answer.var.name
    answer.var.attached = answer:defuzzy()

    return answer
end

return rule_base