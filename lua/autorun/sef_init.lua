SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}
SimfphysExtraFeatures.Dashboard.ActiveVehicles = SimfphysExtraFeatures.Dashboard.ActiveVehicles or {}

SimfphysExtraFeatures.Dashboard.Config = {
    RenderDistance = 200
}

if SERVER then
    AddCSLuaFile("sef/dashboard/registry.lua")
    AddCSLuaFile("sef/dashboard/cl_render.lua")
    AddCSLuaFile("sef/dashboards/audi_q7.lua")
end

--include("sef/dashboard/registry.lua")

if CLIENT then
    include("sef/dashboard/registry.lua")
    include("sef/dashboard/cl_render.lua")

    include("sef/dashboards/audi_q7.lua")
end