require "src/core/arrays"

local stack = {}
stack.__index = stack

function stack.new()
  local self = setmetatable({}, stack)

  self.list = {}
  
  return self
end

function stack.push(self, value)
  self.list[len(self.list)] = value
end

function stack.pop(self)
  local value = self:top()

  self.list[len(self.list) - 1] = nil

  return value
end

function stack.length(self)
  return len(self.list)
end

function stack.top(self)
  return self.list[len(self.list) - 1]
end

function stack.empty(self)
  return 0 == len(self.list)
end

function stack.to_array(self)
  return copy(self.list, 0, len(self.list))
end

return stack
