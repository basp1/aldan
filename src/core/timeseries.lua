local Time = require "time"
require "src/core/arrays"

local timeseries = {}
timeseries.__index = timeseries

function timeseries.new()
  local self = setmetatable({}, timeseries)

  self.times = {}
  self.items = {}

  return self
end

function timeseries.first(self)
  assert(not self.items.empty())

  return {self.times[0], self.items[0]}
end

function timeseries.last(self)
  assert(not self.items.empty())

  return {last(self.times), last(self.items)}
end

function timeseries.length(self)
  return len(self.times)
end

function timeseries.add(self, time, item)
  assert(0 == self:length() or time >= last(self.times))

  self.times[len(self.times)] = time
  self.items[len(self.items)] = item
end

function timeseries.insert(self, time, item)
  local index = lowerBound(self.times, time)

  if index >= 0 and index < self:length() and time == self.times[index] then
    self.times[index] = time
    self.items[index] = item
  else
    self.times = insert(self.times, index, time)
    self.items = insert(self.items, index, item)
  end
end

function timeseries.get(self, time)
  local index = lowerBound(self.times, time)

  assert(index >= 0 and index < self:length())

  return {self.times[index], self.items[index]}
end

function timeseries.getExact(self, time)
  local x = self:get(time)

  if x[1] ~= time then
    return false
  else
    item = x[2]
    return true, x[2]
  end
end

function timeseries.interval(self, from, to)
  local ts = timeseries.new()

  local index = lowerBound(self.times, from)

  local n = self:length()
  local i = index
  while i < n and self.times[i] < to do
    ts:insert(self.times[i], self.items[i])
    i = i + 1
  end

  return ts
end

return timeseries
