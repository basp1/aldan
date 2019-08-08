require "src/core/arrays"
local basis = require "src/fuzzy/basis"
local fuzzyset = require "src/fuzzy/fuzzyset"
local variable = require "src/fuzzy/variable"
local rule = require "src/fuzzy/rule"
local rule_base = require "src/fuzzy/rule_base"

local test = {}

local tol = 1e-8

test[#test + 1] = function()
    local a1 = variable.new("a1", 0, 2)
    local a11 = a1:add("a11", fuzzyset.point(1, 0.7))
    local a12 = a1:add("a12", fuzzyset.point(1, 0.6))

    local a2 = variable.new("a2", 0, 2)
    local a21 = a2:add("a21", fuzzyset.point(2, 0.3))
    local a22 = a2:add("a22", fuzzyset.point(2, 0.8))

    local b = variable.new("b", 0, 10)
    local b1 = b:add("b1", fuzzyset.point(8))
    local b2 = b:add("b2", fuzzyset.point(4))

    local rb = rule_base.new({ rule.new({ a11, a21 }, b1),
                               rule.new({ a12, a22 }, b2) })
    a1.attached = 1
    a2.attached = 2

    local answer = rb:infer(basis.mamdani)
    answer = answer:defuzzy()

    assert(math.abs(5.3333333333 - answer) < 1e-8)
end

test[#test + 1] = function()
    local temp = variable.new("temperature", 0, 100)

    local cold = temp:add("cold", fuzzyset.linear({ 5, 10 }, { 1, 0 }))
    local cool = temp:add("cool", fuzzyset.linear({ 5, 12, 17 }, { 0, 1, 0 }))
    local right = temp:add("right", fuzzyset.linear({ 15, 20, 25 }, { 0, 1, 0 }))
    local warm = temp:add("warm", fuzzyset.linear({ 20, 26, 32 }, { 0, 1, 0 }))
    local hot = temp:add("hot", fuzzyset.linear({ 30, 35 }, { 0, 1 }))

    local speed = variable.new("speed", 0, 100)
    local stop = speed:add("stop", fuzzyset.linear({ 0, 20 }, { 1, 0 }))
    local slow = speed:add("slow", fuzzyset.linear({ 10, 30, 50 }, { 0, 1, 0 }))
    local medium = speed:add("medium", fuzzyset.linear({ 40, 60, 80 }, { 0, 1, 0 }))
    local fast = speed:add("fast", fuzzyset.linear({ 60, 80, 100 }, { 0, 1, 0 }))
    local blast = speed:add("blast", fuzzyset.linear({ 80, 100 }, { 0, 1 }))

    local rb = rule_base.new({ rule.new({ cold }, stop),
                               rule.new({ cool }, slow),
                               rule.new({ right }, medium),
                               rule.new({ warm }, fast),
                               rule.new({ hot }, blast) })

    temp.attached = 16

    local answer = rb:infer(basis.mamdani)
    answer = answer:defuzzy()

    assert(math.abs(45 - answer) < 1e-8)
end

return test