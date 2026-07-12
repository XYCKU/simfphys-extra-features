SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}


SimfphysExtraFeatures.Dashboard.Config = {
    RenderDistance = 200
}

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("sef/vehicle_conditions.lua")
    AddCSLuaFile("sef/sef_active_vehicles.lua")
    AddCSLuaFile("sef/registry.lua")
    AddCSLuaFile("sef/features.lua")
    AddCSLuaFile("sef/feat.lua")
    AddCSLuaFile("sef/helpers.lua")
    AddCSLuaFile("sef/dashboard/indicator_types.lua")
    AddCSLuaFile("sef/providers/sef_environment.lua")
    AddCSLuaFile("sef/providers/sef_speedometer.lua")
    AddCSLuaFile("sef/formatters.lua")
    AddCSLuaFile("sef/dashboard/cl_render.lua")
    
    AddCSLuaFile("sef/dashboards/audi_q7.lua")
    AddCSLuaFile("sef/dashboards/bmw_m8_f92.lua")
    AddCSLuaFile("sef/dashboards/bmw_x6m_f86.lua")
    AddCSLuaFile("sef/dashboards/chevy_colorado_zr2.lua")
    AddCSLuaFile("sef/dashboards/ford_cv_fh3.lua")
    AddCSLuaFile("sef/dashboards/mercedes_gt63_s.lua")
    AddCSLuaFile("sef/dashboards/rr_cullinan.lua")
    AddCSLuaFile("sef/dashboards/toyota_supra_2020.lua")

    include("sef/vehicle_conditions.lua")
    include("sef/sef_active_vehicles.lua")
    include("sef/registry.lua")
    include("sef/features.lua")
    include("sef/feat.lua")
    include("sef/helpers.lua")
    include("sef/dashboard/indicator_types.lua")
    include("sef/providers/sef_environment.lua")
    include("sef/providers/sef_speedometer.lua")
    include("sef/formatters.lua")

    include("sef/dashboards/audi_q7.lua")
    include("sef/dashboards/bmw_m8_f92.lua")
    include("sef/dashboards/bmw_x6m_f86.lua")
    include("sef/dashboards/chevy_colorado_zr2.lua")
    include("sef/dashboards/ford_cv_fh3.lua")
    include("sef/dashboards/mercedes_gt63_s.lua")
    include("sef/dashboards/rr_cullinan.lua")
    include("sef/dashboards/toyota_supra_2020.lua")
end

--include("sef/dashboard/registry.lua")

if CLIENT then
    include("sef/vehicle_conditions.lua")
    include("sef/sef_active_vehicles.lua")
    include("sef/registry.lua")
    include("sef/features.lua")
    include("sef/feat.lua")
    include("sef/helpers.lua")
    include("sef/dashboard/indicator_types.lua")
    include("sef/providers/sef_environment.lua")
    include("sef/providers/sef_speedometer.lua")
    include("sef/formatters.lua")
    include("sef/dashboard/cl_render.lua")

    include("sef/dashboards/audi_q7.lua")
    include("sef/dashboards/bmw_m8_f92.lua")
    include("sef/dashboards/bmw_x6m_f86.lua")
    include("sef/dashboards/chevy_colorado_zr2.lua")
    include("sef/dashboards/ford_cv_fh3.lua")
    include("sef/dashboards/mercedes_gt63_s.lua")
    include("sef/dashboards/rr_cullinan.lua")
    include("sef/dashboards/toyota_supra_2020.lua")
end
