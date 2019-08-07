local closure = {}

closure.__index = closure
closure.__call = function(self, x)
    return self.func(self.params, x)
end

function closure.new(func, params)
    local self = setmetatable({}, closure)

    self.func = func
    self.params = params

    return self
end

return closure