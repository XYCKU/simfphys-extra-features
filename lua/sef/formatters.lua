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
    if gear == Conditions.Gears.Parking then return Formatters.Parking end
    if gear == Conditions.Gears.Reverse then return Formatters.Reverse end
    if gear == Conditions.Gears.Neutral then return Formatters.Neutral end
    if gear == Conditions.Gears.Sport then return Formatters.Sport end
    return Formatters.Drive
end

function Formatters.SpeedUnitToString(unit)
    if unit == SpeedUnits.MPH then
        return "MPH"
    end
    if unit == SpeedUnits.KMH then
        return "KMH"
    end

    return ""
end

function Formatters.GetSpeedUnits(veh)
    return Formatters.SpeedUnitToString(Speed.GetUnit())
end

function Formatters.GetSpeedInUnits(veh)
    return math.floor(Speed.GetInUnit(veh))
end

function Formatters.GetSpeedWithUnits(veh)
    return Formatters.GetInUnits(veh) .. " " .. Formatters.GetSpeedUnits(veh)
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
    return math.floor(provider.GetTemperature()) .. " " .. Formatters.TempUnitToString(provider.GetTempUnit())
end

function Formatters.GetTime()
    local provider = Environment.GetProvider()
    local minutes = provider.GetTime()
    local h = math.floor(minutes / 60)
    local m = minutes % 60
    return string.format("%02d:%02d", h, m)
end