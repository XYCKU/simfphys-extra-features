local Conditions = SimfphysExtraFeatures.Conditions
local Features = SimfphysExtraFeatures.Features


Features.RegisterDefinition("trunk", {
    name = "Toggle Trunk",

    condition = function(veh, ply)
        return veh:GetDriver() == ply
    end,

    action = function(veh)
        local st = Features.GetFeatureState(
            veh,
            "trunk"
        )

        local target = st.to > 0.5 and 0 or 1

        st.from = st.value
        st.to = target

        local distance = math.abs(
            st.to - st.from
        )

        st.duration = (st.duration or 1) * distance

        st.active = true
        st.startTime = CurTime()

        Features.MarkVehicleActive(veh)
    end
})

Features.RegisterDefinition("hood", {
    name = "Toggle Hood",

    condition = function(veh, ply)
        return veh:GetDriver() == ply and veh.hood ~= nil
    end,

    action = function(veh)
        veh.hood = math.abs(1 - veh.hood)
    end
})

Features.RegisterDefinition("air_up", {
    name = "Raise Suspension",

    condition = function(veh, ply)
        return veh:GetDriver() == ply and veh.HasAirSuspension
    end,

    action = function(veh)
        local h = veh:GetFrontSuspensionHeight()
        if h < 0 then
            veh:SetFrontSuspensionHeight(h + 0.1)
            veh:SetRearSuspensionHeight(h + 0.1)
        end
    end
})

Features.RegisterDefinition("air_down", {
    name = "Lower Suspension",

    condition = function(veh, ply)
        return veh:GetDriver() == ply and veh.HasAirSuspension
    end,

    action = function(veh)
        local h = veh:GetFrontSuspensionHeight()
        if h > -0.4 then
            veh:SetFrontSuspensionHeight(h - 0.1)
            veh:SetRearSuspensionHeight(h - 0.1)
        end
    end
})

local Keybinds = {
    [KEY_G] = "trunk",
    [KEY_H] = "hood",
    [KEY_O] = "air_up",
    [KEY_L] = "air_down",
}

local NetMessage = "SEF_RequestFeature"
local AllowedFeatures = {}

for _, feature_id in pairs(Keybinds) do
    AllowedFeatures[feature_id] = true
end

if SERVER then
    util.AddNetworkString(NetMessage)

    net.Receive(NetMessage, function(_, ply)
        local feature_id = net.ReadString()
        if not AllowedFeatures[feature_id] then return end

        Features.Execute(feature_id, ply)
    end)
end

if CLIENT then
    local function ProcessInput(_, button)
        local feature_id = Keybinds[button]
        if not feature_id then return end

        net.Start(NetMessage)
        net.WriteString(feature_id)
        net.SendToServer()
    end

    hook.Add("PlayerButtonUp", "SEF_Features", ProcessInput)
end
