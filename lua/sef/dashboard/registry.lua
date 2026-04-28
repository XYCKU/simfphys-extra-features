SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Registry = SimfphysExtraFeatures.Registry or {}

local Registry = SimfphysExtraFeatures.Registry
local Storage = {}

function Registry.Register(model, data)
    if not model or not data then return end

    if Storage[model] then
        print("[SEF] Warning: overriding dashboard for model:", model)
    end

    Storage[model] = data
end

function Registry.GetForModel(model)
    return Storage[model]
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