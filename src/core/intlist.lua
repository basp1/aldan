require "src/core/arrays"

local intlist = {}
intlist.__index = intlist

local NIL = -1
local EMPTY = -2

function intlist.new(capacity)
    local self = setmetatable({}, intlist)

    self.values = {}
    self.ip = NIL
    self.length = 0
    self.capacity = capacity

    for i = 0, capacity - 1 do
        self.values[i] = EMPTY
    end

    return self
end

function intlist.empty(self)
    return 0 == self.length
end

function intlist.top(self)
    return self.ip
end

function intlist.next(self, key)
    if NIL == key then
        return key
    else
        return self.values[key]
    end
end

function intlist.contains(self, key)
    assert(key >= 0 and key < self.capacity)

    return EMPTY ~= self.values[key]
end

function intlist.push(self, key)
    assert(key >= 0 and key < self.capacity)

    if self:contains(key) then
        return
    end

    self.values[key] = self.ip
    self.ip = key

    self.length = self.length + 1
end

function intlist.pop(self)
    assert(self.length > 0)

    local key = self.ip
    self.ip = self.values[self.ip]
    self.values[key] = EMPTY
    self.length = self.length - 1

    return key
end

function intlist.pop_all(self)
    local n = self.length
    local values = {}

    for i = 1, n do
        values[i] = self:pop()
    end

    return values
end

function intlist.clear(self)
    while self.length > 0 do
        self:pop()
    end
end

return intlist
