local var = {}
var.__index = var

function var.new(name)
    local self = setmetatable({}, var)

    self.id = math.random(0, 1e10)
    self.name = name
    self.vals = {}

    return self
end

local val = {}
val.__index = val

function val.new(var, name, set)
    local self = setmetatable({}, val)

    self.id = math.random(0, 1e10)
    self.var = var
    self.name = name
    self.set = ste

    return self
end

function var.add(self, x, set)
    if nil ~= set then
        x = val.new(self, x, set)
    end

    assert(nil == self.vals[x.id])

    self.vals[x.id] = x

    return x
end

return var
