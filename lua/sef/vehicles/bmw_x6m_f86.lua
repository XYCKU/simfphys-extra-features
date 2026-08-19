local Formatters = SimfphysExtraFeatures.Formatters
local Gears = SimfphysExtraFeatures.Conditions.Gears
local Conditions = SimfphysExtraFeatures.Conditions
local Registry = SimfphysExtraFeatures.Registry

local data = {
    indicators = {
        -- handbrake icon
        {
            sprite = "husky_dashboard/hbrake",
            type = "handbrake",
            condition = Conditions.EngineRunning,
            pos = Vector(-19.18, 40.465, 59.3),
            ang = Angle(0, 0, 65.5),
            scale = 0.003,
            dim = { x = -64, y = -64, w = 128, h = 128 },
        },

        -- running lights
        {
            sprite = "husky_dashboard/running",
            type = "parking_lights",
            condition = Conditions.EngineRunning,
            pos = Vector(-25.55, 40.44, 59.2),
            ang = Angle(0, 0, 65.5),
            scale = 0.004,
            dim = { x = -64, y = -64, w = 128, h = 128 },
        },

        -- high beam
        {
            sprite = "husky_dashboard/lamps",
            type = "highbeam",
            condition = Conditions.EngineRunning,
            pos = Vector(-19.9, 40.8, 60),
            ang = Angle(0, 0, 65.5),
            scale = 0.004,
            dim = { x = -64, y = -64, w = 128, h = 128 },
        },

        -- fog
        {
            sprite = "husky_dashboard/fog",
            type = "fog",
            condition = Conditions.EngineRunning,
            pos = Vector(-26.1, 40.77, 59.9),
            ang = Angle(0, 0, 65.5),
            scale = 0.007,
        },

        -- rear fog
        {
            sprite = "husky_dashboard/fog_rear",
            type = "fog",
            condition = Conditions.EngineRunning,
            pos = Vector(-25.5, 40.77, 59.9),
            ang = Angle(0, 0, 65.5),
            scale = 0.007,
        },

        -- left turn
        {
            sprite = "husky_dashboard/turn_signal",
            type = "left_signal",
            condition = Conditions.EngineRunning,
            pos = Vector(-21.074, 41.367, 61.352),
            ang = Angle(0, 0, 65.5),
            scale = 0.009,
            rot = 180,
        },

        -- right turn
        {
            sprite = "husky_dashboard/turn_signal",
            type = "right_signal",
            condition = Conditions.EngineRunning,
            pos = Vector(-17.932, 41.367, 61.302),
            ang = Angle(0, 0, 65.5),
            scale = 0.009,
        },
    },

    text_indicators = {
        {
            getter = Formatters.GetDriveModeText,
            condition = Conditions.EngineRunning,
            pos = Vector(-19.68, 40, 58.5),
            ang = Angle(0, 0, 65.5),
            color = Color(200, 200, 200),
            scale = 0.02,
            font = "HUSKY_BMW_X6m",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
        },        
        {
            getter = function(veh) return Gears.ForwardGear(veh) or "" end,
            condition = Conditions.EngineRunning,
            pos = Vector(-19.68, 40, 58.5),
            ang = Angle(0, 0, 65.5),
            offset = Vector(-25, 6, 0),
            color = Color(200, 200, 200),
            scale = 0.02,
            font = "HUSKY_BMW_X6m2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
        },
        {
            getter = function(veh) return "BRAKE" end,
            type = "handbrake",
            condition = Conditions.EngineRunning,
            pos = Vector(-19.37, 40.7, 59.8),
            ang = Angle(0, 0, 65.5),
            color = Color(255, 0, 0),
            scale = 0.003,
            font = "HUSKY_BMW_X6m",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
        },
    },
}

Registry.Register("models/crsk_autos/bmw/x6m_f86_2015.mdl", data)
Registry.Register("models/crsk_autos/bmw/x6m_f86_2015_black.mdl", data)
