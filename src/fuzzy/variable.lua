local variable = {}
variable.__index = variable

function variable.new(name)
    local self = setmetatable({}, variable)

    self.id = math.random(0, 1e10)
    self.name = name
    self.values = {}
    self.attached = nil

    return self
end

local value = {}
value.__index = value

function value.new(var, name, set)
    local self = setmetatable({}, value)

    self.id = math.random(0, 1e10)
    self.var = var
    self.name = name
    self.set = set

    return self
end

function variable.add(self, x, set)
    if nil ~= set then
        x = value.new(self, x, set)
    end

    assert(nil == self.values[x.id])

    self.values[x.id] = x

    return x
end

function variable.remove(self, val)
    self.values[val.id] = nil
end

function value.defuzzy(self)
    local numerator = 0
    local denominator = 0

    for i = 0, len(self.set.x) - 1 do
        numerator = numerator + (self.set.x[i] * self.set.y[i])
        denominator = denominator + self.set.y[i]
    end

    local result = numerator / denominator

    return result
end

return variable
