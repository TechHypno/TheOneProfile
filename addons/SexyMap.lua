local _, TOP = ...
TOP.RegisterAddonHandler("SexyMap",
    -- SexyMap has a built-in global profile functionality,
    -- enable it and return true to request a ReloadUI.
    function()
        local char = (UnitName("player").."-"..GetRealmName())
        if (type(SexyMap2DB) == 'table') and (SexyMap2DB[char] ~= "global") then
            if not SexyMap2DB.global then
                SexyMap2DB.global = {}
            end
            SexyMap2DB[char] = "global"
            return true
        end
    end
)