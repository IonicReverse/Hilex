local Hilex = Hilex
Hilex.Enemies, Hilex.Attackable, Hilex.Units, Hilex.GrindMobs, Hilex.Friends, Hilex.GameObjects, Hilex.UnitLootable, Hilex.UnitSkinable = {}, {}, {}, {}, {}, {}, {}, {}
local Enemies, Attackable, Units, GrindMobs, Friends, GameObjects, UnitLootable, UnitSkinable = Hilex.Enemies, Hilex.Attackable, Hilex.Units, Hilex.GrindMobs, Hilex.Friends, Hilex.GameObjects, Hilex.UnitLootable, Hilex.UnitSkinable
local Unit, LocalPlayer, GameObject = Hilex.Classes.Unit, Hilex.Classes.LocalPlayer, Hilex.Classes.GameObject

local function UpdateLocalPlayer()
  Hilex.Player:Update()
end

local function UpdateUnits()

  table.wipe(GrindMobs)
  table.wipe(Attackable)
  table.wipe(Enemies)
  table.wipe(Friends)
  table.wipe(UnitLootable)

  Hilex.Player.Target = nil

  for _, Unit in pairs(Units) do  
    
    if Units[Unit.GUID] ~= nil then
      if not Unit.Pointer then Units[Unit.GUID] = nil end
      if not lb.UnitTagHandler(UnitExists, Unit.GUID) then Units[Unit.GUID] = nil end
    end

    if not Unit.NextUpdate or Unit.NextUpdate < Hilex.Time then
      Unit:Update()
    end

    if not Hilex.Player.Target and lb.UnitTarget(Hilex.Player.GUID) == Unit.GUID then
      Hilex.Player.Target = Unit
    end

    if Unit.Attackable then
      table.insert(Attackable, Unit)
    end

    if Unit.ValidEnemy then
      table.insert(Enemies, Unit)
    end

    if Unit.Attackable and not Unit.Player and not Unit.Dead and not lb.UnitTagHandler(UnitIsTapDenied, Unit.GUID) then
      table.insert(GrindMobs, Unit)
    end

    if lb.UnitIsLootable(Unit.GUID) and lb.UnitTagHandler(UnitIsVisible, Unit.GUID) then
      table.insert(UnitLootable, Unit)
    end

  end

end

local function UpdateGameObjects()
  for _, Object in pairs(GameObjects) do
    if GameObjects[Object.GUID] ~= nil then
      if not Object.ObjPointer then GameObjects[Object.GUID] = nil end
    end
    if not Object.NextUpdate or Object.NextUpdate < Hilex.Time then
      Object:Update()
    end
  end
end

function Hilex.UpdateOM()
  for _, guid in ipairs(lb.GetObjects()) do
    if (lb.ObjectType(guid) == 5 or lb.ObjectType(guid) == 6) and not Units[guid] then
      Units[guid] = Unit(guid)
    elseif lb.GameObjectType(guid) ~= -1 and not GameObjects[guid] then
      GameObjects[guid] = GameObject(guid)
    end
  end 
  UpdateLocalPlayer()
  UpdateUnits()
  UpdateGameObjects()
end

