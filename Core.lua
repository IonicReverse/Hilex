Hilex = LibStub("AceAddon-3.0"):NewAddon("Hilex", "AceConsole-3.0")

local Hilex = Hilex
local IsAllowed = 1
local DelayCallHttp = 0
local Intialized = false

local Dungeon = nil
local Navigation = nil
local ObjectManager = nil

local DungeonDownloadedFile = 0
local ObjectDownloadedFile = 0

RecordIndex = 1

Hilex.Tables = {}
Hilex.Enums = {}
Hilex.Functions = {}
Hilex.UI = {}
Hilex.Settings = {}
Hilex.Helpers = {}
Hilex.Helpers.Dungeon = {}
Hilex.Helpers.Core = {}
Hilex.Player = {}
Hilex.Pulse = 0

Hilex.Dungeon = false
Hilex.Pause = 0

local function Init()
  Hilex.InitSettings()
  Hilex.UI.Init()
  Hilex.Player = Hilex.Classes.LocalPlayer(UnitGUID('player'))
  Hilex.PulseDelay = GetTime() + 3
  Intialized = true
end

local frame = CreateFrame("Frame", "Hilex", UIParent)
frame:SetScript(
  "OnUpdate",
  function(self, elapsed)

    if lb then

      -- Pulse
      Hilex.Time = GetTime()
      Hilex.Pulse = Hilex.Pulse + 1
      
      if IsAllowed == 1 then
        
        if Intialized == false then Init() return end

        if Hilex.IsRunning and GetTime() > Hilex.PulseDelay then

          lb.UpdateAFK()

          Hilex.UpdateOM()

          if Hilex.Role == "Master" then
            Hilex.Helpers.Master.Run()
          end

          if Hilex.Role == "Slave" then
            Hilex.Helpers.Slave.Run()
          end

        end
      end

    end
  end
)


