SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Helpers = {}

local Helpers = SimfphysExtraFeatures.Helpers

function Helpers.Not(fn)
    return function(...)
        return not fn(...)
    end
end

function Helpers.And(...)
    local fns = {...}

    return function(...)
        for i = 1, #fns do
            if not fns[i](...) then
                return false
            end
        end
        return true
    end
end

function Helpers.Or(...)
    local fns = {...}

    return function(...)
        for i = 1, #fns do
            if fns[i](...) then
                return true
            end
        end
        return false
    end
end