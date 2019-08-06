require "src/core/arrays"

local fuzzyset = {}
fuzzyset.__index = fuzzyset

function fuzzyset.point(x, maxy, tolerance)
    if nil == maxy then
        maxy = 1
    end

    if nil == tolerance then
        tolerance = 1e-8
    end

    return fuzzyset.linear({ [0] = x - tolerance, x, x + tolerance },
            { [0] = 0, maxy, 0 })
end

function fuzzyset.linear(x, y, scatter)
    local self = setmetatable({}, fuzzyset)

    self.x = x
    self.y = y

    if nil == scatter or 0 == scatter then
        return self
    end

    local n = len(x) + scatter * (len(x) - 1)

    local u = {}
    local v = {}
    local step = 0
    for i = 0, (n - 2) do
        local j = i / (1 + scatter)
        if 0 == i % (1 + scatter) then
            u[i] = x[j]
            v[i] = y[j]
            step = (x[j + 1] - x[j]) / (1 + scatter)
        else
            u[i] = u[i - 1] + step
            v[i] = self:get(u[i])
        end
    end

    u[len(u) - 1] = x[len(x) - 1]
    v[len(v) - 1] = y[len(y) - 1]

    self.x = u
    self.y = v

    return self
end

function fuzzyset.get(self, x)
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
end

function fuzzyset.get_height(self)
    return max(self.y)
end

return fuzzyset