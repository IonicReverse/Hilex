local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local Hilex = Hilex

local options = {
  name = "Hilex",
  handler = Hilex,
  type = "group",
  childGroups = "tab",
  args = {
    GeneralTab = {
      name = "General",
      type = "group",
      order = 1,
      args = {}
    }
  },
}

function Hilex.UI.Init()
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Hilex", options)
  LibStub("AceConfigDialog-3.0"):SetDefaultSize("Hilex", 350, 550)
end