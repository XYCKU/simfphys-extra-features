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

local function SetSuspensionHeight(veh, state, level)
    veh:SetFrontSuspensionHeight(state.defaultFrontHeight + level)
    veh:SetRearSuspensionHeight(state.defaultRearHeight + level)
end

local function GetDefaultSuspensionLevel(levels)
    if not levels then return end

    for index, height in ipairs(levels) do
        if height == 0 then
            return index
        end
    end
end

Features.RegisterDefinition("air_suspension", {
    name = "Adjust Air Suspension",

    condition = function(veh, ply)
        return veh:GetDriver() == ply
    end,

    action = function(veh, ply, config, direction)
        if direction ~= 1 and direction ~= -1 then return end

        local state = Features.GetFeatureState(veh, "air_suspension")
        local levelIndex = state.levelIndex

        if not levelIndex then
            levelIndex = GetDefaultSuspensionLevel(config.levels)
            if not levelIndex then
                if not state.invalidConfig then
                    ply:ChatPrint("[SEF] Air suspension config error: levels must contain 0.0.")
                    print("[SEF] air_suspension requires a levels array containing 0.0 for:", veh:GetModel())
                    state.invalidConfig = true
                end

                return
            end

            state.levelIndex = levelIndex
            state.defaultFrontHeight = veh:GetFrontSuspensionHeight()
            state.defaultRearHeight = veh:GetRearSuspensionHeight()
        end

        local nextIndex = math.Clamp(
            levelIndex + direction,
            1,
            #config.levels
        )

        if nextIndex == levelIndex then
            return
        end

        state.levelIndex = nextIndex
        SetSuspensionHeight(veh, state, config.levels[nextIndex])
    end
})
