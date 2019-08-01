require "src/core/arrays"

local priority_queue = {}
priority_queue.__index = priority_queue

function priority_queue.new(selectFunc)
  local self = setmetatable({}, priority_queue)

  self.values = {}
  self.selectFunc = selectFunc
  self.length = 0

  return self
end

function priority_queue.push(self, value)
  local t index = self.length

  if len(self.values) <= index then
    self.values[len(self.values)] = value
  else
    self.values[index] = value
  end

  self.length = self.length + 1

  self:promote(index)
end

function priority_queue.pop(self)
  assert(self.length > 0)

  local t = self:top()

  if 1 == self.length then
    self.length = 0
  else
    local last = self.values[self.length - 1]
    self.values[0] = last
    self.length = self.length - 1

    self:demote(0)
  end

  return t
end

function priority_queue.top(self)
  assert(self.length > 0)

  return self.values[0]
end

function priority_queue.height(self)
  return 1 + math.floor(math.log(self.length) / math.log(2))
end

function priority_queue.promote(self, index)
  assert(index >= 0 and index < self.length)

  if 0 == index then
    return
  end

  local parent = math.floor(index / 2)

  while index > 0 do
    local t = self.values[index]

    if t ~= self.selectFunc(t, self.values[parent])
    then
      break
    end

    self.values[index] = self.values[parent]
    self.values[parent] = t

    local next = parent
    parent = math.floor(index / 2)
    index = next
  end
end

function priority_queue.demote(self, index)
  assert(index >= 0 and index < self.length)

  if self.length == (1 + index) then
    return
  end

  local value = self.values[index]

  while index < self.length do
    local right = (1 + index) * 2
    local rv
    if right < self.length then
      rv = self.values[right]
    end

    local left = right - 1
    local lv
    if left < self.length then
      lv = self.values[left]
    end

    local child = -1
    if right < self.length and left < self.length and lv == self.selectFunc(lv, rv)
    then
      child = left
    elseif right < self.length
    then
      child = right
    elseif left < self.length
    then
      child = left
    end

    if child < 0 or value == self.selectFunc(value, self.values[child])
    then
      break
    else
      self.values[index] = self.values[child]
      self.values[child] = value
      index = child
    end
  end
end

return priority_queue
