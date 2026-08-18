local Formatters = SimfphysExtraFeatures.Formatters
local Conditions = SimfphysExtraFeatures.Conditions

local function GetGearText(veh)
    if Conditions.Gears.IsReverse(veh) then
        return Formatters.Gears.Reverse
    end

    if Conditions.Gears.IsNeutral(veh) then
        if Conditions.Stationary(veh) and Conditions.Handbrake(veh) then
            return Formatters.Gears.Parking
        end

        return Formatters.Gears.Neutral
    end

    return Conditions.Gears.ForwardGear(veh) or ""
end

local data = {
    indicators = {},

    text_indicators = {
        {
            getter = GetGearText,
            condition = Conditions.EngineRunning,
            pos = Vector(18.35, 6.15, 42.8),
            ang = Angle(0, 0, 77.5),
            color = Color(255, 0, 0),
            scale = 0.009,
            font = "HUSKY_supra2020",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        },
        {
            getter = Formatters.GetSpeedInUnits,
            condition = Conditions.EngineRunning,
            pos = Vector(18.35, 6.15, 42.8),
            ang = Angle(0, 0, 77.5),
            offset = { x = -300, y = 20 },
            color = Color(255, 255, 255),
            scale = 0.009,
            font = "HUSKY_supra2020_2",
            horAlign = TEXT_ALIGN_RIGHT,
            vertAlign = TEXT_ALIGN_CENTER,
            delay = 0.15
        },
        {
            getter = Formatters.GetSpeedUnits,
            condition = Conditions.EngineRunning,
            pos = Vector(18.35, 6.15, 42.8),
            ang = Angle(0, 0, 77.5),
            offset = { x = -240, y = 35 },
            color = Color(255, 255, 255),
            scale = 0.009,
            font = "HUSKY_supra2020_3",
            horAlign = TEXT_ALIGN_RIGHT,
            vertAlign = TEXT_ALIGN_CENTER,
            delay = 0.15
        },
        {
            getter = Formatters.GetTime,
            condition = Conditions.EngineRunning,
            pos = Vector(20.8, 6.35, 43.8),
            ang = Angle(0, 0, 77.5),
            color = Color(255, 255, 255),
            scale = 0.0025,
            font = "HUSKY_supra2020",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        },
        {
            getter = Formatters.GetOutsideTemperature,
            condition = Conditions.EngineRunning,
            pos = Vector(20.8, 6.35, 43.8),
            ang = Angle(0, 0, 77.5),
            offset = { x = 250, y = 0 },
            color = Color(255, 255, 255),
            scale = 0.0025,
            font = "HUSKY_supra2020",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        }
    }
}

SimfphysExtraFeatures.Registry.Register("models/ctvehicles/toyota/gr_supra.mdl", data)
