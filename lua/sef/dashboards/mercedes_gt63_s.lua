local Conditions = SimfphysExtraFeatures.Conditions
local Formatters = SimfphysExtraFeatures.Formatters

local function Not(fn)
    return function(...)
        return not fn(...)
    end
end

local function And(...)
    local fns = {...}
    return function(...)
        for i = 1, #fns do
            if not fns[i](...) then return false end
        end
        return true
    end
end

local function Or(...)
    local fns = {...}
    return function(...)
        for i = 1, #fns do
            if fns[i](...) then return true end
        end
        return false
    end
end

local data = {
    indicators = {
        {
            sprite = "husky_dashboard/square",
            pos = Vector(-15.6, 32.561, 41.135),
            ang = Angle(0, 0, 81),
            scale = 0.0025,
            dim = { x = -64, y = -64, w = 128, h = 128 },
            condition = Conditions.Gears.IsReverse
        },
        {
            sprite = "husky_dashboard/square",
            pos = Vector(-15.88, 32.561, 41.135),
            ang = Angle(0, 0, 81),
            scale = 0.0025,
            dim = { x = -64, y = -64, w = 128, h = 128 },
            condition = Conditions.Gears.IsParking
        },
        {
            sprite = "husky_dashboard/square",
            pos = Vector(-15.32, 32.561, 41.135),
            ang = Angle(0, 0, 81),
            scale = 0.0025,
            dim = { x = -64, y = -64, w = 128, h = 128 },
            condition = And(Conditions.Gears.IsNeutral, Not(Conditions.Gears.IsParking))
        },
        {
            sprite = "husky_dashboard/square",
            pos = Vector(-15.04, 32.561, 41.135),
            ang = Angle(0, 0, 81),
            scale = 0.0025,
            dim = { x = -64, y = -64, w = 128, h = 128 },
            condition = Conditions.Gears.IsDrive
        },

        {
            sprite = "husky_dashboard/hbrake",
            type = "handbrake",
            pos = Vector(-20.85, 32.83, 42.85),
            ang = Angle(0, 0, 81),
            scale = 0.0035,
            dim = { x = -64, y = -64, w = 128, h = 128 }
        },
        {
            sprite = "husky_dashboard/lamps",
            type = "highbeam",
            pos = Vector(-16, 33.1, 45),
            ang = Angle(0, 0, 81),
            scale = 0.008
        },
        {
            sprite = "husky_dashboard/lights",
            type = "lowbeam",
            pos = Vector(-16, 33.1, 45),
            ang = Angle(0, 0, 81),
            scale = 0.008
        },
        {
            sprite = "husky_dashboard/fog_rear",
            type = "fog",
            pos = Vector(-17, 33.1, 45),
            ang = Angle(0, 0, 81),
            scale = 0.007
        },
        {
            sprite = "husky_dashboard/check",
            type = "check_engine",
            pos = Vector(-23.2, 32.86, 43),
            ang = Angle(0, 0, 81),
            scale = 0.007
        },
        {
            sprite = "husky_dashboard/turn_signal",
            type = "left_signal",
            pos = Vector(-20.3, 33.15, 45.4),
            ang = Angle(0, 0, 81),
            scale = 0.007,
            rot = 180
        },
        {
            sprite = "husky_dashboard/turn_signal",
            type = "right_signal",
            pos = Vector(-14.9, 33.15, 45.4),
            ang = Angle(0, 0, 81),
            scale = 0.007
        }
    },

    text_indicators = {
        {
            getter = function() return Formatters.Gears.Drive end,
            pos = Vector(-15.2, 32.59, 41.3),
            ang = Angle(0, 0, 81),
            offset = { x = 0, y = 0 },
            color = Color(200, 200, 200),
            scale = 0.007,
            font = "HUSKY_BMW_X6m",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        },
        {
            getter = function() return Formatters.Gears.Neutral end,
            pos = Vector(-15.2, 32.59, 41.3),
            ang = Angle(0, 0, 81),
            offset = { x = -40, y = 0 },
            color = Color(200, 200, 200),
            scale = 0.007,
            font = "HUSKY_BMW_X6m",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        },
        {
            getter = function() return Formatters.Gears.Reverse end,
            pos = Vector(-15.2, 32.59, 41.3),
            ang = Angle(0, 0, 81),
            offset = { x = -80, y = 0 },
            color = Color(200, 200, 200),
            scale = 0.007,
            font = "HUSKY_BMW_X6m",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        },
        {
            getter = function() return Formatters.Gears.Parking end,
            pos = Vector(-15.2, 32.59, 41.3),
            ang = Angle(0, 0, 81),
            offset = { x = -120, y = 0 },
            color = Color(200, 200, 200),
            scale = 0.007,
            font = "HUSKY_BMW_X6m",
            horAlign = TEXT_ALIGN_CENTER,
            vertAlign = TEXT_ALIGN_CENTER
        }
    }
}

SimfphysExtraFeatures.Registry.Register("models/crsk_autos/mercedes-benz/gt63s_coupe_amg_2018.mdl", data)