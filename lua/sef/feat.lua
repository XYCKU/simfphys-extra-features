local Conditions = SimfphysExtraFeatures.Conditions
local Features = SimfphysExtraFeatures.Features

--[[

    feature: 
        - id
        - name
        - condition to activate
        - tick_action
]]

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

Features.Register("hood", {
    name = "Toggle Hood",

    condition = function(veh, ply)
        return veh:GetDriver() == ply and veh.hood ~= nil
    end,

    action = function(veh)
        veh.hood = math.abs(1 - veh.hood)
    end
})

Features.Register("air_up", {
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

Features.Register("air_down", {
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

local function ProcessInput(ply, button)
    local feature = Keybinds[button]
    if not feature then return end
    print(feature)
    SimfphysExtraFeatures.Features.Execute(feature, ply)
end

hook.Add("PlayerButtonUp", "SEF_Features", ProcessInput)