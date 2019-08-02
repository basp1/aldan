local time = require "time"
local timeseries = require "src/core/timeseries"

local test = {}

test[#test+1] = function()
  local ts = timeseries.new()

  assert(0 == ts:length())

  local time1 = time.date(2000, 3, 17) + time.period(10, 30)

  ts:add(time1, 10)

  assert(1 == ts:length())
  assert(10 == ts:get(time1)[2])

  local found, x = ts:get_exact(time1)
  assert(found)
  assert(10 == x)

  local t = time1 - time.minutes(1)
  assert(10 == ts:get(t)[2])

  found, x = ts:get_exact(t)
  assert(not found)


  local time2 = time.date(2000, 3, 17) + time.period(10, 31, 0)

  ts:add(time2, 20)

  assert(2 == ts:length())
  assert(20 == ts:get(time2)[2])

  found, x = ts:get_exact(time2)
  assert(found)
  assert(20 == x)

  t = time1 + time.seconds(25)
  assert(20 == ts:get(t)[2])

  found, x = ts:get_exact(t)
  assert(not found)
end

return test
