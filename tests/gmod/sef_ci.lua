if not SERVER then return end

local FailureCount = 0
local AssertionCount = 0
local RequestFeatureHandler

local function Assert(condition, message)
    AssertionCount = AssertionCount + 1

    if not condition then
        error(message or "assertion failed", 2)
    end
end

local function Test(name, callback)
    local ok, errorMessage = xpcall(callback, debug.traceback)

    if ok then
        print("[SEF CI] PASS", name)
        return
    end

    FailureCount = FailureCount + 1
    ErrorNoHalt("[SEF CI] FAIL " .. name .. "\n" .. errorMessage .. "\n")
end

local function CompileDirectory(path)
    local files, directories = file.Find(path .. "/*", "LUA")
    Assert(files ~= nil and directories ~= nil, "could not list " .. path)

    for _, fileName in ipairs(files) do
        local filePath = path .. "/" .. fileName
        local compiled = CompileFile(filePath, false)
        Assert(type(compiled) == "function", "could not compile " .. filePath)
    end

    for _, directoryName in ipairs(directories) do
        CompileDirectory(path .. "/" .. directoryName)
    end
end

local OriginalNetReceive = net.Receive
net.Receive = function(name, callback)
    if name == "SEF_RequestFeature" then
        RequestFeatureHandler = callback
    end

    return OriginalNetReceive(name, callback)
end

include("tests/sef_init.lua")
net.Receive = OriginalNetReceive

local Registry = SimfphysExtraFeatures.Registry
local Features = SimfphysExtraFeatures.Features

local function ReadFeatureRequest(featureID, bindingID, player)
    local values = { featureID, bindingID }
    local originalReadString = net.ReadString

    net.ReadString = function()
        return table.remove(values, 1)
    end

    local ok, errorMessage = xpcall(function()
        RequestFeatureHandler(0, player)
    end, debug.traceback)

    net.ReadString = originalReadString

    if not ok then
        error(errorMessage, 0)
    end
end

local function CreateProp(model)
    local entity = ents.Create("prop_physics")
    Assert(IsValid(entity), "could not create test prop")

    entity:SetModel(model)
    entity:Spawn()

    Assert(IsValid(entity), "test prop became invalid")
    return entity
end

local function TestFeatureAuthority()
    local vehicle = CreateProp("models/props_c17/oildrum001.mdl")
    local player = CreateProp("models/props_junk/PopCan01a.mdl")
    local entityMeta = FindMetaTable("Entity")
    Assert(entityMeta ~= nil, "Entity meta table is unavailable")

    local originalGetSimfphys = entityMeta.GetSimfphys
    local activations = 0

    entityMeta.GetSimfphys = function(entity)
        if entity == player then
            return vehicle
        end

        if originalGetSimfphys then
            return originalGetSimfphys(entity)
        end
    end

    local ok, errorMessage = xpcall(function()
        Features.RegisterDefinition("sef_ci_authority", {
            bindings = {
                {
                    id = "activate",
                    default = KEY_NONE,
                },
            },
            condition = function(_, _, config)
                return config.allowed
            end,
            action = function()
                activations = activations + 1
            end,
        })

        Registry.Register(vehicle:GetModel(), {
            features = {
                sef_ci_authority = {
                    allowed = true,
                },
            },
        })

        Features.Execute("sef_ci_authority", player)
        Assert(activations == 1, "server feature execution did not reach its action")

        Assert(type(RequestFeatureHandler) == "function", "feature net handler was not registered")
        ReadFeatureRequest("sef_ci_authority", "activate", player)
        Assert(activations == 2, "allowed feature request did not reach its action")

        ReadFeatureRequest(string.rep("x", 65), "activate", player)
        Assert(activations == 2, "overlong feature request was not rejected")

        ReadFeatureRequest("sef_ci_authority", "unknown", player)
        Assert(activations == 2, "unknown feature binding was not rejected")

        Registry.Register(vehicle:GetModel(), {
            features = {
                sef_ci_authority = {
                    allowed = false,
                },
            },
        })

        Features.Execute("sef_ci_authority", player)
        Assert(activations == 2, "feature condition did not prevent server execution")
    end, debug.traceback)

    entityMeta.GetSimfphys = originalGetSimfphys

    if IsValid(vehicle) then
        vehicle:Remove()
    end

    if IsValid(player) then
        player:Remove()
    end

    if not ok then
        error(errorMessage, 0)
    end
end

local function RunTests()
    Test("server realm", function()
        Assert(SERVER and not CLIENT, "test did not run in the server realm")
    end)

    Test("compile all SEF Lua", function()
        CompileDirectory("sef")
        Assert(type(CompileFile("tests/sef_init.lua", false)) == "function", "could not compile loader")
    end)

    Test("registry sync", function()
        local model = "models/sef_ci/registry.mdl"
        local data = {
            features = {},
        }

        Registry.Register(model, data)
        Features.Configs[model] = nil
        Registry.SyncFeatures()

        Assert(Registry.GetForModel(model) == data, "registry did not retain data")
        Assert(Features.GetVehicleFeatures(model) == data.features, "registry sync did not restore features")
    end)

    Test("server feature authority", TestFeatureAuthority)

    if FailureCount == 0 then
        print("[SEF CI] PASS " .. AssertionCount .. " assertions")
    else
        ErrorNoHalt("[SEF CI] FAIL " .. FailureCount .. " test groups\n")
    end

    engine.CloseServer()
end

hook.Add("InitPostEntity", "SEF_CI_RunTests", RunTests)
