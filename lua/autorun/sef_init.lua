SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}


SimfphysExtraFeatures.Dashboard.Config = {
    RenderDistance = 200
}

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("sef/vehicle_conditions.lua")
    AddCSLuaFile("sef/dashboard/indicator_types.lua")
    AddCSLuaFile("sef/formatters.lua")
    AddCSLuaFile("sef/dashboard/registry.lua")
    AddCSLuaFile("sef/sef_active_vehicles.lua")
    AddCSLuaFile("sef/dashboard/cl_render.lua")
    AddCSLuaFile("sef/dashboards/audi_q7.lua")
    AddCSLuaFile("sef/dashboards/bmw_x6m_f86.lua")
end

--include("sef/dashboard/registry.lua")

if CLIENT then
    include("sef/vehicle_conditions.lua")
    include("sef/dashboard/indicator_types.lua")
    include("sef/formatters.lua")
    include("sef/dashboard/registry.lua")
    include("sef/sef_active_vehicles.lua")
    include("sef/dashboard/cl_render.lua")

    include("sef/dashboards/audi_q7.lua")
    include("sef/dashboards/bmw_x6m_f86.lua")
end