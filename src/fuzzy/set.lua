require "src/core/arrays"

local set = {}
set.__index = set

function set.point(x, maxy, tolerance)
    if nil == maxy then
        maxy = 1
    end

    if nil == tolerance then
        tolerance = 1e-8
    end

    return set.linear({ [0] = x - tolerance, x, x + tolerance },
            { [0] = 0, maxy, 0 })
end

function set.linear(x, y, scatter)
    local self = setmetatable({}, set)

    if nil == scatter or 0 == scatter then
        self.x = x
        self.y = y

        local n = len(xs) + scatter * (len(xs) - 1)

        local u = {}
        local v = {}
        local step = 0
        for i = 0, (n - 2) do
            local j = i / (1 + scatter)
            if 0 == i % (1 + scatter) then
                u[i] = x[j]
                v[i] = y[j]
                step = (xs[j + 1] - xs[j]) / (1 + scatter)
            else
                u[i] = u[i - 1] + step
                v[i] = self:get(u[i])
            end
        end

        u[len(u) - 1] = x[len(x) - 1]
        v[len(v) - 1] = y[len(y) - 1]

        self.x = u
        self.y = v
    end

    return self
end

function set.get(self, x)
    local i = lower_bound(self.x, x)

    if 0 == i or (len(self.x) - 1) == i or x == self.x[i] then
        return self.y[i]
    end

    local y = (self.y[i + 1] - self.y[i]) * (x - self.x[i]) / (self.x[i + 1] - self.x[i])

    return y + self.y[i]
end

return set