local dataset = require "src/decisions/dataset"

local test = {}

test[#test+1] = function()
  local ds = dataset.new()

  assert(0 == ds:length())
  assert(ds:empty())

  ds:add({[0]=1,2,3}, 10)
  assert(1 == ds:length())
  assert(not ds:empty())
  assert(10 == ds:first().output)
  assert(10 == ds:last().output)

  ds:add({[0]=4,5,6}, 20)
  assert(2 == ds:length())
  assert(10 == ds:first().output)
  assert(20 == ds:last().output)
end

return test
