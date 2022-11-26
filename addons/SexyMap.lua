local _, TOP = ...
local function DeepCopy(t)
    local r = {}
    for k, v in pairs(t) do
        r[k] = (type(v) == "table") and DeepCopy(v) or v
    end
    return r
end
TOP.RegisterAddonHandler("PLAYER_ENTERING_WORLD", "SexyMap",
    -- SexyMap has a built-in global profile functionality,
    -- enable it, copy the character profile into it and return true to request a ReloadUI.
    function()
        -- check if user disabled TheOneProfile for SexyMap
        if TOP.IsIgnoredAddon("SexyMap") then return end
        local char = (UnitName("player").."-"..GetRealmName())
        if (type(SexyMap2DB) == 'table') and (SexyMap2DB[char] ~= "global") then
            if not SexyMap2DB.global then
                SexyMap2DB.global = DeepCopy(SexyMap2DB[char])
            end
            SexyMap2DB[char] = "global"
            return true
        end
    end
)