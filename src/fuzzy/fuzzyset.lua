require "src/core/arrays"
local closure = require "src/core/closure"
local Basis = require "src/fuzzy/basis"

local fuzzyset = {}
fuzzyset.__index = fuzzyset

function fuzzyset.new(func)
    local self = setmetatable({}, fuzzyset)

    self.func = func

    return self
end

function fuzzyset.point(x, y)
    if nil == y then
        y = 1
    end

    return fuzzyset.new(closure.new(function(self, x)
        if x == self.x then
            return self.y
        else
            return 0
        end
    end, { x = x, y = y }))
end

function fuzzyset.linear(x, y)
    return fuzzyset.new(closure.new(function(self, x)
        local i = lower_bound(self.x, x)

        if 0 == i or (i < len(self.x) and x == self.x[i]) then
            return self.y[i]
        end

        if len(self.x) == i then
            return last(self.y)
        end

        i = i - 1
        local y = (self.y[i + 1] - self.y[i]) * (x - self.x[i]) / (self.x[i + 1] - self.x[i])

        return y + self.y[i]
    end, { x = x, y = y }))
end

function fuzzyset.get(self, x)
    return self.func(x)
end

function fuzzyset.copy(self)
    return fuzzyset.new(self.func)
end

function fuzzyset.get_height(self, ref_points)
    assert(len(ref_points) > 0)

    return max(ref_points, function (x)
        return self:get(x)
    end)
end

function fuzzyset.defuzzy(self, ref_points)
    assert(len(ref_points) > 0)

    local numerator = 0
    local denominator = 0

    for i = 1, len(ref_points) - 1 do
        local x = ref_points[i]
        local y = self:get(x)
        numerator = numerator + (x * y)
        denominator = denominator + y
    end

    local result = numerator / denominator

    return result
end

function fuzzyset.set_func(self, func)
    self.func = func
end

return fuzzyset