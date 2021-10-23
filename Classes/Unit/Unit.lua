local Hilex = Hilex
local FV_Unit = Hilex.Classes.Unit

function FV_Unit:New(GUID)
  if not UnitIsUnit then UnitIsUnit = _G.UnitIsUnit end
  self.GUID = GUID
  self.Pointer = lb.ObjectPointer(GUID)
  self.Name = not lb.UnitTagHandler(UnitIsUnit, self.GUID, UnitGUID('player')) and lb.UnitTagHandler(UnitName, self.GUID) or "LocalPlayer"
  self.Player = lb.UnitTagHandler(UnitIsPlayer, self.GUID)
  if self.Player then self.Class = (select(2, lb.UnitTagHandler(UnitClass, self.GUID))) end
  self.Friend = lb.UnitTagHandler(UnitIsFriend, Hilex.Player.GUID, self.GUID)
  self.CombatReach = lb.UnitCombatReach(self.GUID)
  self.PosX, self.PosY, self.PosZ = lb.ObjectPosition(self.GUID)
  self.ObjectID = lb.ObjectId(self.GUID)
  self.Level = lb.UnitTagHandler(UnitLevel, self.GUID)
  self.LosCache = {}
  self.Classification = lb.UnitTagHandler(UnitClassification, self.GUID)
  self.Type = lb.UnitTagHandler(UnitCreatureType, self.GUID)
end

function FV_Unit:Update()
  self.NextUpdate = Hilex.Time + 0.05
  self:UpdatePosition()
  self.Distance = self:GetDistance()
  self.HealthMax = lb.UnitTagHandler(UnitHealthMax, self.GUID)
  self.Health = lb.UnitTagHandler(UnitHealth, self.GUID)
  self.HP = self.Health / self.HealthMax * 100
  self.Dead = self.HP == 0 or lb.UnitTagHandler(UnitIsDeadOrGhost, self.GUID)
  self.Attackable = lb.UnitTagHandler(UnitCanAttack, Hilex.Player.GUID, self.GUID) or false
  self.ValidEnemy = self.Attackable and self:IsEnemy() or false
  self.Target = self:HasTargetUnit('player')
  self.Moving = self:HasMovementFlag()
  self.Facing = self:IsFacing("player", self.GUID)
  self.Castng = UnitCastingInfo(self.GUID)
  self.Los = false
  if self.Distance < 50 and not self.Dead then
    self.Los = self:LineOfSight()
  end
  if self.Name == "Unknown" then
    self.Name = lb.UnitTagHandler(UnitName, self.GUID)
  end
end

function FV_Unit:UpdatePosition()
  self.PosX, self.PosY, self.PosZ = lb.ObjectPosition(self.GUID)
end

function FV_Unit:HasTargetUnit(Tag)
  if lb.UnitTarget(Tag) == "0000000000000000" then
    return nil
  end
  return lb.UnitTarget(Tag)
end

function FV_Unit:IsEnemy()
  return self.Los and self.Attackable and self:HasThreat() and (not self.Friend or lb.UnitTarget(self.GUID) == Hilex.Player.GUID)
end

function FV_Unit:IsFacing (Unit, Other)
  local SelfX, SelfY, SelfZ = lb.ObjectPosition(Unit)
  local SelfFacing = lb.ObjectFacing(Unit)
  local OtherX, OtherY, OtherZ = lb.ObjectPosition(Other)
  local Angle = SelfX and SelfY and OtherX and OtherY and SelfFacing and ((SelfX - OtherX) * math.cos(-SelfFacing)) - ((SelfY - OtherY) * math.sin(-SelfFacing)) or 0
  return Angle < 0
end

function FV_Unit:HasThreat()
  if lb.UnitTagHandler(UnitAffectingCombat, self.GUID) then
    return true
  end
  return false
end

function FV_Unit:HasMovementFlag()
  if lb.UnitHasMovementFlag(self.GUID, __LB__.EMovementFlags.Forward)
    or lb.UnitHasMovementFlag(self.GUID, __LB__.EMovementFlags.Backward)
    or lb.UnitHasMovementFlag(self.GUID, __LB__.EMovementFlags.StrafeLeft)
    or lb.UnitHasMovementFlag(self.GUID, __LB__.EMovementFlags.StrafeRight)
    or lb.UnitHasMovementFlag(self.GUID, __LB__.EMovementFlags.Falling)
    or lb.UnitHasMovementFlag(self.GUID, __LB__.EMovementFlags.Ascending)
    or lb.UnitHasMovementFlag(self.GUID, __LB__.EMovementFlags.Descending) then 
    return true
  end
  return false
end

function FV_Unit:LineOfSight(OtherUnit)

  if Hilex.Enums.Los[self.ObjectID] then
    return true
  end

  OtherUnit = OtherUnit or Hilex.Player

  if self.LosCache.Result ~= nil 
    and self.PosX == self.LosCache.PosX
    and self.PosY == self.LosCache.PosY
    and self.PosZ == self.LosCache.PosZ
    and OtherUnit.PosX == self.LosCache.TPosX
    and OtherUnit.PosY == self.LosCache.TPosY
    and OtherUnit.PosZ == self.LosCache.TPosZ
  then
    return self.LosCache.Result
  end
  
  if self.PosX and self.PosY and self.PosZ then
    self.LosCache.Result = lb.Raycast(self.PosX, self.PosY, self.PosZ + 2, OtherUnit.PosX, OtherUnit.PosY, OtherUnit.PosZ + 2, lb.ERaycastFlags.LineOfSight) == nil
    self.LosCache.PosX, self.LosCache.PosY, self.LosCache.PosZ = self.PosX, self.PosY, self.PosZ
    self.LosCache.TPosX, self.LosCache.TPosY, self.LosCache.TPosZ = OtherUnit.PosX, OtherUnit.PosY, OtherUnit.PosZ
  end

  return self.LosCache.Result
end