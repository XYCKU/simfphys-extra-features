local Features = SimfphysExtraFeatures.Features

local MessageName = "SEF_RequestFeature"

util.AddNetworkString(MessageName)

local function ExecuteBinding(ply, feature_id, binding_id)
    local binding = Features.GetBinding(feature_id, binding_id)
    if not binding then return end

    Features.Execute(
        feature_id,
        ply,
        binding.extra
    )
end

net.Receive(MessageName, function(_, ply)
    local feature_id = net.ReadString()
    local binding_id = net.ReadString()

    if #feature_id > 64 or #binding_id > 64 then return end

    ExecuteBinding(ply, feature_id, binding_id)
end)

hook.Add("PlayerButtonDown", "SEF_Features", function(ply, button)
    for feature_id, definition in pairs(Features.GetDefinitions()) do
        for _, binding in ipairs(definition.bindings) do
            local convar_name = Features.GetBindingConVarName(
                feature_id,
                binding.id
            )

            if ply:GetInfoNum(convar_name, KEY_NONE) == button then
                ExecuteBinding(ply, feature_id, binding.id)
            end
        end
    end
end)
