local basis = {}

basis.mamdani = {}

basis.mamdani.fuzzy_and = function(a, b)
    return math.min(a, b)
end

basis.mamdani.fuzzy_or = function(a, b)
    return math.max(a, b)
end

basis.mamdani.fuzzy_impl = function(a, b)
    return math.min(a, b)
end

basis.mamdani.fuzzy_not = function(a)
    return 1 - a
end

basis.lukasiewicz = {}

basis.lukasiewicz.fuzzy_and = function(a, b)
    return math.max(a + b - 1, 0)
end

basis.lukasiewicz.fuzzy_or = function(a, b)
    return math.min(a + b, 1)
end

basis.lukasiewicz.fuzzy_impl = function(a, b)
    return math.min(1, 1 - (a + b))
end

basis.lukasiewicz.fuzzy_not = function(a)
    return 1 - a
end

basis.strong = {}

basis.strong.fuzzy_and = function(a, b)
    if a >= 0 and a < 1 and b >= 0 and b < 1 then
        return 0
    else
        return math.min(a, b)
    end
end

basis.strong.fuzzy_or = function(a, b)
    if a > 0 and a <= 1 and b > 0 and b <= 1 then
        return 1
    else
        return math.max(a, b)
    end
end

basis.strong.fuzzy_impl = function(a, b)
    return math.max(1 - a, b)
end

basis.strong.fuzzy_not = function(a)
    return 1 - a
end

return basis