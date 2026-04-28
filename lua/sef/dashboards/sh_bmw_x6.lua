SimfphysExtraFeatures.Registry.Register("models/crsk_autos/bmw/x6m_f86_2015.mdl", {
    elements = {
        {
            type = "sprite",
            pos = Vector(-19.18, 40.46, 59.3),
            ang = Angle(0, 0, 65.5),
            scale = 0.004,
            material = "husky_dashboard/hbrake",

            visible = function(v)
                return v:GetHandBrakeEnabled()
            end
        },

        {
            type = "sprite",
            pos = Vector(-25.55, 40.44, 59.2),
            ang = Angle(0, 0, 65.5),
            scale = 0.004,
            material = "husky_dashboard/running",

            visible = function(v)
                return v:GetLightsEnabled()
            end
        },

        {
            type = "text",
            pos = Vector(-19.68, 40, 58.5),
            ang = Angle(0, 0, 65.5),
            scale = 0.02,

            font = "DermaLarge",

            text = function(v)
                return tostring(v:GetGear())
            end
        }

    }

})