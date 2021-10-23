local Hilex = Hilex
local FV_GameObject = Hilex.Classes.GameObject

function FV_GameObject:New(GUID)
  self.GUID = GUID
  self.Name = lb.ObjectName(GUID)
  self.ObjectID = lb.ObjectId(GUID)
  self.ObjPointer = lb.ObjectPointer(self.GUID)
  self.PosX, self.PosY, self.PosZ = lb.ObjectPosition(self.GUID)
end

function FV_GameObject:Update()
  self.NextUpdate = Hilex.Time + 0.1
  self.PosX, self.PosY, self.PosZ = lb.ObjectPosition(self.GUID)
  self.Distance = self:GetDistance()
  if not self.Name or self.Name == "" then
    self.Name = ObjectName(self.GUID)
  end
  self.Herb = self:IsHerb()
  self.Ore = self:IsOre()
  self.Chest = self:IsChest()
  self.ObjPointer = lb.ObjectPointer(self.GUID)
  self.ObjLockType = lb.ObjectLocked(self.GUID)
  self.ObjExists = lb.ObjectExists(self.GUID)
  self.ObjDynamicFlag = lb.ObjectDynamicFlags(self.GUID)
end 

function FV_GameObject:GetDistance(OtherUnit)
  OtherUnit = OtherUnit or Hilex.Player
  local Dist = lb.GetDistance3D(self.GUID, OtherUnit.GUID)
  if Dist == nil or Dist < 0 then return 0 end
  return Dist
end

function FV_GameObject:IsHerb()
  if Hilex.Enums.Herbs[self.ObjectID]
    and Hilex.Player.Professions.Herbalism 
    and Hilex.Player.Professions.Herbalism >= Hilex.Enums.Herbs[self.ObjectID].SkillReq
  then
    return true
  end
  return false
end

function FV_GameObject:IsOre()
  if Hilex.Enums.Ore[self.ObjectID]
    and Hilex.Player.Professions.Mining 
    and Hilex.Player.Professions.Mining >= Hilex.Enums.Ore[self.ObjectID].SkillReq
  then
    return true
  end
  return false
end

function FV_GameObject:IsChest()
  if Hilex.Enums.Chest[self.ObjectID] then
    return true
  end
  return false
end
