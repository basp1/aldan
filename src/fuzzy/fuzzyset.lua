require "src/core/arrays"

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

    return fuzzyset.new(function(a)
        if math.abs(a - x) < 1e-8 then
            return y
        else
            return 0
        end
    end)
end

function fuzzyset.linear(x, y)
    return fuzzyset.new(function(a)
        local i = lower_bound(x, a)

        if 1 == i or (i <= #(x) and a == x[i]) then
            return y[i]
        end

        if i >= #(x) then
            return last(y)
        end

        i = i - 1
        local b = (y[i + 1] - y[i]) * (a - x[i]) / (x[i + 1] - x[i])

        return b + y[i]
    end)
end

function fuzzyset.get(self, x)
    return self.func(x)
end

function fuzzyset.copy(self)
    return fuzzyset.new(self.func)
end

function fuzzyset.get_height(self, ref_points)
    assert(#(ref_points) > 0)

    return max(ref_points, function(x)
        return self:get(x)
    end)
end

function fuzzyset.defuzzy(self, ref_points)
    assert(#(ref_points) > 0)

    local numerator = 0
    local denominator = 0

    for i = 1, #(ref_points) do
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