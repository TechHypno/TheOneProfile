local addonName, TOP = ...
_G[addonName] = TOP

local addonHandlers = {}
function TOP.RegisterAddonHandler(name, func)
    addonHandlers[name] = (type(func) == 'function') and func
end

function TOP.SetProfiles()
    local reload = false
    for name, handler in pairs(addonHandlers) do
        reload = reload or handler()
    end
end

function TOP.GetProfileName()
    return "!TheOneProfile!"
end
local f = CreateFrame('frame', "TheOneProfileManagerEventFrame", UIParent)
f:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f.PLAYER_ENTERING_WORLD = function(self)
    TOP.SetProfiles()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end