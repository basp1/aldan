local fuzzyset = require "src/fuzzy/fuzzyset"

local test = {}

local tol = 1e-8

test[#test + 1] = function()
    local fs = fuzzyset.linear({ [0] = 10 }, { [0] = 1 })

    assert(math.abs(1 - fs:get(0)) < tol)
    assert(math.abs(1 - fs:get(10)) < tol)
    assert(math.abs(1 - fs:get(100)) < tol)
end

test[#test + 1] = function()
    local fs = fuzzyset.linear({ [0] = 5, 10 }, { [0] = 0, 1 })

    assert(math.abs(fs:get(0)) < tol)
    assert(math.abs(fs:get(5)) < tol)
    assert(math.abs(1 - fs:get(10)) < tol)
    assert(math.abs(1 - fs:get(100)) < tol)

    assert(1 > fs:get(9.87))
    assert(fs:get(9.87) > 0)
    assert(fs:get(9.88) > fs:get(9.87))
    assert(fs:get(9.87) > fs:get(9.86))
end

test[#test + 1] = function()
    local fs = fuzzyset.linear({ [0] = 5, 10 }, { [0] = 1, 0 })

    assert(math.abs(1 - fs:get(0)) < tol)
    assert(math.abs(1 - fs:get(5)) < tol)
    assert(math.abs(fs:get(10)) < tol)
    assert(math.abs(fs:get(100)) < tol)

    assert(1 > fs:get(9.87))
    assert(fs:get(9.87) > 0)
    assert(fs:get(9.88) < fs:get(9.87))
    assert(fs:get(9.87) < fs:get(9.86))
end

test[#test + 1] = function()
    local fs = fuzzyset.linear({ [0] = 5, 10, 15 }, { [0] = 0, 1, 0 })

    assert(math.abs(fs:get(0)) < tol)
    assert(math.abs(fs:get(5)) < tol)
    assert(math.abs(1 - fs:get(10)) < tol)
    assert(math.abs(fs:get(50)) < tol)

    assert(1 > fs:get(9.87))
    assert(fs:get(9.87) > 0)
    assert(fs:get(9.88) > fs:get(9.87))
    assert(fs:get(9.87) > fs:get(9.86))
end

return test