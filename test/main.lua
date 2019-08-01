function run(testname)
  print("run " .. testname)
  local test = require(testname)
  for name,func in pairs(test) do
    func()
    print(name .. " passed")
  end
end

local start = os.clock()

run("test/core/arrays")
run("test/core/flatmap")
run("test/core/graph")
run("test/core/intlist")
run("test/core/priority_queue")
run("test/core/stack")
run("test/core/timeseries")
run("test/core/tree")

local stop = os.clock()

print("")
print("All tests passed (" .. math.floor(1e3 * (stop-start)) .. "ms)" )
