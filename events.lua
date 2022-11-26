local addonName, TOP = ...
local f = CreateFrame('frame')
f:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f.ADDON_LOADED = function(self, name)
    if (name == addonName) then
        TheOneProfileConfig = TheOneProfileConfig or {addonBlacklist = {}}
        TOP.ExecuteHandlers("ADDON_LOADED")
        self:UnregisterEvent("ADDON_LOADED")
    end
end
f.PLAYER_ENTERING_WORLD = function(self)
    TOP.ExecuteHandlers("PLAYER_ENTERING_WORLD").ThenAskForReloadIfNeeded()
    TOP.InitOptions()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end