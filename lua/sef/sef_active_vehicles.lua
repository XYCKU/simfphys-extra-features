SimfphysExtraFeatures = SimfphysExtraFeatures or {}

SimfphysExtraFeatures.ActiveVehicles = SimfphysExtraFeatures.ActiveVehicles or {}

local VehiclesTable = {}
local SimfphysClassName = "gmod_sent_vehicle_fphysics_base"

local function IsSimfphys(ent)
    return IsValid(ent) and ent:GetClass() == SimfphysClassName
end

function SimfphysExtraFeatures.ActiveVehicles.Get()
    return VehiclesTable
end

function SimfphysExtraFeatures.ActiveVehicles.OnEntityCreated(ent)
    if not IsSimfphys(ent) then return end
    print("simfphys created")
    VehiclesTable[ent] = true
    PrintTable(VehiclesTable)
end

function SimfphysExtraFeatures.ActiveVehicles.OnEntityRemoved(ent)
    if not IsSimfphys(ent) then return end
    print("simfphys removed")
    VehiclesTable[ent] = nil
    PrintTable(VehiclesTable)
end

function SimfphysExtraFeatures.ActiveVehicles.CleanupCache()
    for ent in pairs(VehiclesTable) do
        if not IsValid(ent) then
            VehiclesTable[ent] = nil
        end
    end
end

hook.Add("OnEntityCreated", "SEF_AddVehicleToCache", SimfphysExtraFeatures.ActiveVehicles.OnEntityCreated)
hook.Add("EntityRemoved", "SEF_RemoveVehicleFromCache", SimfphysExtraFeatures.ActiveVehicles.OnEntityRemoved)
