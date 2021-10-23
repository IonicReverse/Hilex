local Hilex = Hilex
local Buff = Hilex.Classes.Buff
local Debuff = Hilex.Classes.Debuff

function Debuff:Query(Unit, OnlyPlayer)
  OnlyPlayer = OnlyPlayer or false
  if not Unit then
    return nil
  end
  local _buff
  local i = 0
  while i <= 40 do
    i = i + 1
    if OnlyPlayer then
      _buff = _G.UnitDebuff('player', i)
    else
      _buff = lb.UnitTagHandler(_G.UnitDebuff, Unit.GUID, i)
    end
    if _buff == self.SpellName then return true end
  end
  return nil
end

function Buff:Query(Unit, OnlyPlayer)
  OnlyPlayer = OnlyPlayer or false
  if not Unit then
    return nil
  end
  local _buff
  local i = 0
  while i <= 40 do
    i = i + 1
    if OnlyPlayer then
      _buff = _G.UnitBuff('player', i)
    else
      _buff = lb.UnitTagHandler(_G.UnitBuff, Unit.GUID, i)
    end
    if _buff == self.SpellName then return true end
  end
  return nil
end