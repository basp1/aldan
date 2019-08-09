require "src/core/arrays"
local Dataset = require "src/decisions/dataset"
local Id3 = require "src/decisions/id3"

require "test/decisions/id3_data"

local test = {}

test[#test + 1] = function()
    local dataset = Dataset.new()
    dataset:add({ sunny, hot, high, calm }, false)
    dataset:add({ sunny, hot, high, windy }, false)
    dataset:add({ overcast, hot, high, calm }, true)
    dataset:add({ rainy, mild, high, calm }, true)
    dataset:add({ rainy, cool, normal, calm }, true)
    dataset:add({ rainy, cool, normal, windy }, false)
    dataset:add({ overcast, cool, normal, windy }, true)
    dataset:add({ sunny, mild, high, calm }, false)
    dataset:add({ sunny, cool, normal, calm }, true)
    dataset:add({ rainy, mild, normal, calm }, true)
    dataset:add({ sunny, mild, normal, windy }, true)
    dataset:add({ overcast, mild, high, windy }, true)
    dataset:add({ overcast, hot, normal, calm }, true)
    dataset:add({ rainy, mild, high, windy }, false)

    local tree = Id3.build(dataset, { outlook, temp, humidity, wind })
    local paths = tree.tree:all_paths()

    assert(5 == #paths)
end

test[#test + 1] = function()
    local dataset = Dataset.new()
    dataset:add({ rainy, hot, high, calm }, 26)
    dataset:add({ rainy, hot, high, windy }, 30)
    dataset:add({ overcast, hot, high, calm }, 48)
    dataset:add({ sunny, mild, high, calm }, 46)
    dataset:add({ sunny, cool, normal, calm }, 62)
    dataset:add({ sunny, cool, normal, windy }, 23)
    dataset:add({ overcast, cool, normal, windy }, 43)
    dataset:add({ rainy, mild, high, calm }, 36)
    dataset:add({ rainy, cool, normal, calm }, 38)
    dataset:add({ sunny, mild, normal, calm }, 48)
    dataset:add({ rainy, mild, normal, windy }, 48)
    dataset:add({ overcast, mild, high, windy }, 62)
    dataset:add({ overcast, hot, normal, calm }, 44)
    dataset:add({ sunny, mild, high, windy }, 30)

    local tree = Id3.build(dataset, { outlook, temp, humidity, wind })
    local paths = tree.tree:all_paths()

    assert(14 == #paths)

    dataset:add({ sunny, mild, high, windy }, 31)

    tree = Id3.build(dataset, { outlook, temp, humidity, wind })
    paths = tree.tree:all_paths()
    assert(14 == #paths)
end

return test
