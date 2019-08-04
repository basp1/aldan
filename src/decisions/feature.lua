require "src/core/arrays"

local feature = {}
feature.__index = feature

function feature.new(name)
    local self = setmetatable({}, feature)

    self.id = math.random(0, 1e10)
    self.name = name
    self.cases = {}

    return self
end

local case = {}
case.__index = case

function case.new(feature, name, from, to)
    local self = setmetatable({}, case)

    self.id = math.random(0, 1e10)
    self.feature = feature
    self.name = name
    self.from = from
    self.to = to

    return self
end

function case.distance(self, value)
    if value > self.from and value < self.to then
        return 0
    else
        return math.min(math.abs(value - self.from), math.abs(value - self.ti))
    end
end

function feature.add(self, x, from, to)
    if nil == to then
        to = from
    end
    if nil ~= from then
        x = case.new(self, x, from, to)
    end

    assert(nil == self.cases[x.id])

    self.cases[x.id] = x

    return x
end

return feature
