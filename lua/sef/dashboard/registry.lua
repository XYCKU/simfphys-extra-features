SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}
SimfphysExtraFeatures.Dashboard.Registry = SimfphysExtraFeatures.Dashboard.Registry or {}
SimfphysExtraFeatures.ActiveVehicles = SimfphysExtraFeatures.ActiveVehicles or {}

function SimfphysExtraFeatures.Dashboard.Register(model, data)
    SimfphysExtraFeatures.Dashboard.Registry[model] = data
end

function SimfphysExtraFeatures.Dashboard.Get(model)
    return SimfphysExtraFeatures.Dashboard.Registry[model]
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