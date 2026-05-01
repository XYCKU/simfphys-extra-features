SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Conditions = SimfphysExtraFeatures.Conditions or {}
SimfphysExtraFeatures.Conditions.Gears = SimfphysExtraFeatures.Conditions.Gears or {
    Parking = 1,
    Reverse = 2,
    Neutral = 3,
    Drive = 4,
    Sport = 5,
    Low = 6
}

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

function Conditions.FogLights(veh)
    return veh:GetFogLightsEnabled()
end

function Conditions.ParkingLights(veh)
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

function Conditions.CruiseMode(veh)
    return veh:GetIsCruiseModeOn()
end

function Conditions.Gears.IsReverse(veh)
    return veh:GetGear() == 1
end

function Conditions.Gears.IsNeutral(veh)
    return veh:GetGear() == 2
end

function Conditions.Gears.IsDrive(veh)
   return veh:GetGear() > 2 
end

function Conditions.Gears.IsSportMode(veh)
    return Conditions.Gears.IsDrive(veh) and GetConVar("cl_simfphys_sport"):GetBool()
end

function Conditions.Gears.IsParking(veh)
    return Conditions.Gears.IsNeutral(veh)
        and math.floor(veh:GetVelocity():Length()) < 2
end

function Conditions.Gears.ForwardGear(veh)
    local gear = veh:GetGear()
    if gear < 3 then return nil end
    return gear - 2
end

function Conditions.Gears.NormalizedGear(veh)
    if Conditions.Gears.IsReverse(veh) then return -1 end
    if Conditions.Gears.IsNeutral(veh) then return 0 end
    return 1
end

function Conditions.Gears.GetAutomaticGear(veh)
    if Conditions.Gears.IsParking(veh) then return Conditions.Gears.Parking end
    if Conditions.Gears.IsReverse(veh) then return Conditions.Gears.Reverse end
    if Conditions.Gears.IsNeutral(veh) then return Conditions.Gears.Neutral end
    if Conditions.Gears.IsSportMode(veh) then return Conditions.Gears.Sport end
    return Conditions.Gears.Drive
end