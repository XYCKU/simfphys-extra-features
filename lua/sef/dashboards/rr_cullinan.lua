local Conditions = SimfphysExtraFeatures.Conditions

local data = {
    indicators = {
        {
            sprite = "husky_dashboard/turn_signal",
            type = "left_signal",
            pos = Vector(-21.3, 38.94, 64.2),
            ang = Angle(0, 0, 70),
            scale = 0.005,
            rot = 180,
        },
        {
            sprite = "husky_dashboard/turn_signal",
            type = "right_signal",
            pos = Vector(-15.65, 38.94, 64.2),
            ang = Angle(0, 0, 70),
            scale = 0.005,
        },
        {
            sprite = "husky_dashboard/lamps",
            type = "highbeam",
            pos = Vector(-10.6, 38.34, 62.7),
            ang = Angle(0, 0, 70),
            scale = 0.003,
            dim = { x = -64, y = -64, w = 128, h = 128 },
        },
        {
            sprite = "husky_dashboard/running",
            type = "lowbeam",
            pos = Vector(-10.6, 38.34, 62.7),
            ang = Angle(0, 0, 70),
            scale = 0.003,
            dim = { x = -64, y = -64, w = 128, h = 128 },
        },
        {
            sprite = "husky_dashboard/hbrake",
            type = "handbrake",
            condition = Conditions.EngineRunning,
            pos = Vector(-10.6, 37.96, 61.6),
            ang = Angle(0, 0, 70),
            scale = 0.003,
            dim = { x = -64, y = -64, w = 128, h = 128 },
        },
        {
            sprite = "husky_dashboard/check",
            type = "check_engine",
            condition = Conditions.EngineRunning,
            pos = Vector(-26.2, 38.6, 63),
            ang = Angle(0, 0, 70),
            scale = 0.006,
        },
    }
}

SimfphysExtraFeatures.Registry.Register("models/ctvehicles/rolls_royce/cullinan.mdl", data)
