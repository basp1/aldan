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

function sample.find_if(self, predicate)
  return find_if(self.values, predicate)
end

function dataset.add(self, x, output)
  if nil ~= output then
    x = dataset.sample(x, output)
  end
  self.samples[len(self.samples)] = x
end

function dataset.first(self)
  return first(self.samples)
end

function dataset.last(self)
  return last(self.samples)
end

function dataset.empty(self)
  return 0 == self:length()
end

function dataset.length(self)
  return len(self.samples)
end

function dataset.any(self, predicate)
  return any(self.samples, predicate)
end

function dataset.all(self, predicate)
  return all(self.samples, predicate)
end

function dataset.map(self, func)
  return map(self.samples, func)
end

function dataset.filter(self, predicate)
  local that = dataset.new()
  local filtered = filter(self.samples, predicate)

  for i=0,len(filtered)-1 do
    that.add(filtered[i])
  end

  return that
end

return dataset
