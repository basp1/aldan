math.randomseed(os.time())

function run(testname)
    print("run " .. testname)
    local test = require(testname)
    for name, func in pairs(test) do
        func()
        print("'" .. name .. "' passed")
    end
end

local start = os.clock()

run("test/core/arrays")
run("test/core/flatmap")
run("test/core/graph")
run("test/core/intlist")
run("test/core/prefix_tree")
run("test/core/priority_queue")
run("test/core/stack")
run("test/core/timeseries")
run("test/core/tree")

run("test/decisions/dataset")
run("test/decisions/decision_tree")
run("test/decisions/feature")
run("test/decisions/id3")

run("test/fuzzy/fuzzyset")
run("test/fuzzy/rule_base")

local stop = os.clock()

print("")
print("All tests passed (" .. math.floor(1e3 * (stop - start)) .. "ms)")
