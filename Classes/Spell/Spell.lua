local Hilex = Hilex
local FV_Spell = Hilex.Classes.Spell

function FV_Spell:New(SpellID, CastType)
  self.Ranks = SpellID
  self.SpellID = self.Ranks[1]
  self.SpellName = GetSpellInfo(self.SpellID)
  self.BaseCD = GetSpellBaseCooldown(self.SpellID) / 1000
  self.BaseGCD = select(2, GetSpellBaseCooldown(self.SpellID)) / 1000
  self.MinRange = select(5, GetSpellInfo(self.SpellID)) or 0
  self.MaxRange = select(6, GetSpellInfo(self.SpellID)) or 0
  self.CastType = CastType or "Normal"
  self.IsHarmful = IsHarmfulSpell(self.SpellName) or false
  self.IsHelpful = IsHelpfulSpell(self.SpellName) or false
  self.LastCastTime = 0
  self.LastBotTarget = "player"
end

function FV_Spell:Cost(Rank)
  local costTable
  if Rank then
    costTable = GetSpellPowerCost(self.Ranks[Rank])
  else
    costTable = GetSpellPowerCost(self.SpellName)
  end
  if costTable then
    for _, costinfo in pairs(costTable) do
      if costinfo.cost > 0 then
        return costinfo.cost
      end
    end
  end
  return 0
end

function FV_Spell:CD(Rank)
  local time, value

  if not Rank then
    time, value = GetSpellCooldown(self.SpellName)
  else
    time, value = GetSpellCooldown(self.Ranks[Rank])
  end

  if not time or time == 0 then
    return 0
  end

  local cd = (time + value - GetTime() - (select(4, GetNetStats()) / 1000))

  if cd > 0 then
    return cd
  else
    return 0
  end
end

function FV_Spell:CastTime(Rank)
  if Rank then
    return select(4, GetSpellInfo(self.Ranks[Rank])) / 1000
  end
  return select(4, GetSpellInfo(self.SpellName)) / 1000
end

function FV_Spell:Usable(Rank)

  if not Rank and IsUsableSpell(self.SpellName) then
    if self:CD(Rank) == 0 then
      return true
    end
  end

  if Rank and IsUsableSpell(self.Ranks[Rank]) then
    if self:CD(Rank) == 0 then
      return true
    end
  end

  return false
end

function FV_Spell:Known(Rank)
  if Rank then
    return IsSpellKnown(self.Ranks[Rank])
  end
  return GetSpellInfo(self.SpellName)
end

function FV_Spell:IsReady(Rank)
  if self:Known(Rank) and self:Usable(Rank) then
    return true
  end
  return false
end