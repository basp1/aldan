require "src/core/arrays"
local decision_tree = require("src/decisions/decision_tree")

local id3 = {}
id3.__index = id3

local function incf(map, key)
    if nil == map[key] then
        map[key] = 0
    end
    map[key] = map[key] + 1
end

local function entropy(dataset, feature)
    local cases = {}
    local outs = {}

    for i = 0, dataset:length() - 1 do
        local sample = dataset:get(i)
        local case = sample:find_if(function(case)
            return case.feature.id == feature.id
        end)

        if nil ~= case then
            incf(cases, case.id)

            if nil == outs[case.id] then
                outs[case.id] = {}
            end

            incf(outs[case.id], sample.output)
        end
    end

    for id, freq in pairs(cases) do
        for key in pairs(outs[id]) do
            outs[id][key] = outs[id][key] / freq
        end
        cases[id] = freq / dataset:length()
    end

    local sum = 0
    for id, freq in pairs(cases) do
        local s = 0
        for _, n in pairs(outs[id]) do
            s = s + (-n * math.log(n) / math.log(2))
        end
        sum = sum + (freq * s)
    end

    return sum
end

local function build(dataset, features, tree, parent)
    local first = dataset:first().output

    local allTheSame = not dataset:any(function(sample)
        return first ~= sample.output;
    end)
    if allTheSame then
        tree:add(parent, 'item', { [0] = first })
        return
    end

    local winner
    local min = 1e100
    for i = 0, len(features) - 1 do
        local feature = features[i]
        local metric = entropy(dataset, feature)
        if metric < min then
            winner = feature
            min = metric
        end
    end

    if nil == winner then
        local outputs = dataset:map(function(sample)
            return sample.output
        end)
        tree:add(parent, 'item', outputs)
    else
        local node = tree:add(parent, 'feature', winner)

        for _, case in pairs(winner.cases) do
            local sucDataset = dataset:filter(function(sample)
                return sample:find_if(function(c)
                    return c.id == case.id
                end)
            end)

            local sucFeatures = filter(features, function(feature)
                return feature.id ~= winner.id
            end)

            if not sucDataset:empty() then
                local suc = tree:add(node, 'case', case)
                build(sucDataset, sucFeatures, tree, suc)
            end
        end
    end
end

function id3.build(dataset, features)
    local tree = decision_tree.new()

    build(dataset, features, tree, tree:root())

    return tree
end

return id3
