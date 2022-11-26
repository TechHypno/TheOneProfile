local _, TOP = ...
local function SetDBProfile(db, forceProfileName)
    local current = db:GetCurrentProfile()
    if current and (current ~= forceProfileName) then
        local copy = (db.profiles[forceProfileName] == nil)
        db:SetProfile(forceProfileName)
        if copy then
            db:CopyProfile(current)
        end
    end
end
TOP.RegisterAddonHandler("ADDON_LOADED", "AceDB3",
    -- If %TOP.profileName% isnt the current profile of the target addon,
    -- if not an ignored addon, set it to a new profile %TOP.profileName% and copy settings from 
    -- the last used profile.
    -- Return true to request a ReloadUI.
    function()
        local AceDB = LibStub and LibStub("AceDB-3.0")
        if AceDB then
            local g = {}
            for k,v in pairs(_G) do
                if type(v) == 'table' then
                    g[k] = v
                end
            end
            for db in pairs(AceDB.db_registry) do
                local dbname
                for k,v in pairs(g) do
                    if (v == db.sv) then
                        dbname = k
                        break
                    end
                end
                if (not dbname or not TOP.IsIgnoredAddon(dbname)) and not db.parent then
                    SetDBProfile(db, TOP.profileName)
                end
            end
            local AceDB_New = AceDB.New
            AceDB.New = function(self, tbl, defaults, defaultProfile)
                -- print("AceDB_New", tostring(tbl))
                local ret
                ret = AceDB_New(self, tbl, defaults, defaultProfile)
                if type(tbl) == 'string' then
                    if not TOP.IsIgnoredAddon(tbl) and not ret.parent then
                        SetDBProfile(ret, TOP.profileName)
                    end
                end
                return ret
            end
        end
    end
)