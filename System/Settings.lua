local Hilex = Hilex
local AceGUI = LibStub("AceGUI-3.0")

local defaults = {

  profile = {
    Dungeon = {
      LastDungeon = "",
      IronDock_Step = 1
    }
  },

  char = {
    SelectedProfile = select(2, UnitClass("player")):gsub("%s+", "")
  }

}

function Hilex.InitSettings()
  Hilex.Settings = LibStub("AceDB-3.0"):New("HilexSettings", defaults, "Default")
  Hilex.Settings:SetProfile(Hilex.Settings.char.SelectedProfile)
  Hilex.Settings.RegisterCallback(Hilex, "OnProfileChanged", "HandleProfileChanges")
end

function Hilex:HandleProfileChanges(self, db, profile)
  Hilex.Settings.char.SelectedProfile = profile
end