local Hilex = Hilex
local FV_Unit = Hilex.Classes.Unit

function FV_Unit:GetDistance(OtherUnit)
  OtherUnit = OtherUnit or Hilex.Player
  if self.PosX and self.PosY and self.PosZ then
    local dist = lb.GetDistance3D(self.PosX, self.PosY, self.PosZ, OtherUnit.PosX, OtherUnit.PosY, OtherUnit.PosZ)
    if dist < 0 then return 0 end
    return dist
  end
  return 0
end