local ActiveVehicles = SimfphysExtraFeatures.ActiveVehicles
local Config = SimfphysExtraFeatures.Dashboard.Config
local Registry = SimfphysExtraFeatures.Registry

local function CheckCondition(veh, ind)
    if not ind.condition then
        return true
    end

    return ind.condition(veh)
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
        if not data or not data.indicators then continue end

        for _, indicator in ipairs(data.indicators) do
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
            
            surface.DrawTexturedRectRotated(dim.x, dim.y, dim.w, dim.h, indicator.rot or 0)

            cam.End3D2D()
        end
    end
end



hook.Add("OnEntityCreated", "SEF_AddVehicleToCache", SimfphysExtraFeatures.ActiveVehicles.OnEntityCreated)
hook.Add("EntityRemoved", "SEF_RemoveVehicleFromCache", SimfphysExtraFeatures.ActiveVehicles.OnEntityRemoved)
hook.Add("PostDrawTranslucentRenderables", "SEF_Dashboard", DrawDashboard_v1)
