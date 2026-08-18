local Features = SimfphysExtraFeatures.Features


Features.RegisterDefinition("trunk", {
    name = "Toggle Trunk",

    condition = function(veh, ply, cfg)
        return veh:GetDriver() == ply
            and (not cfg.field or isnumber(veh[cfg.field]))
    end,

    action = function(veh, _, cfg)
        if cfg.field then
            veh[cfg.field] = math.abs(1 - veh[cfg.field])
            return
        end

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

local MinSuspensionHeight = -0.4
local MaxSuspensionHeight = 0
local SuspensionStep = 0.1

local function AdjustSuspensionHeight(veh, amount)
    local front = veh:GetFrontSuspensionHeight()
    local rear = veh:GetRearSuspensionHeight()
    local newFront = math.Clamp(front + amount, MinSuspensionHeight, MaxSuspensionHeight)
    local newRear = math.Clamp(rear + amount, MinSuspensionHeight, MaxSuspensionHeight)

    if newFront ~= front then
        veh:SetFrontSuspensionHeight(newFront)
    end

    if newRear ~= rear then
        veh:SetRearSuspensionHeight(newRear)
    end
end

Features.RegisterDefinition("air_up", {
    name = "Raise Suspension",

    condition = function(veh, ply)
        return veh:GetDriver() == ply
    end,

    action = function(veh)
        AdjustSuspensionHeight(veh, SuspensionStep)
    end
})

Features.RegisterDefinition("air_down", {
    name = "Lower Suspension",

    condition = function(veh, ply)
        return veh:GetDriver() == ply
    end,

    action = function(veh)
        AdjustSuspensionHeight(veh, -SuspensionStep)
    end
})
