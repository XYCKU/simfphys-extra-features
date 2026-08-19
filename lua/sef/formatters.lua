SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Formatters = SimfphysExtraFeatures.Formatters or {}

SimfphysExtraFeatures.Conditions = SimfphysExtraFeatures.Conditions or {}
SimfphysExtraFeatures.Conditions.Gears = SimfphysExtraFeatures.Conditions.Gears or {}

local Conditions = SimfphysExtraFeatures.Conditions
local Environment = SimfphysExtraFeatures.Providers.Environment
local Formatters = SimfphysExtraFeatures.Formatters
local Speed = SimfphysExtraFeatures.Providers.Speed
local SpeedUnits = SimfphysExtraFeatures.Units.Speed
local TempUnits = SimfphysExtraFeatures.Units.Temperature

Formatters.Gears = Formatters.Gears or {
    Parking = "P",
    Reverse = "R",
    Neutral = "N",
    Drive = "D",
    Sport = "S",
    Low = "L"
}

function Formatters.GetAutomaticGearText(veh)
    local gear = Conditions.Gears.GetAutomaticGear(veh)
    if gear == Conditions.Gears.Parking then return Formatters.Gears.Parking end
    if gear == Conditions.Gears.Reverse then return Formatters.Gears.Reverse end
    if gear == Conditions.Gears.Neutral then return Formatters.Gears.Neutral end
    if gear == Conditions.Gears.Sport then return Formatters.Gears.Sport end
    return Formatters.Gears.Drive
end

function Formatters.GetDriveModeText(veh)
    if Conditions.Gears.IsReverse(veh) then return Formatters.Gears.Reverse end
    if Conditions.Gears.IsNeutral(veh) then return Formatters.Gears.Neutral end
    return Formatters.Gears.Drive
end

function Formatters.GetGearText(veh)
    if Conditions.Gears.IsReverse(veh) then return Formatters.Gears.Reverse end
    if Conditions.Gears.IsNeutral(veh) then return Formatters.Gears.Neutral end
    return Conditions.Gears.ForwardGear(veh) or ""
end

function Formatters.SpeedUnitToString(unit)
    if unit == SpeedUnits.MPH then
        return "mph"
    end
    if unit == SpeedUnits.KMH then
        return "km/h"
    end

    return ""
end

function Formatters.GetSpeedUnits(veh)
    return Formatters.SpeedUnitToString(Speed.GetUnit())
end

function Formatters.GetSpeedUnitsUpper(veh)
    return Formatters.SpeedUnitToUpperString(Speed.GetUnit())
end

function Formatters.GetSpeedInUnits(veh)
    return math.Round(Speed.GetInUnit(veh), 0)
end

function Formatters.GetSpeedWithUnits(veh)
    return Formatters.GetSpeedInUnits(veh) .. " " .. Formatters.GetSpeedUnits(veh)
end

function Formatters.TempUnitToString(unit)
    if unit == TempUnits.Fahrenheit then
        return "°F"
    end
    if unit == TempUnits.Celsius then
        return "°C"
    end

    return ""
end

function Formatters.GetOutsideTemperature()
    local provider = Environment.GetProvider()
    return math.Round(provider.GetTemperature(), 0) .. " " .. Formatters.TempUnitToString(provider.GetTempUnit())
end

function Formatters.GetOutsideTemperatureShort()
    local provider = Environment.GetProvider()
    return math.Round(provider.GetTemperature(), 0) .. "°"
end

function Formatters.GetTime()
    local provider = Environment.GetProvider()
    local minutes = provider.GetTime()
    local hours = math.floor(minutes / 60)
    local remainingMinutes = minutes % 60

    return string.format("%02d:%02d", hours, remainingMinutes)
end

function Formatters.SpeedUnitToUpperString(unit)
    if unit == SpeedUnits.MPH then
        return "MPH"
    end
    if unit == SpeedUnits.KMH then
        return "KM/H"
    end

    return ""
end
