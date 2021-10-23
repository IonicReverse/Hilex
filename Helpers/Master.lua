local Hilex = Hilex
Hilex.Helpers.Master = {}
local Master = Hilex.Helpers.Master
local BlackListPlayer = { "Fulart", "Minekki" }

local function CheckForChest()
  local GameObject = Hilex.GameObjects
  for _, i in pairs(GameObject) do
    if i.Chest then
      return i.GUID
    end
  end
  return nil
end

local function CheckPlayerName(guid)
  local TableList = BlackListPlayer
  for _, i in pairs(TableList) do
    if lb.UnitTagHandler(UnitName, guid) ~= i and lb.UnitTagHandler(UnitIsPlayer,guid) then
      return true
    end
  end
  return nil
end

local function CheckPlayerAround()
  local Unit = Hilex.Units
  for _, i in pairs(Unit) do
    if CheckPlayerName(i.GUID)
      and lb.GetDistance3D(UnitGUID('player'), i.GUID) < 80
    then
      return UnitName(i.GUID)
    end
  end
  return nil
end

local function Core()
  
  local Chest = CheckForChest()
  local ObjLockType = lb.ObjectLocked(Chest)

  if Chest then
    if ObjLockType == false then
      if not C_QuestSession.HasJoined() then
        C_QuestSession.RequestSessionStart()
        Hilex.Pause = Hilex.Time + 1
      end
    end

    if ObjLockType == true then
      if C_QuestSession.HasJoined() then
        C_QuestSession.RequestSessionStop()
        Hilex.Pause = Hilex.Time + 1
      end
    end
  end

end

function Master.Run()
  if Hilex.Time > Hilex.Pause then
    Core()
  end
end