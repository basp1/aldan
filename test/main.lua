function run(testname)
  print("run " .. testname)
  local test = require(testname)
  for name,func in pairs(test) do
    func()
    print(name .. " passed")
  end
end

run("test/core/arrays")
run("test/core/graph")
run("test/core/stack")
