local _, TOP = ...
local function DeepCopy(t)
    local r = {}
    for k, v in pairs(t) do
        r[k] = (type(v) == "table") and DeepCopy(v) or v
    end
    return r
end
TOP.RegisterAddonHandler("PLAYER_ENTERING_WORLD", "EditMode",
    function()
        -- check if user disabled TheOneProfile for EditMode
        if TOP.IsIgnoredAddon("EditMode") then return end
        -- get user created layouts
        local oldLayouts = C_EditMode.GetLayouts()
        -- build a list of all layouts, presets first
        local newLayouts = {layouts = EditModePresetLayoutManager:GetCopyOfPresetLayouts()}
        newLayouts.activeLayout = #newLayouts.layouts + 1
        for i, element in ipairs(oldLayouts.layouts) do
        	tinsert(newLayouts.layouts, element)
        end
        local activeLayout = newLayouts.layouts[oldLayouts.activeLayout]
        if activeLayout and (activeLayout.layoutName ~= TOP.profileName) then
            -- check if target layout already exists and select it if it does
            for index, layout in pairs(newLayouts.layouts) do
                if (layout.layoutName == TOP.profileName) then
                    C_EditMode.SetActiveLayout(index)
                    return
                end
            end
            -- otherwise if current layout isnt a preset, make a copy with our name, add it, select it.
            if (activeLayout.layoutType ~= Enum.EditModeLayoutType.Preset) then
                local newLayout = DeepCopy(activeLayout)
                newLayout.layoutType = Enum.EditModeLayoutType.Account
                newLayout.layoutName = TOP.profileName
                tinsert(newLayouts.layouts, newLayouts.activeLayout, newLayout)
                C_EditMode.SaveLayouts(newLayouts)
                C_EditMode.OnLayoutAdded(newLayouts.activeLayout)
            end
        end
    end
)