SimfphysExtraFeatures = SimfphysExtraFeatures or {}


SimfphysExtraFeatures.Dashboard.Config = {
    RenderDistance = 200
}

if SERVER then
    AddCSLuaFile("sef/dashboard/registry.lua")
    AddCSLuaFile("sef/sef_active_vehicles.lua")
    AddCSLuaFile("sef/dashboard/cl_render.lua")
    AddCSLuaFile("sef/dashboards/audi_q7.lua")
end

--include("sef/dashboard/registry.lua")

if CLIENT then
    include("sef/dashboard/registry.lua")
    include("sef/sef_active_vehicles.lua")
    include("sef/dashboard/cl_render.lua")

    include("sef/dashboards/audi_q7.lua")
end

hook.Add("Initialize", "SEF_BuildVehicleIndex", function()
    local vehicles = list.Get("simfphys_vehicles")

    for listName, data in pairs(vehicles) do
        local model = data.Model or data.model
        if model then
            SimfphysExtraFeatures.VehicleListNameByModel[model] = listName
        end
    end
end)