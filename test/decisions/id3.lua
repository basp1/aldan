local Feature = require "src/decisions/feature"
local Dataset = require "src/decisions/dataset"
local Id3 = require "src/decisions/id3"

local test = {}

test[#test+1] = function()
  local outlook = Feature.new("Outlook")
  local sunny = outlook:add("sunny", 0)
  local overcast = outlook:add("overcast", 1)
  local rainy = outlook:add("rainy", 2)

  local temp = Feature.new("Temp")
  local cool = temp:add("cool", -100, 0)
  local mild = temp:add("mild", 0, 15)
  local hot = temp:add("hot", 15, 100)

  local humidity = Feature.new("Humidity")
  local low = humidity:add("low", 0)
  local normal humidity:add("normal", 1)
  local high = humidity:add("high", 2)

  local wind = Feature.new("Wind")
  local calm = wind:add("calm", 0)
  local windy = wind:add("windy", 1)

  local dataset = Dataset.new()
  dataset:add({[0]=rainy, hot, high, calm}, 26)
  dataset:add({[0]=rainy, hot, high, windy}, 30)
  dataset:add({[0]=overcast, hot, high, calm}, 48)
  dataset:add({[0]=sunny, mild, high, calm}, 46)
  dataset:add({[0]=sunny, cool, normal, calm}, 62)
  dataset:add({[0]=sunny, cool, normal, windy}, 23)
  dataset:add({[0]=overcast, cool, normal, windy}, 43)
  dataset:add({[0]=rainy, mild, high, calm}, 36)
  dataset:add({[0]=rainy, cool, normal, calm}, 38)
  dataset:add({[0]=sunny, mild, normal, calm}, 48)
  dataset:add({[0]=rainy, mild, normal, windy}, 48)
  dataset:add({[0]=overcast, mild, high, windy}, 62)
  dataset:add({[0]=overcast, hot, normal, calm}, 44)
  dataset:add({[0]=sunny, mild, high, windy}, 30)

  local tree = Id3.build(dataset, {[0]=outlook, temp, humidity, wind})
end

return test
