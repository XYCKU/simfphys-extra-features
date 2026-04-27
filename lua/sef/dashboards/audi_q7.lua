SimfphysExtraFeatures.Dashboard.Register("models/dk_cars/audi/q7/ak_47.mdl", {
    indicators = {
        {
            sprite = "husky_dashboard/turn_signal",
            pos = Vector(-22, 35.48, 57.2),
            ang = Angle(0, 0, 59.5),
            rot = 180,
            scale = 0.005,

            condition = function(v)
                return v.flashnum == 1 and v.signal_left == true
            end
        },
        {
            sprite = "husky_dashboard/turn_signal",
            pos = Vector(-16.2, 35.48, 57.2),
            ang = Angle(0, 0, 59.5),
            scale = 0.005,

            condition = function(v)
                return v.flashnum == 1 and v.signal_right == true
            end
        },
        {
            sprite = "husky_dashboard/check",
            pos = Vector(-19.8, 35.6, 57.2),
            ang = Angle(0, 0, 59.5),
            scale = 0.006,

            condition = function(v)
                return v:GetCurHealth() < v:GetMaxHealth() * 0.6
            end
        },
        {
            sprite = "husky_dashboard/lamps",
            pos = Vector(-19.1, 35.415, 56.8),
            ang = Angle(0, 0, 59.5),
            scale = 0.007,

            condition = function(v)
                return v:GetLampsEnabled()
            end
        },
        {
            sprite = "husky_dashboard/hbrake",
            pos = Vector(-13.8, 35.12, 54.5),
            ang = Angle(0, 0, 59.5),
            scale = 0.003,
            dim = {
                x = -64,
                y = -64,
                w = 128,
                h = 128
            },

            condition = function(v)
                return v:GetHandBrakeEnabled()
            end
        }
    }

})