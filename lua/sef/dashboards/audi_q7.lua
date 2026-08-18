local model = "models/dk_cars/audi/q7/ak_47.mdl"
local Conditions = SimfphysExtraFeatures.Conditions
local Helpers = SimfphysExtraFeatures.Helpers

SimfphysExtraFeatures.Registry.Register(model, {
    indicators = {
        {
            sprite = "husky_dashboard/turn_signal",
            type = "left_signal",
            pos = Vector(-22, 35.48, 57.2),
            ang = Angle(0, 0, 59.5),
            rot = 180,
            scale = 0.005,
        },
        {
            sprite = "husky_dashboard/turn_signal",
            type = "right_signal",
            pos = Vector(-16.2, 35.48, 57.2),
            ang = Angle(0, 0, 59.5),
            scale = 0.005,
        },
        {
            sprite = "husky_dashboard/check",
            condition = Helpers.And(Conditions.EngineRunning, Conditions.CheckEngine),
            pos = Vector(-19.8, 35.6, 57.2),
            ang = Angle(0, 0, 59.5),
            scale = 0.006,
        },
        {
            sprite = "husky_dashboard/lamps",
            type = "lamps",
            pos = Vector(-19.1, 35.415, 56.8),
            ang = Angle(0, 0, 59.5),
            scale = 0.007,
        },
        {
            sprite = "husky_dashboard/hbrake",
            condition = Helpers.And(Conditions.EngineRunning, Conditions.Handbrake),
            pos = Vector(-13.8, 35.12, 54.5),
            ang = Angle(0, 0, 59.5),
            scale = 0.003,
            dim = {
                x = -64,
                y = -64,
                w = 128,
                h = 128
            },
        },
    },
    features = {
        hood = {},
        air_up = {},
        air_down = {},
    },
})
