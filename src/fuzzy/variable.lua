local variable = {}
variable.__index = variable

function variable.new(name, min, max)
    assert(min <= max)

    local self = setmetatable({}, variable)

    self.id = math.random(0, 1e10)
    self.name = name
    self.min = min
    self.max = max
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

function value.get_height(self, step)
    if nil == step then
        step = (self.var.max - self.var.min) / 10
    end

    local ref_points = {}
    local x = self.var.min
    while x <= self.var.max do
        ref_points[len(ref_points)] = x
        x = x + step
    end

    return self.set:get_height(ref_points)
end

function value.defuzzy(self, step)
    if nil == step then
        step = (self.var.max - self.var.min) / 10
    end

    local ref_points = {}
    local x = self.var.min
    while x <= self.var.max do
        ref_points[len(ref_points)] = x
        x = x + step
    end

    return self.set:defuzzy(ref_points)
end

function value.copy(self)
    return value.new(self.var, self.name, self.set)
end

return variable
