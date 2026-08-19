local Features = SimfphysExtraFeatures.Features

SimfphysExtraFeatures.Keybindings = SimfphysExtraFeatures.Keybindings or {}

local Keybindings = SimfphysExtraFeatures.Keybindings

local function GetBindingConVar(feature_id, binding)
    local convar_name = Features.GetBindingConVarName(
        feature_id,
        binding.id
    )
    local convar = GetConVar(convar_name)

    if convar then
        return convar, convar_name
    end

    convar = CreateClientConVar(
        convar_name,
        tostring(binding.default or KEY_NONE),
        true,
        true,
        "SEF key binding"
    )

    return convar, convar_name
end

function Keybindings.GetEntries()
    local entries = {}

    for feature_id, definition in pairs(Features.GetDefinitions()) do
        for _, binding in ipairs(definition.bindings) do
            local label = definition.name or feature_id

            if #definition.bindings > 1 and binding.name then
                label = label .. ": " .. binding.name
            end

            entries[#entries + 1] = {
                feature_id = feature_id,
                binding = binding,
                category = definition.category or "General",
                label = label,
            }
        end
    end

    table.sort(entries, function(a, b)
        if a.category ~= b.category then
            return a.category < b.category
        end

        return a.label < b.label
    end)

    return entries
end

function Keybindings.GetCategories()
    local categories = {}
    local names = {}

    for _, entry in ipairs(Keybindings.GetEntries()) do
        local category = categories[entry.category]

        if not category then
            category = {
                name = entry.category,
                entries = {},
            }

            categories[entry.category] = category
            names[#names + 1] = entry.category
        end

        category.entries[#category.entries + 1] = entry
    end

    table.sort(names)

    local sorted_categories = {}

    for _, name in ipairs(names) do
        sorted_categories[#sorted_categories + 1] = categories[name]
    end

    return sorted_categories
end

for _, entry in ipairs(Keybindings.GetEntries()) do
    GetBindingConVar(entry.feature_id, entry.binding)
end

local function AddBindingRow(parent, entry)
    local convar = GetBindingConVar(entry.feature_id, entry.binding)

    local row = vgui.Create("DPanel", parent)
    row:Dock(TOP)
    row:DockMargin(0, 0, 0, 4)
    row:SetTall(24)
    row:SetPaintBackgroundEnabled(false)

    local binder = vgui.Create("DBinder", row)
    binder:Dock(RIGHT)
    binder:SetWide(110)
    binder:SetValue(convar:GetInt())
    binder.OnChange = function(_, key_code)
        convar:SetInt(key_code)
    end

    local label = vgui.Create("DLabel", row)
    label:Dock(FILL)
    label:DockMargin(0, 0, 8, 0)
    label:SetText(entry.label)
    label:SetDark(true)
end

local function AddCategory(parent, category)
    local panel = parent:Add(category.name)
    local contents = vgui.Create("DPanel", panel)

    contents:SetPaintBackgroundEnabled(false)
    contents:DockPadding(8, 4, 8, 0)

    for _, entry in ipairs(category.entries) do
        AddBindingRow(contents, entry)
    end

    panel:SetContents(contents)
end

hook.Add("PopulateVehicles", "SEF_KeybindingsMenu", function(pnlContent, tree)
    local node = tree:AddNode("SEF Keybindings", "icon16/keyboard.png")

    node.DoPopulate = function(self)
        if IsValid(self.PropPanel) then return end

        self.PropPanel = vgui.Create("DCategoryList", pnlContent)
        self.PropPanel:SetVisible(false)
        self.PropPanel:GetCanvas():DockPadding(12, 8, 12, 0)

        for _, category in ipairs(Keybindings.GetCategories()) do
            AddCategory(self.PropPanel, category)
        end
    end

    node.DoClick = function(self)
        self:DoPopulate()
        pnlContent:SwitchPanel(self.PropPanel)
    end
end)
