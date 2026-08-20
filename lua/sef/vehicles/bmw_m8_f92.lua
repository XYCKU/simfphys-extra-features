local Formatters = SimfphysExtraFeatures.Formatters
local Conditions = SimfphysExtraFeatures.Conditions
local Helpers = SimfphysExtraFeatures.Helpers
local Registry = SimfphysExtraFeatures.Registry

local DashboardActive = Helpers.Or(
    Conditions.EngineRunning,
    Conditions.LampsEnabled,
    Conditions.ParkingLights,
    Conditions.FogLights
)

local data = {
    indicators = {
        {
            sprite = "husky_dashboard/hbrake",
            type = "handbrake",
            condition = DashboardActive,
            pos = Vector(-15.5, 30.37, 42.7),
            ang = Angle(0, 0, 72.65),
            scale = 0.0035,
            dim = { x = -64, y = -64, w = 128, h = 128 }
        },
        {
            sprite = "husky_dashboard/lamps",
            type = "highbeam",
            condition = DashboardActive,
            pos = Vector(-25.38, 29.3, 39.3),
            ang = Angle(0, 0, 72.65),
            scale = 0.008,
            dim = { x = -32, y = -32, w = 64, h = 64 }
        },
        {
            sprite = "husky_dashboard/lights",
            type = "lowbeam",
            condition = DashboardActive,
            pos = Vector(-25.38, 29.3, 39.3),
            ang = Angle(0, 0, 72.65),
            scale = 0.008,
            dim = { x = -32, y = -32, w = 64, h = 64 }
        },
        {
            sprite = "husky_dashboard/check",
            type = "check_engine",
            condition = DashboardActive,
            pos = Vector(-13.7, 29.52, 40),
            ang = Angle(0, 0, 72.65),
            scale = 0.007
        },
        {
            sprite = "husky_dashboard/turn_signal",
            type = "left_signal",
            condition = DashboardActive,
            pos = Vector(-20.38, 30.3, 42.9),
            ang = Angle(0, 0, 72.65),
            scale = 0.007,
            rot = 180
        },
        {
            sprite = "husky_dashboard/turn_signal",
            type = "right_signal",
            condition = DashboardActive,
            pos = Vector(-17.1, 30.3, 42.9),
            ang = Angle(0, 0, 72.65),
            scale = 0.007
        }
    },
    text_indicators = {
        {
            getter = Formatters.GetAutomaticGearText,
            condition = DashboardActive,
            pos = Vector(-18.9, 29.38, 39.55),
            ang = Angle(0, 0, 72.65),
            offset = { x = 0, y = -360 },
            color = Color(255, 255, 255),
            scale = 0.007,
            font = "HUSKY_BMW_M8",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
        },
        {
            getter = Formatters.GetSpeedInUnits,
            condition = DashboardActive,
            pos = Vector(-18.9, 29.38, 39.55),
            ang = Angle(0, 0, 72.65),
            offset = { x = 0, y = -210 },
            color = Color(255, 255, 255),
            scale = 0.007,
            font = "HUSKY_BMW_M8",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER,
            delay = 0.15
        },
        {
            getter = Formatters.GetSpeedUnits,
            condition = DashboardActive,
            pos = Vector(-18.9, 29.38, 39.55),
            ang = Angle(0, 0, 72.65),
            offset = { x = 130, y = -235 },
            color = Color(50, 50, 50),
            scale = 0.007,
            font = "HUSKY_BMW_M82",
            horAlign = TEXT_ALIGN_LEFT,
            vertAlign = TEXT_ALIGN_CENTER,
            delay = 0.15
        },
        {
            getter = Formatters.GetTime,
            condition = DashboardActive,
            pos = Vector(-18.9, 29.38, 39.55),
            ang = Angle(0, 0, 72.65),
            offset = { x = -565, y = 0 },
            color = Color(255, 255, 255),
            scale = 0.007,
            font = "HUSKY_BMW_M82",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        },
        {
            getter = Formatters.GetOutsideTemperature,
            condition = DashboardActive,
            pos = Vector(-18.9, 29.38, 39.55),
            ang = Angle(0, 0, 72.65),
            offset = { x = 630, y = 0 },
            color = Color(255, 255, 255),
            scale = 0.007,
            font = "HUSKY_BMW_M82",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        }
    }
}

Registry.Register("models/ctvehicles/bmw/m8_f92.mdl", data)
