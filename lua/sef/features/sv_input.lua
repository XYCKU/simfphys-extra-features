local Features = SimfphysExtraFeatures.Features

local Keybinds = {
    [KEY_G] = { id = "trunk" },
    [KEY_H] = { id = "hood" },
    [KEY_O] = { id = "air_suspension", direction = 1 },
    [KEY_L] = { id = "air_suspension", direction = -1 },
}

local function ProcessInput(ply, button)
    local keybind = Keybinds[button]
    if not keybind then return end

    Features.Execute(keybind.id, ply, keybind.direction)
end

hook.Add("PlayerButtonDown", "SEF_Features", ProcessInput)
