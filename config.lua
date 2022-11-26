local addonName, TOP = ...
local init
function TOP.InitOptions()
    if init then return end
    local category = Settings.RegisterVerticalLayoutCategory("TheOneProfile - Ignore List")
    local sorted = {}
    for dbname in pairs(TheOneProfileConfig.addonBlacklist) do
        tinsert(sorted, dbname)
    end
    table.sort(sorted)
    for _, dbname in pairs(sorted) do
        local name = dbname --:gsub("AceDB",""):gsub("DB",""):gsub("Database","")
        local setting = Settings.RegisterAddOnSetting(category, name, dbname, type(false), TheOneProfileConfig.addonBlacklist[dbname])
        Settings.SetOnValueChangedCallback(dbname, function(event) TheOneProfileConfig.addonBlacklist[dbname] = setting:GetValue() end)
        Settings.CreateCheckBox(category, setting, "Ignore this AddOn")
    end
    Settings.RegisterAddOnCategory(category)
    init = true
end