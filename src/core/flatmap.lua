require "src/core/arrays"

local flatmap = {}
flatmap.__index = flatmap

function flatmap.new()
    local self = setmetatable({}, flatmap)

    self.keys = {}
    self.values = {}

    return self
end

function flatmap.empty(self)
    return 0 == #(self.keys)
end

function flatmap.length(self)
    return #(self.keys)
end

function flatmap.clear(self)
    self.keys = {}
    self.values = {}
end

function flatmap.contains(self, key)
    local found, _ = self:find(key)
    return found
end

function flatmap.get(self, key)
    local found, value = self:find(key)

    if found then
        return value
    else
        return nil
    end
end

function flatmap.insert(self, key, value)
    local index = lower_bound(self.keys, key)

    if index > 0 and index <= self:length() and key == self.keys[index]
    then
        self.keys[index] = key
        self.values[index] = value
    else
        self.keys = insert(self.keys, index, key)
        self.values = insert(self.values, index, value)
    end
end

function flatmap.remove(self, key)
    local index = lower_bound(self.keys, key)

    if index > 0 and index <= self:length() and key == self.keys[index]
    then
        self.keys = remove(self.keys, index)
        self.values = remove(self.values, index)
    end
end

function flatmap.find(self, key)
    local index = lower_bound(self.keys, key)

    if index > 0 and index <= self:length() and key == self.keys[index]
    then
        return true, self.values[index]
    end

    return false
end

return flatmap
