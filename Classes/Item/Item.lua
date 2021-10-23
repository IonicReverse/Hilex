local Hilex = Hilex
local FV_Item = Hilex.Classes.Item
Hilex.Tables.ItemInfo = {}

function FV_Item:New(ItemID)
  self.ItemID = ItemID
  self.ItemName = GetItemInfo(ItemID)
  if not self.ItemName then
    Hilex.Tables.ItemInfo[ItemID] = self
  end
  self.SpellName, self.SpellID = GetItemSpell(ItemID)
end

function FV_Item:Update()
  self.ItemName = GetItemInfo(self.ItemID)
  self.SpellName, self.SpellID = GetItemSpell(self.ItemID)
end

function FV_Item:Useable()
  return IsUsableItem(self.ItemName)
end

function FV_Item:Use(Unit)
  Unit = Unit or Hilex.Player
  if self.SpellID and self:Useable() then
    lb.Unlock(UseItemByName, self.ItemName, 'player')
    return true
  end
  return false
end