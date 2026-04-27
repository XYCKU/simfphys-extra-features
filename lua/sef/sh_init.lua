SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Dashboard = SimfphysExtraFeatures.Dashboard or {}
SimfphysExtraFeatures.Dashboard.Config = SimfphysExtraFeatures.Dashboard.Config or {
    RenderDistance = 200
}

include("simfphys_extra_features/dashboard/sh_registry.lua")

if CLIENT then
    include("simfphys_extra_features/dashboard/cl_renderer.lua")
end