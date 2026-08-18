SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}
SimfphysExtraFeatures.Dashboard.VehicleCache = SimfphysExtraFeatures.Dashboard.VehicleCache or {}

local VehicleCache = SimfphysExtraFeatures.Dashboard.VehicleCache
local Vehicles = {}
local SimfphysClassName = "gmod_sent_vehicle_fphysics_base"

local function IsSimfphys(ent)
    return IsValid(ent) and ent:GetClass() == SimfphysClassName
end

function VehicleCache.Get()
    return Vehicles
end

function VehicleCache.OnEntityCreated(ent)
    if not IsSimfphys(ent) then return end
    Vehicles[ent] = true
end

function VehicleCache.OnEntityRemoved(ent)
    if not IsSimfphys(ent) then return end
    Vehicles[ent] = nil
end

function VehicleCache.Cleanup()
    for ent in pairs(Vehicles) do
        if not IsValid(ent) then
            Vehicles[ent] = nil
        end
    end
end

hook.Add("OnEntityCreated", "SEF_AddVehicleToCache", VehicleCache.OnEntityCreated)
hook.Add("EntityRemoved", "SEF_RemoveVehicleFromCache", VehicleCache.OnEntityRemoved)
