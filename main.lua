local addonName, TOP = ...
TOP.profileName = "!TheOneProfile!"

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

local function RequestReload(reloadList)
    local dialog = StaticPopupDialogs["THEONEPROFILE_POPUPDIALOG"]
    dialog.text = "TheOneProfile needs to Reload the UI to finalize setting up the following addons: "..table.concat(reloadList, ", ")
    dialog.OnAccept = function(self) ReloadUI() end
    StaticPopup_Show("THEONEPROFILE_POPUPDIALOG")
end
    
local allowedEvents = {
    ADDON_LOADED = true,
    PLAYER_ENTERING_WORLD = true
}
local addonHandlers = {}
function TOP.RegisterAddonHandler(event, name, func)
    if event and name and allowedEvents[event] and (type(func) == 'function') then
        addonHandlers[event] = addonHandlers[event] or {}
        addonHandlers[event][name] = func
    end
end
local reload, reloadList = false, {}
function TOP.ExecuteHandlers(event, ...)
    for name, handler in pairs(addonHandlers[event]) do
        if handler(...) then
            reload = true
            tinsert(reloadList, name)
        end
    end
    return {
        ThenAskForReloadIfNeeded = function()
            if reload then
                RequestReload(reloadList)
            end
        end
    }
end
function TOP.IsIgnoredAddon(dbname)
    TheOneProfileConfig.addonBlacklist[dbname] = TheOneProfileConfig.addonBlacklist[dbname] or false
    return TheOneProfileConfig.addonBlacklist[dbname] == true
end
    
