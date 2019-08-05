local rule = {}
rule.__index = rule

function rule.new(antecedent, consequent)
    local self = setmetatable({}, rule)

    self.antecedent = antecedent
    self.consequent = consequent

    return self
end