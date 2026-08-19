SimfphysExtraFeatures = SimfphysExtraFeatures or {}
SimfphysExtraFeatures.Features = SimfphysExtraFeatures.Features or {}

local Features = SimfphysExtraFeatures.Features

Features.Definitions = Features.Definitions or {}
Features.Configs = Features.Configs or {}
Features.Types = Features.Types or {}
Features.Modifiers = Features.Modifiers or {}

local AnimatingVehicles = {}

--========================================================--
--  FEATURE DEFINITIONS
--========================================================--

function Features.RegisterDefinition(id, data)
    data.id = id

    Features.Definitions[id] = data
end

function Features.GetDefinition(id)
    return Features.Definitions[id]
end

--========================================================--
--  VEHICLE CONFIGS
--========================================================--

function Features.RegisterVehicle(model, data)
    Features.Configs[model] = data.features or {}
end

function Features.GetVehicleFeatures(model)
    return Features.Configs[model]
end

--========================================================--
--  STATE
--========================================================--

function Features.GetVehicleState(veh)
    veh._sef = veh._sef or {}
    return veh._sef
end

function Features.GetFeatureState(veh, feature_id)
    local state = Features.GetVehicleState(veh)

    state[feature_id] = state[feature_id] or {
        value = 0,

        from = 0,
        to = 1,

        active = false,

        startTime = 0,
        duration = 1,
    }

    return state[feature_id]
end

--========================================================--
--  ACTIVE VEHICLES
--========================================================--

function Features.MarkVehicleActive(veh)
    AnimatingVehicles[veh] = true
end

--========================================================--
--  KEYFRAME HELPERS
--========================================================--

local function SortedKeys(tbl)
    local keys = {}

    for k in pairs(tbl) do
        keys[#keys + 1] = k
    end

    table.sort(keys)

    return keys
end

local function FindKeyframePair(frames, value)
    local keys = SortedKeys(frames)

    local lower = keys[1]
    local upper = keys[#keys]

    for i = 1, #keys do
        local k = keys[i]

        if k <= value then
            lower = k
        end

        if k >= value then
            upper = k
            break
        end
    end

    return lower, upper
end

local function InterpolateKeyframes(frames, value)
    local k1, k2 = FindKeyframePair(frames, value)

    local v1 = frames[k1]
    local v2 = frames[k2]

    if k1 == k2 then
        return v1
    end

    local frac = (value - k1) / (k2 - k1)

    if isangle(v1) then
        return LerpAngle(frac, v1, v2)
    end

    if isvector(v1) then
        return LerpVector(frac, v1, v2)
    end

    return Lerp(frac, v1, v2)
end

Features.InterpolateKeyframes = InterpolateKeyframes

--========================================================--
--  EASING
--========================================================--

local Easings = {}

Easings.linear = function(t)
    return t
end

Easings.ease_in_out = function(t)
    return t * t * (3 - 2 * t)
end

Easings.ease_out = function(t)
    return 1 - (1 - t) * (1 - t)
end

Easings.ease_in = function(t)
    return t * t
end

Features.Easings = Easings

--========================================================--
--  MODIFIERS
--========================================================--

Features.Modifiers["bone_angle"] = function(veh, value, data)
    local bone = veh:LookupBone(data.bone)
    if not bone then return end

    local ang = InterpolateKeyframes(
        data.keyframes,
        value
    )

    veh:ManipulateBoneAngles(bone, ang)
end

Features.Modifiers["bone_position"] = function(veh, value, data)
    local bone = veh:LookupBone(data.bone)
    if not bone then return end

    local pos = InterpolateKeyframes(
        data.keyframes,
        value
    )

    veh:ManipulateBonePosition(bone, pos)
end

Features.Modifiers["bodygroup"] = function(veh, value, data)
    local bg = InterpolateKeyframes(
        data.keyframes,
        value
    )

    veh:SetBodygroup(
        data.id,
        math.Round(bg)
    )
end

Features.Modifiers["skin"] = function(veh, value, data)
    local skin = InterpolateKeyframes(
        data.keyframes,
        value
    )

    veh:SetSkin(math.Round(skin))
end

Features.Modifiers["pose_parameter"] = function(veh, value, data)
    local pose = InterpolateKeyframes(
        data.keyframes,
        value
    )

    veh:SetPoseParameter(data.name, pose)
end

--========================================================--
--  TYPES
--========================================================--

Features.Types["animated"] = {
    tick = function(veh, st, cfg, dt)
        local duration = cfg.duration or 1

        local elapsed = CurTime() - st.startTime

        local frac = math.Clamp(
            elapsed / duration,
            0,
            1
        )

        local easing = Features.Easings[
            cfg.easing or "linear"
        ]

        frac = easing(frac)

        st.value = Lerp(
            frac,
            st.from,
            st.to
        )

        for _, modifier in ipairs(cfg.modifiers or {}) do
            local handler = Features.Modifiers[
                modifier.type
            ]

            if handler then
                handler(veh, st.value, modifier)
            end
        end

        if elapsed >= duration then
            st.active = false
            st.value = st.to
        end
    end
}

--========================================================--
--  EXECUTE
--========================================================--

function Features.Execute(feature_id, ply, extra)
    if not SERVER then return end
    if not IsValid(ply) then return end
    if not ply.GetSimfphys then return end

    local definition = Features.GetDefinition(feature_id)
    if not definition then return end

    local veh = ply:GetSimfphys()
    if not IsValid(veh) then return end

    local vehicleFeatures = Features.GetVehicleFeatures(
        veh:GetModel()
    )

    if not vehicleFeatures then return end

    local cfg = vehicleFeatures[feature_id]
    if not cfg then return end

    if definition.condition and not definition.condition(veh, ply, cfg, extra) then
        return
    end

    definition.action(veh, ply, cfg, extra)
end

--========================================================--
--  TICK VEHICLE
--========================================================--

function Features.TickVehicle(veh, dt)
    local vehicleFeatures = Features.GetVehicleFeatures(veh:GetModel())
    if not vehicleFeatures then return end

    local hasActive = false

    for feature_id, cfg in pairs(vehicleFeatures) do
        local st = Features.GetFeatureState(
            veh,
            feature_id
        )
        
        if not st.active then
            continue
        end

        hasActive = true

        local typeHandler = Features.Types[cfg.type]

        if typeHandler and typeHandler.tick then
            typeHandler.tick(
                veh,
                st,
                cfg,
                dt
            )
        end
    end

    if not hasActive then
        AnimatingVehicles[veh] = nil
    end
end

if SERVER then
    hook.Add("Think", "SEF_FeaturesTick", function()
        local dt = FrameTime()

        for veh in pairs(AnimatingVehicles) do
            if not IsValid(veh) then
                AnimatingVehicles[veh] = nil
                continue
            end

            Features.TickVehicle(veh, dt)
        end
    end)
end
