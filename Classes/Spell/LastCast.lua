local Hilex = Hilex
local LastSpell = 0
local FV_Spell = Hilex.Classes.Spell

function FV_Spell:LastCast(Index)
  Index = Index or 1
  if Hilex.Player.LastCast and Hilex.Player.LastCast[Index] then
    return Hilex.Player.LastCast[Index].SpellName == self.SpellName
  end
  return false
end

function FV_Spell:TimeSinceLastCast()
  if self.LastCastTime > 0 then
    return Hilex.Time - self.LastCastTime
  end
  return 999
end

function FVAddSpell(SpellID)
  
  if not Hilex.Player.LastCast then
    Hilex.Player.LastCast = {}
  end

  local SpellName = GetSpellInfo(SpellID)

  if Hilex.Player.Spells then
    for k, v in pairs(Hilex.Player.Spells) do
      if v.SpellName == SpellName then
        local Temp = {}
        Temp.SpellName = v.SpellName
        Temp.CastTime = Hilex.Time
        tinsert(Hilex.Player.LastCast, 1, Temp)
        if #Hilex.Player.LastCast == 10 then
          Hilex.Player.LastCast[10] = nil
        end
        return true
      end
    end
  end

  return false
end


