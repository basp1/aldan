require "src/core/arrays"

local stack = {}
stack.__index = stack

function stack.new()
    local self = setmetatable({}, stack)

    self.list = {}

    return self
end

function stack.push(self, value)
    table.insert(self.list, value)
end

function stack.pop(self)
    local value = self:top()

    self.list[#(self.list)] = nil

    return value
end

function stack.length(self)
    return #(self.list)
end

function stack.top(self)
    return last(self.list)
end

function stack.empty(self)
    return 0 == #(self.list)
end

function stack.to_array(self)
    return copy(self.list)
end

return stack
