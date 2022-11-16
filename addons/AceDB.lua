local _, TOP = ...
TOP.RegisterAddonHandler("AceDB",
    -- If %profileName% isnt the current profile of the target addon,
    -- set it to a new profile %TOP:GetProfileName()% and copy settings from 
    -- the last used profile.
    -- Return true to request a ReloadUI.
    function(profileName)
        local AceDB = LibStub and LibStub("AceDB-3.0")
        if AceDB then
            for db in pairs(AceDB.db_registry) do
                if not db.parent then
                    local current = db:GetCurrentProfile()
                    if current and (current ~= profileName) then
                        local copy = (db.profiles[profileName] == nil)
                        db:SetProfile(profileName)
                        if copy then
                            db:CopyProfile(current)
                        end
                    end
                end
            end
        end
    end
)