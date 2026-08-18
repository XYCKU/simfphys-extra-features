local ActiveVehicles = SimfphysExtraFeatures.ActiveVehicles

local Config = SimfphysExtraFeatures.Dashboard.Config
local Types = SimfphysExtraFeatures.Dashboard.PredefinedIndicators

local Registry = SimfphysExtraFeatures.Registry

local default_vector = Vector(0, 0, 0)
local TextCache = setmetatable({}, { __mode = "k" })

local function CheckCondition(veh, ind)
    if ind.type then
        local predefined = Types[ind.type]
        if not predefined then
            print("[SEF] Unknown indicator type:", ind.type)
            return false
        end

        if not predefined(veh) then
            return false
        end
    end

    return not ind.condition or ind.condition(veh)
end

local function GetTextValue(veh, indicator)
    if not indicator.delay then
        return indicator.getter(veh)
    end

    local vehicleCache = TextCache[veh]
    if not vehicleCache then
        vehicleCache = {}
        TextCache[veh] = vehicleCache
    end

    local cached = vehicleCache[indicator]
    local now = CurTime()

    if not cached then
        cached = {}
        vehicleCache[indicator] = cached
    end

    if cached.nextUpdate == nil or now >= cached.nextUpdate then
        cached.value = indicator.getter(veh)
        cached.nextUpdate = now + indicator.delay
    end

    return cached.value
end

local function DrawVehicleDashboardIndicators(veh, indicators)
    for _, indicator in ipairs(indicators) do
        if not CheckCondition(veh, indicator) then continue end

        local material = Material(indicator.sprite)

        cam.Start3D2D(
            veh:LocalToWorld(indicator.pos),
            veh:LocalToWorldAngles(indicator.ang),
            indicator.scale
        )

        surface.SetMaterial(material)
        surface.SetDrawColor(255, 255, 255)
        local dim = indicator.dim or {
            x = -32,
            y = -32,
            w = 64,
            h = 64
        }
        
        surface.DrawTexturedRectRotated(
            dim.x, 
            dim.y, 
            dim.w, 
            dim.h, 
            indicator.rot or 0
        )

        cam.End3D2D()
    end
end

local function DrawVehicleDashboardTexts(veh, texts)
    for _, indicator in ipairs(texts) do
        if not CheckCondition(veh, indicator) then continue end

        if not indicator.getter then continue end

        cam.Start3D2D(
            veh:LocalToWorld(indicator.pos),
            veh:LocalToWorldAngles(indicator.ang),
            indicator.scale
        )

        surface.SetDrawColor(255, 255, 255)

        indicator.offset = indicator.offset or default_vector
        draw.SimpleText(
            GetTextValue(veh, indicator),
            indicator.font, 
            indicator.offset.x, 
            indicator.offset.y, 
            indicator.color, 
            indicator.horAlign, 
            indicator.vertAlign
        )

        cam.End3D2D()
    end
end

local function DrawDashboard_v1()
    local ply = LocalPlayer()
    local plyPos = ply:GetPos()
    local renderDistance = Config.RenderDistance
    local renderDistanceSqr = renderDistance * renderDistance
    for veh in pairs(ActiveVehicles:Get()) do
        if not IsValid(veh) then continue end

        if plyPos:DistToSqr(veh:GetPos()) > renderDistanceSqr then
            continue
        end
        
        local data = Registry.GetForModel(veh:GetModel())
        if not data then continue end
        
        if data.indicators then
            DrawVehicleDashboardIndicators(veh, data.indicators)
        end

        if data.text_indicators then
            DrawVehicleDashboardTexts(veh, data.text_indicators)
        end
    end
end

hook.Add("PostDrawTranslucentRenderables", "SEF_Dashboard", DrawDashboard_v1)
