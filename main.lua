local addonName, TOP = ...
_G[addonName] = TOP

--Confirmation Dialog
StaticPopupDialogs["THEONEPROFILE_POPUPDIALOG"] = {
    text = "POPUPDIALOG_TITLE",
    button1 = "Reload",
    button2 = "Cancel",
    OnShow = function() end,
    OnAccept = function() end,
    EditBoxOnEnterPressed = function() end,
    hasEditBox = false,
    timeout = 0,
    exclusive = true,
    hideOnEscape = true
}

function TOP.RequestReload(reloadList)
    local dialog = StaticPopupDialogs["THEONEPROFILE_POPUPDIALOG"]
    dialog.text = "TheOneProfile needs to Reload the UI to finalize setting up the following addons: "..table.concat(reloadList, ", ")
    dialog.OnAccept = function(self) ReloadUI() end
    StaticPopup_Show("THEONEPROFILE_POPUPDIALOG")
end
    

local addonHandlers = {}
function TOP.RegisterAddonHandler(name, func)
    addonHandlers[name] = (type(func) == 'function') and func
end

function TOP.SetProfiles()
    local reload = false
    local reloadList = {}
    for name, handler in pairs(addonHandlers) do
        if handler() then
            reload = true
            tinsert(reloadList, name)
        end
    end
    if reload then
        TOP.RequestReload(reloadList)
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