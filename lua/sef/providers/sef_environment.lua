SimfphysExtraFeatures = SimfphysExtraFeatures or {}

SimfphysExtraFeatures.Providers = SimfphysExtraFeatures.Providers or {}
SimfphysExtraFeatures.Providers.Environment = SimfphysExtraFeatures.Providers.Environment or {}

SimfphysExtraFeatures.Units = SimfphysExtraFeatures.Units or {}

SimfphysExtraFeatures.Units.Temperature = SimfphysExtraFeatures.Units.Temperature or {
    Celsius = 1,
    Fahrenheit = 2
}

local TempUnits = SimfphysExtraFeatures.Units.Temperature
local Environment = SimfphysExtraFeatures.Providers.Environment

local DefaultProviderImpl = {}

function DefaultProviderImpl.GetTemperature()
    if DefaultProviderImpl.GetTempUnit() == TempUnits.Fahrenheit then
        return 76
    end

    return 24
end

function DefaultProviderImpl.GetTempUnit()
    if GetConVar("cl_simfphys_hudmph"):GetBool() then
        return TempUnits.Fahrenheit
    end
    return TempUnits.Celsius
end

function DefaultProviderImpl.GetTime()
    local dateTable = os.date("*t")
    return dateTable.hour * 60 + dateTable.min
end

local StormFoxProviderImpl = {}

function StormFoxProviderImpl.GetTemperature()
    local fahrenheit = StormFoxProviderImpl.GetTempUnit() == TempUnits.Fahrenheit
    return StormFox.GetTemperature(fahrenheit)
end

function StormFoxProviderImpl.GetTempUnit()
    return DefaultProviderImpl.GetTempUnit()
end

function StormFoxProviderImpl.GetTime()
    return StormFox.GetTime(true)
end

function Environment.GetProvider()
    if StormFox then
        return StormFoxProviderImpl
    end

    return DefaultProviderImpl
end
