local Feature = require "src/decisions/feature"

outlook = Feature.new("Outlook")
sunny = outlook:add("sunny", 0)
overcast = outlook:add("overcast", 1)
rainy = outlook:add("rainy", 2)

temp = Feature.new("Temp")
cool = temp:add("cool", -100, 0)
mild = temp:add("mild", 0, 15)
hot = temp:add("hot", 15, 100)

humidity = Feature.new("Humidity")
low = humidity:add("low", 0)
normal = humidity:add("normal", 1)
high = humidity:add("high", 2)

wind = Feature.new("Wind")
calm = wind:add("calm", 0)
windy = wind:add("windy", 1)
