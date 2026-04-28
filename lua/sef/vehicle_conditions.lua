SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Conditions = SimfphysExtraFeatures.Conditions or {}

local Conditions = SimfphysExtraFeatures.Conditions

local LowFuelPercentage = 0.1
local CheckEnginePercentage = 0.6

function Conditions.LeftSignal(veh)
    return veh.flashnum == 1 and veh.signal_left
end

function Conditions.RightSignal(veh)
    return veh.flashnum == 1 and veh.signal_right
end

function Conditions.HazardSignal(veh)
    return veh.flashnum == 1 and veh.signal_left and veh.signal_right
end

function Conditions.LowBeam(veh)
    return veh:GetLightsEnabled() and not veh:GetLampsEnabled()
end

function Conditions.HighBeam(veh)
    return veh:GetLightsEnabled() and veh:GetLampsEnabled()
end

function Conditions.RunningLights(veh)
    return veh:GetLightsEnabled()
end

function Conditions.Handbrake(veh)
    return veh:GetHandBrakeEnabled()
end

function Conditions.LowFuel(veh)
    return veh:GetFuel() <= veh:GetMaxFuel() * LowFuelPercentage
end

function Conditions.CheckEngine(veh)
    return veh:GetCurHealth() <= veh:GetMaxHealth() * CheckEnginePercentage
end