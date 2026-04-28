SimfphysExtraFeatures = SimfphysExtraFeatures or {}

local SEFRegistry = {}

function SimfphysExtraFeatures.Register(entityName, data)
    SEFRegistry[entityName] = data
end

function SimfphysExtraFeatures.Get(entityName)
    return SEFRegistry[entityName]
end

--[[

    Globals:
        - Render Distance

    Per Model:
        - Icon Indicators[]
        - Text Indicators[]

    Per Entity Params:
        - Units (MPH or KMH, fuel consumption probably)

    Per Entity States:
        - Engine Temperature

    Sprite:
        - position
        - rotation
        - scale 
        - color

    Icon Indicator:
        - sprite
        - condition

    Text Indicator:
        - getter
        - delay
]]