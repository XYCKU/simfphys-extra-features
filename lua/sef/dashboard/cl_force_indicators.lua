local Dashboard = SimfphysExtraFeatures.Dashboard
local Registry = SimfphysExtraFeatures.Registry

local ForceAllIndicators = CreateClientConVar(
    "sef_dev_force_all_indicators",
    "0",
    true,
    false,
    "Force all SEF dashboard indicators visible.",
    0,
    1
)

local OriginalConditions = Dashboard.ForceIndicatorOriginalConditions
    or setmetatable({}, { __mode = "k" })
Dashboard.ForceIndicatorOriginalConditions = OriginalConditions

local function ApplyToCollection(collection, force)
    if not collection then return end

    for _, indicator in ipairs(collection) do
        if force then
            if not OriginalConditions[indicator] then
                OriginalConditions[indicator] = {
                    type = indicator.type,
                    condition = indicator.condition,
                }
            end

            indicator.type = nil
            indicator.condition = nil
        else
            local original = OriginalConditions[indicator]
            if not original then continue end

            indicator.type = original.type
            indicator.condition = original.condition
        end
    end
end

local function ApplyForceAllIndicators()
    local force = ForceAllIndicators:GetBool()

    Registry.ForEach(function(_, data)
        ApplyToCollection(data.indicators, force)
        ApplyToCollection(data.text_indicators, force)
    end)
end

cvars.AddChangeCallback(
    "sef_dev_force_all_indicators",
    ApplyForceAllIndicators,
    "SEF_DevForceAllIndicators"
)

ApplyForceAllIndicators()
