local Features = SimfphysExtraFeatures.Features

local Keybinds = {
    [KEY_G] = "trunk",
    [KEY_H] = "hood",
    [KEY_O] = "air_up",
    [KEY_L] = "air_down",
}

local function ProcessInput(ply, button)
    local featureId = Keybinds[button]
    if not featureId then return end

    Features.Execute(featureId, ply)
end

hook.Add("PlayerButtonDown", "SEF_Features", ProcessInput)
