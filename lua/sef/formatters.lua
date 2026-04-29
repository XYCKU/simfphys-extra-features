SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Formatters = SimfphysExtraFeatures.Formatters or {}

SimfphysExtraFeatures.Conditions = SimfphysExtraFeatures.Conditions or {}
SimfphysExtraFeatures.Conditions.Gears = SimfphysExtraFeatures.Conditions.Gears or {}

local Conditions = SimfphysExtraFeatures.Conditions
local Formatters = SimfphysExtraFeatures.Formatters

function Formatters.GetAutomaticGearText(veh)
    if Conditions.Gears.IsParking(veh) then return "P" end
    if Conditions.Gears.IsReverse(veh) then return "R" end
    if Conditions.Gears.IsNeutral(veh) then return "N" end
    return "D"
end