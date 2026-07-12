SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}

SimfphysExtraFeatures.Dashboard.Config = {
    RenderDistance = 200
}

local SharedFiles = {
    "sef/vehicle_conditions.lua",
    "sef/sef_active_vehicles.lua",
    "sef/registry.lua",
    "sef/features.lua",
    "sef/feat.lua",
    "sef/helpers.lua",
    "sef/dashboard/indicator_types.lua",
    "sef/providers/sef_environment.lua",
    "sef/providers/sef_speedometer.lua",
    "sef/formatters.lua",
}

local ClientFiles = {
    "sef/dashboard/cl_render.lua",
}

local VehicleConfigFiles = {
    "sef/dashboards/audi_q7.lua",
    "sef/dashboards/bmw_m8_f92.lua",
    "sef/dashboards/bmw_x6m_f86.lua",
    "sef/dashboards/chevy_colorado_zr2.lua",
    "sef/dashboards/ford_cv_fh3.lua",
    "sef/dashboards/mercedes_gt63_s.lua",
    "sef/dashboards/rr_cullinan.lua",
    "sef/dashboards/toyota_supra_2020.lua",
}

local function IncludeAll(files)
    for _, file in ipairs(files) do
        include(file)
    end
end

if SERVER then
    AddCSLuaFile()

    for _, files in ipairs({SharedFiles, ClientFiles, VehicleConfigFiles}) do
        for _, file in ipairs(files) do
            AddCSLuaFile(file)
        end
    end

    IncludeAll(SharedFiles)
    SimfphysExtraFeatures.Registry.SyncFeatures()
    IncludeAll(VehicleConfigFiles)
end

if CLIENT then
    IncludeAll(SharedFiles)
    SimfphysExtraFeatures.Registry.SyncFeatures()
    IncludeAll(ClientFiles)
    IncludeAll(VehicleConfigFiles)
end
