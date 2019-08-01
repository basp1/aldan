require "src/core/arrays"

local dataset = {}
dataset.__index = dataset

function dataset.new()
  local self = setmetatable({}, dataset)

  self.samples = {}

  return self
end

local sample = {}
sample.__index = sample

function dataset.sample(values, output)
  local self = setmetatable({}, sample)

  self.values = values
  self.output = output

  return self
end

function sample.find(self, predicate)
  for i=0,len(self.values)-1 do
    if predicate(self.values[i]) then
      return self.values[i]
    end
  end
  return nil
end

function dataset.add(self, x, output)
  if nil ~= output then
    x = dataset.sample(x, output)
  end
  self.samples[len(self.samples)] = x
end

function dataset.first(self)
  assert(self:length() > 0)

  return self.samples[0]
end

function dataset.last(self)
  assert(self:length() > 0)

  return self.samples[self:length()-1]
end

function dataset.empty(self)
  return 0 == self:length()
end

function dataset.length(self)
  return len(self.samples)
end

function dataset.any(self, predicate)
  for i=0,self:length()-1 do
    if predicate(self.samples[i]) then
      return true
    end
  end
  return false
end

function dataset.all(self, predicate)
  for i=0,self:length()-1 do
    if not predicate(self.samples[i]) then
      return false
    end
  end
  return true
end

function dataset.map(self, func)
  local mapped = {}

  for i=0,self:length()-1 do
    mapped[len(mapped)] = func(self.samples[i])
  end

  return mapped
end

function dataset.filter(self, predicate)
  local that = dataset.new()

  for i=0,self:length()-1 do
    if predicate(self.samples[i]) then
      that.add(self.samples[i])
    end
  end

  return that
end

return dataset
