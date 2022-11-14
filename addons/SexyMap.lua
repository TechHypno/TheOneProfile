local _, TOP = ...
TOP.RegisterAddonHandler("SexyMap",
    -- SexyMap has a built-in global profile functionality,
    -- enable it, copy the character profile into it and return true to request a ReloadUI.
    function()
        local function deepCopy(t)
            local r = {}
            for k, v in pairs(t) do
                r[k] = (type(v) == "table") and deepCopy(v) or v
            end
            return r
        end
        local char = (UnitName("player").."-"..GetRealmName())
        if (type(SexyMap2DB) == 'table') and (SexyMap2DB[char] ~= "global") then
            if not SexyMap2DB.global then
                SexyMap2DB.global = deepCopy(SexyMap2DB[char])
            end
            SexyMap2DB[char] = "global"
            return true
        end
    end
)