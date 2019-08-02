require "src/core/arrays"
local decision_tree = require("src/decisions/decision_tree")

local id3 = {}
id3.__index = id3

local function entropy(cases)
  local probs = {}

  for i=0,len(cases)-1 do
    local case = cases[i]
    if nil == probs[case.id] then
      probs[case.id] = 0
    end
    probs[case.id] = probs[case.id] + 1
  end

  for id in pairs(probs) do
    probs[id] = probs[id] / len(cases)
  end

  local sum = 0
  for _,prob in pairs(probs) do
    sum = sum + (-prob * math.log(prob) / math.log(2))
  end

  return sum
end

local function build(dataset, features, tree, parent)
  local first = dataset:first().output

  local allTheSame = not dataset:any(function (sample) return first ~= sample.output; end)
  if allTheSame then
    local outputs = dataset:map(function (sample) return sample.output end)

    tree:add(parent, 'item', outputs)

    return
  end

  local winner
  local min = 1e100
  for i=0,len(features)-1 do
    local feature = features[i]
    local metric = entropy(dataset:map(function (sample)
      return sample:find_if(function (case)
        return case.feature == feature
      end)
    end))
    if metric > 0 and metric < min then
      winner = feature
      min = metric
    end
  end

  if nil == winner then
    local outputs = dataset:map(function (sample) return sample.output end)
    tree:add(parent, 'item', outputs)
  else
    local node = tree:add(parent, 'feature', winner)

    for _,case in pairs(winner.cases) do
      local sucDataset = dataset:filter(function (sample)
        return sample:find_if(function (c)
          return c.id == case.id
        end)
      end)

      local sucFeatures = {}
      for i=0,len(features)-1 do
        local feature = features[i]
        if feature.id ~= winner.id then
          sucFeatures[len(sucFeatures)] = feature
        end
      end

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
