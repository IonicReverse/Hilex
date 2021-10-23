local Hilex = Hilex
local FV_LocalPlayer = Hilex.Classes.LocalPlayer

function FV_LocalPlayer:New(GUID)
  self.GUID = GUID
  self.Pointer = lb.ObjectPointer(GUID)
  self.Name = lb.UnitTagHandler(UnitName, self.GUID)
  self.Class = (select(3, lb.UnitTagHandler(UnitClass, self.GUID)))
  self.ClassName = (select(2, lb.UnitTagHandler(UnitClass, self.GUID)))
  self.CombatReach = lb.UnitCombatReach(self.GUID)
  self.PosX, self.PosY, self.PosZ = lb.ObjectPosition(self.Pointer)
  self.Distance = 0
  self.Combat = lb.UnitTagHandler(UnitAffectingCombat, self.GUID) or false
  self.CombatLeft = false
  self.Level = lb.UnitTagHandler(UnitLevel, self.GUID)
  self.Looting = false
  self.Mounted = IsMounted()
  self.Swimming = IsSwimming()
  self.Submerged = IsSubmerged()
  self.Faction = (select(1, lb.UnitTagHandler(UnitFactionGroup, self.GUID)))
  self.Race = (select(1, UnitRace("player")))
  self.Professions = {}
end

function FV_LocalPlayer:Update()
  self.PosX, self.PosY, self.PosZ = lb.ObjectPosition(self.GUID)
  self.Level = lb.UnitTagHandler(UnitLevel, self.GUID)
  self.Health = lb.UnitTagHandler(UnitHealth, self.GUID)
  self.HealthMax = lb.UnitTagHandler(UnitHealthMax, self.GUID)
  self.HP = self.Health / self.HealthMax * 100
  self.Power = lb.UnitTagHandler(UnitPower, self.GUID)
  self.PowerMana = lb.UnitTagHandler(UnitPower, self.GUID, 0)
  self.PowerManaMax = lb.UnitTagHandler(UnitPowerMax, self.GUID, 0)
  self.PowerMax = lb.UnitTagHandler(UnitPowerMax, self.GUID, 0)
  self.PowerPct = self.Power / self.PowerMax * 100
  self.PowerPctMana = self.PowerMana / self.PowerManaMax * 100
  if self.Class == 4 or self.Class == 11 then
    self.ComboPoints = GetComboPoints("player", "target")
    self.ComboMax = 5
  end
  self.Casting = lb.UnitTagHandler(UnitCastingInfo, self.GUID)
  self.Channeling = lb.UnitTagHandler(ChannelInfo, self.GUID) or false
  self.Combat = lb.UnitTagHandler(UnitAffectingCombat, self.GUID)
  self.Moving = self:HasMovementFlag()
  self.Mounted = IsMounted()
  self.Swimming = IsSwimming()
  self.Submerged = IsSubmerged()
  self.Alive = lb.UnitTagHandler(UnitIsDeadOrGhost, self.GUID) == false
  self.Dead = self.HP == 0 or lb.UnitTagHandler(UnitIsDeadOrGhost, self.GUID)
  self.Ghost = lb.UnitTagHandler(UnitIsGhost, self.GUID)
  self.InInstance = (select(1, IsInInstance()))
end

function FV_LocalPlayer:GCDRemain()
  local GCDSpell = 61304
  local start, cd = GetSpellCooldown(GCDSpell)
  if start == 0 then return 0 end
  return math.max(0, (start + cd) - Hilex.Time)
end

function FV_LocalPlayer:IsStanding()
  if lb.UnitMovementFlags(self.GUID) == 0 then 
    return true
  end
  return false
end

function FV_LocalPlayer:HasMovementFlag()
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

function FV_LocalPlayer:StopCasting()
  if self.Casting then
    lb.CancelPendingSpells()
    return true
  end
  return false
end

function FV_LocalPlayer:StopMoving()
  if self.Moving then
    Hilex.Navigator.Stop()
    lb.Unlock(MoveForwardStart)
    lb.Unlock(MoveForwardStop)
    return true
  end
  return false
end

function FV_LocalPlayer:CheckLootableUnitDistance(Yards)
  for _, v in ipairs(Hilex.UnitLootable) do
    if v.Distance <= Yards then
      return true
    end
  end
  return false
end

function FV_LocalPlayer:CheckFoodCount()
  local foodName = Hilex.Settings.profile.Grinding.FoodName
  local foodCount = GetItemCount(foodName)
  if foodCount == 0 then
    return true
  end
  return false
end

function FV_LocalPlayer:CheckDrinkCount()
  local drinkName = Hilex.Settings.profile.Grinding.DrinkName
  local drinkCount = GetItemCount(drinkName)
  if drinkCount == 0 then
    return true
  end
  return false
end

function FV_LocalPlayer:GetFreeBagSlots()
  local Slots = 0
  for i = 0, 4, 1 do
    Slots = Slots + (select(1, GetContainerNumFreeSlots(i)))
  end
  return Slots
end

itemSlots = { "HeadSlot", "ShoulderSlot", "ChestSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "MainHandSlot", "SecondaryHandSlot" }
for index, slotName in ipairs(itemSlots) do
	itemSlots[slotName] = { slot = GetInventorySlotInfo(slotName) }
	itemSlots[index] = nil
end

function FV_LocalPlayer:Durability()
	local cur, max
	local count = 0
	local percentSum = 0
	local percentItem = 0
	for slotName, tbl in next, itemSlots do
		tbl.min, tbl.max = GetInventoryItemDurability(tbl.slot)
		if (tbl.min and tbl.max) then
			count = count + 1
			percentItem = tbl.min / tbl.max * 100
			percentSum = percentSum + percentItem
			percentItem = 0
		end
	end
	return (percentSum / count)
end
