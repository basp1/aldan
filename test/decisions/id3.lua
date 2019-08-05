require "src/core/arrays"
local Dataset = require "src/decisions/dataset"
local Id3 = require "src/decisions/id3"

require "test/decisions/id3_data"

local test = {}

test[#test + 1] = function()
    local dataset = Dataset.new()
    dataset:add({ [0] = sunny, hot, high, calm }, false)
    dataset:add({ [0] = sunny, hot, high, windy }, false)
    dataset:add({ [0] = overcast, hot, high, calm }, true)
    dataset:add({ [0] = rainy, mild, high, calm }, true)
    dataset:add({ [0] = rainy, cool, normal, calm }, true)
    dataset:add({ [0] = rainy, cool, normal, windy }, false)
    dataset:add({ [0] = overcast, cool, normal, windy }, true)
    dataset:add({ [0] = sunny, mild, high, calm }, false)
    dataset:add({ [0] = sunny, cool, normal, calm }, true)
    dataset:add({ [0] = rainy, mild, normal, calm }, true)
    dataset:add({ [0] = sunny, mild, normal, windy }, true)
    dataset:add({ [0] = overcast, mild, high, windy }, true)
    dataset:add({ [0] = overcast, hot, normal, calm }, true)
    dataset:add({ [0] = rainy, mild, high, windy }, false)

    local tree = Id3.build(dataset, { [0] = outlook, temp, humidity, wind })
    local paths = tree.tree:all_paths()

    assert(5 == paths:length())
end

test[#test + 1] = function()
    local dataset = Dataset.new()
    dataset:add({ [0] = rainy, hot, high, calm }, 26)
    dataset:add({ [0] = rainy, hot, high, windy }, 30)
    dataset:add({ [0] = overcast, hot, high, calm }, 48)
    dataset:add({ [0] = sunny, mild, high, calm }, 46)
    dataset:add({ [0] = sunny, cool, normal, calm }, 62)
    dataset:add({ [0] = sunny, cool, normal, windy }, 23)
    dataset:add({ [0] = overcast, cool, normal, windy }, 43)
    dataset:add({ [0] = rainy, mild, high, calm }, 36)
    dataset:add({ [0] = rainy, cool, normal, calm }, 38)
    dataset:add({ [0] = sunny, mild, normal, calm }, 48)
    dataset:add({ [0] = rainy, mild, normal, windy }, 48)
    dataset:add({ [0] = overcast, mild, high, windy }, 62)
    dataset:add({ [0] = overcast, hot, normal, calm }, 44)
    dataset:add({ [0] = sunny, mild, high, windy }, 30)

    local tree = Id3.build(dataset, { [0] = outlook, temp, humidity, wind })
    local paths = tree.tree:all_paths()

    assert(14 == paths:length())

    dataset:add({ [0] = sunny, mild, high, windy }, 31)

    tree = Id3.build(dataset, { [0] = outlook, temp, humidity, wind })
    paths = tree.tree:all_paths()
    assert(14 == paths:length())
end

return test
