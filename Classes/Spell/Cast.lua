local Hilex = Hilex
local FV_Spell = Hilex.Classes.Spell
local FV_LocalPlayer = Hilex.Classes.LocalPlayer

function FV_Spell:FacingCast(Unit, Rank)
  if not Unit.Facing and not lb.UnitTarget(Hilex.Player.GUID) == Unit.GUID then
    -- TODO
  end
end

function FV_Spell:Cast(Unit, Rank, Target)

  if not Unit then
    if self.IsHarmful and Hilex.Player.Target then
      Unit = Hilex.Player.Target
    elseif self.IsHelpful then
      Unit = Hilex.Player
    else
      return false
    end
  end

  if not Rank then
    lb.Unlock(CastSpellByName, self.SpellName)
    return true
  else
    lb.Unlock(CastSpellByID, self.Ranks[Rank])
    return true
  end

  if Target and not Rank then
    lb.Unlock(CastSpellByName, self.SpellName, Target)
    return true
  else
    if Target and Rank then
      lb.Unlock(CastSpellByID, self.Ranks[Rank], Target)
      return true
    end
  end
  
  return false
end

function FV_Spell:CastGround(X,Y,Z, Rank)
  
  if Hilex.Player.Moving then
    lb.Unlock(MoveForwardStart)
    lb.Unlock(MoveForwardStop)
    C_Timer.After(0.5, function()
      if not Rank then 
        lb.Unlock(CastSpellByName, self.SpellName)
        lb.ClickPosition(X,Y,Z)
      else
        lb.Unlock(CastSpellByID, self.Ranks[Rank])
        lb.ClickPosition(X,Y,Z)
      end
    end)
    return true
  end

  if not Rank then
    lb.Unlock(CastSpellByName, self.SpellName)
    lb.ClickPosition(X,Y,Z)
    return true
  else
    lb.Unlock(CastSpellByID, self.Ranks[Rank])
    lb.ClickPosition(X,Y,Z)
    return true
  end
  
  return false
end