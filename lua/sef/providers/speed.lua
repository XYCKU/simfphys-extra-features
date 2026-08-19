SimfphysExtraFeatures = SimfphysExtraFeatures or {}

SimfphysExtraFeatures.Units = SimfphysExtraFeatures.Units or {}
SimfphysExtraFeatures.Units.Speed = {
    KMH = 1,
    MPH = 2
}

SimfphysExtraFeatures.Providers = SimfphysExtraFeatures.Providers or {}
SimfphysExtraFeatures.Providers.Speed = SimfphysExtraFeatures.Providers.Speed or {}

local SpeedProvider = SimfphysExtraFeatures.Providers.Speed
local SpeedUnits = SimfphysExtraFeatures.Units.Speed

function SpeedProvider.GetBaseSpeed(veh)
    return veh:GetVelocity():Length() / 14.5
end

function SpeedProvider.GetUnit()
    if GetConVar("cl_simfphys_hudmph"):GetBool() then
        return SpeedUnits.MPH
    end
    return SpeedUnits.KMH
end

function SpeedProvider.GetInUnit(veh, unit)
    if unit == nil then
        unit = SpeedProvider.GetUnit()
    end
    
    local speed = SpeedProvider.GetBaseSpeed(veh)
    if unit == SpeedUnits.MPH then
        speed = speed / 1.6
    end
    return speed
end
