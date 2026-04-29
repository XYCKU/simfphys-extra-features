local Formatters = SimfphysExtraFeatures.Formatters
local Gears = SimfphysExtraFeatures.Conditions.Gears

local data = {
    indicators = {
        {
            sprite = "husky_dashboard/turn_signal",
            type = "left_signal",
            pos = Vector(-23.75, 28.1, 47.5),
            ang = Angle(0, 0, 59.5),
            scale = 0.007,
            rot = 180,
        },
        {
            sprite = "husky_dashboard/turn_signal",
            type = "right_signal",
            pos = Vector(-15.65, 28.1, 47.5),
            ang = Angle(0, 0, 59.5),
            scale = 0.007,
        },
        {
            sprite = "husky_dashboard/lamps",
            type = "highbeam",
            pos = Vector(-16.2, 28.15, 47.5),
            ang = Angle(0, 0, 59.5),
            scale = 0.007,
        },
        {
            sprite = "husky_dashboard/hbrake",
            type = "handbrake",
            pos = Vector(-26.4, 28.44, 47.8),
            ang = Angle(0, 0, 59.5),
            scale = 0.003,
            dim = { x = -64, y = -64, w = 128, h = 128 },
        },
        {
            sprite = "husky_dashboard/check",
            type = "check_engine",
            pos = Vector(-12.9, 28.85, 48.5),
            ang = Angle(0, 0, 59.5),
            scale = 0.006,
        },
        {
            sprite = "husky_dashboard/fuel",
            type = "low_fuel",
            pos = Vector(-20.95, 28.35, 47.65),
            ang = Angle(0, 0, 59.5),
            scale = 0.006,
        },
    }
}

SimfphysExtraFeatures.Registry.Register("models/tdmcars/emergency/for_crownvic_fh3.mdl", data)