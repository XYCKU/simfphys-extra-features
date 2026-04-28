SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}


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