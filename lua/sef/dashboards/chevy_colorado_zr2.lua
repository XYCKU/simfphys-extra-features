local Conditions = SimfphysExtraFeatures.Conditions
local Formatters = SimfphysExtraFeatures.Formatters
local Helpers = SimfphysExtraFeatures.Helpers

local data = {
    indicators = {
        {
            sprite = "husky_dashboard/turn_signal",
            type = "left_signal",
            pos = Vector(-22, 51.5, 59.4),
            ang = Angle(0, 0, 60),
            scale = 0.004,
            rot = 180
        },
        {
            sprite = "husky_dashboard/turn_signal",
            type = "right_signal",
            pos = Vector(-14, 51.5, 59.4),
            ang = Angle(0, 0, 60),
            scale = 0.004
        },
        {
            sprite = "husky_dashboard/running",
            type = "parking_lights",
            pos = Vector(-20.55, 51.25, 58.9),
            ang = Angle(0, 0, 60),
            scale = 0.0035
        },
        {
            sprite = "husky_dashboard/lamps",
            type = "lamps",
            pos = Vector(-17.95, 51.9, 61),
            ang = Angle(0, 0, 60),
            scale = 0.003
        },
        {
            sprite = "husky_dashboard/fog",
            type = "fog",
            pos = Vector(-20.55, 50.92, 58.3),
            ang = Angle(0, 0, 60),
            scale = 0.005
        },
        {
            sprite = "husky_dashboard/fuel_orange",
            condition = Helpers.And(Conditions.DashboardEnabled, Conditions.LowFuel),
            pos = Vector(-20, 51.9, 61),
            ang = Angle(0, 0, 60),
            scale = 0.004
        },
        {
            sprite = "husky_dashboard/check",
            condition = Helpers.And(Conditions.DashboardEnabled, Conditions.CheckEngine),
            pos = Vector(-14.55, 50.6, 57.85),
            ang = Angle(0, 0, 60),
            scale = 0.005
        }
    },

    text_indicators = {
        {
            getter = Formatters.GetSpeedInUnits,
            condition = Conditions.DashboardEnabled,
            pos = Vector(-18.5, 51.29, 59.1),
            ang = Angle(0, 0, 60),
            offset = { x = 0, y = 0 },
            color = Color(255, 255, 255),
            scale = 0.015,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            delay = 0.15
        },
        {
            getter = Formatters.GetSpeedUnitsUpper,
            condition = Conditions.DashboardEnabled,
            pos = Vector(-18.5, 51.29, 59.1),
            ang = Angle(0, 0, 60),
            offset = { x = 0, y = 32 },
            color = Color(255, 255, 255),
            scale = 0.015,
            font = "HUSKY_chevy_zr2_2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            delay = 0.15
        },
        {
            getter = function(veh) return veh:GetNWString("compass") end,
            condition = Conditions.DashboardEnabled,
            pos = Vector(-18.5, 51.29, 59.1),
            ang = Angle(0, 0, 60),
            offset = { x = -93, y = 84 },
            color = Color(0, 255, 255),
            scale = 0.015,
            font = "HUSKY_chevy_zr2_2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        },
        {
            getter = function(veh) return "BRAKE" end,
            condition = Helpers.And(Conditions.DashboardEnabled, Conditions.Handbrake),
            pos = Vector(-15.35, 50.6, 57.85),
            ang = Angle(0, 0, 60),
            color = Color(255, 0, 0),
            scale = 0.004,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        },
        {
            getter = function() return Formatters.Gears.Parking end,
            pos = Vector(-17.57, 50.65, 58),
            ang = Angle(0, 0, 60),
            offset = { x = -52, y = 0 },
            color = Color(255, 255, 255),
            scale = 0.0055,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            condition = Conditions.DashboardEnabled,
        },
        {
            getter = function() return Formatters.Gears.Reverse end,
            pos = Vector(-17.57, 50.65, 58),
            ang = Angle(0, 0, 60),
            offset = { x = -26, y = 0 },
            color = Color(255, 255, 255),
            scale = 0.0055,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            condition = Helpers.And(Conditions.DashboardEnabled, Helpers.Not(Conditions.Gears.IsReverse)),
        },
        {
            getter = function() return Formatters.Gears.Reverse end,
            pos = Vector(-17.57, 50.65, 58),
            ang = Angle(0, 0, 60),
            offset = { x = -26, y = 0 },
            color = Color(255, 30, 0),
            scale = 0.0055,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            condition = Helpers.And(Conditions.DashboardEnabled, Conditions.Gears.IsReverse),
        },
        {
            getter = function() return Formatters.Gears.Neutral end,
            pos = Vector(-17.57, 50.65, 58),
            ang = Angle(0, 0, 60),
            offset = { x = 0, y = 0 },
            color = Color(255, 255, 255),
            scale = 0.0055,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            condition = Helpers.And(Conditions.DashboardEnabled, Helpers.Not(Conditions.Gears.IsNeutral)),
        },
        {
            getter = function() return Formatters.Gears.Neutral end,
            pos = Vector(-17.57, 50.65, 58),
            ang = Angle(0, 0, 60),
            offset = { x = 0, y = 0 },
            color = Color(255, 30, 0),
            scale = 0.0055,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            condition = Helpers.And(Conditions.DashboardEnabled, Conditions.Gears.IsNeutral)
        },
        {
            getter = function() return Formatters.Gears.Drive end,
            pos = Vector(-17.57, 50.65, 58),
            ang = Angle(0, 0, 60),
            offset = { x = 26, y = 0 },
            color = Color(255, 255, 255),
            scale = 0.0055,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            condition = Helpers.And(Conditions.DashboardEnabled, Helpers.Not(Conditions.Gears.IsDrive)),
        },
        {
            getter = function() return Formatters.Gears.Drive end,
            pos = Vector(-17.57, 50.65, 58),
            ang = Angle(0, 0, 60),
            offset = { x = 26, y = 0 },
            color = Color(255, 30, 0),
            scale = 0.0055,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            condition = Helpers.And(Conditions.DashboardEnabled, Conditions.Gears.IsDrive),
        },
        {
            getter = function() return Formatters.Gears.Low end,
            condition = Conditions.DashboardEnabled,
            pos = Vector(-17.57, 50.65, 58),
            ang = Angle(0, 0, 60),
            offset = { x = 52, y = 0 },
            color = Color(255, 255, 255),
            scale = 0.0055,
            font = "HUSKY_chevy_zr2",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
        },
    }
}

SimfphysExtraFeatures.Registry.Register("models/ctvehicles/chevrolet/colorado_zr2.mdl", data)
