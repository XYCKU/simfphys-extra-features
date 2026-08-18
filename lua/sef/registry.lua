SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Registry = SimfphysExtraFeatures.Registry or {}

local Registry = SimfphysExtraFeatures.Registry
local Storage = {}

local function RegisterVehicleFeatures(model, data)
    local Features = SimfphysExtraFeatures.Features
    if not Features or not Features.RegisterVehicle then return end

    Features.RegisterVehicle(model, data)
end

function Registry.Register(model, data)
    if not model or not data then return end

    if Storage[model] then
        print("[SEF] Warning: overriding dashboard for model:", model)
    end

    Storage[model] = data

    RegisterVehicleFeatures(model, data)
end

function Registry.GetForModel(model)
    return Storage[model]
end

function Registry.SyncFeatures()
    for model, data in pairs(Storage) do
        RegisterVehicleFeatures(model, data)
    end
end
