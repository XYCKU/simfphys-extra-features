SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}

SimfphysExtraFeatures.Dashboard.Config = {
    RenderDistance = 200
}

local SharedFiles = {
    "sef/vehicle_conditions.lua",
    "sef/registry.lua",
    "sef/features/core.lua",
    "sef/features/definitions.lua",
    "sef/helpers.lua",
    "sef/dashboard/indicator_types.lua",
    "sef/providers/environment.lua",
    "sef/providers/speed.lua",
    "sef/formatters.lua",
}

local ServerFiles = {
    "sef/features/sv_input.lua",
}

local ClientFiles = {
    "sef/dashboard/cl_fonts.lua",
    "sef/dashboard/cl_vehicle_cache.lua",
    "sef/dashboard/cl_renderer.lua",
}

local VehicleConfigFiles = {
    "sef/vehicles/audi_q7.lua",
    "sef/vehicles/bmw_m8_f92.lua",
    "sef/vehicles/bmw_x6m_f86.lua",
    "sef/vehicles/chevrolet_colorado_zr2.lua",
    "sef/vehicles/ford_crown_victoria_fh3.lua",
    "sef/vehicles/mercedes_benz_gt63s_2018.lua",
    "sef/vehicles/rolls_royce_cullinan.lua",
    "sef/vehicles/toyota_gr_supra.lua",
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
    IncludeAll(ServerFiles)
    SimfphysExtraFeatures.Registry.SyncFeatures()
    IncludeAll(VehicleConfigFiles)
end

if CLIENT then
    IncludeAll(SharedFiles)
    SimfphysExtraFeatures.Registry.SyncFeatures()
    IncludeAll(ClientFiles)
    IncludeAll(VehicleConfigFiles)
end
