local Hilex = Hilex
Hilex.Helpers.Slave = {}
Hilex.Helpers.Slave.MerchantOpen = false
local Slave = Hilex.Helpers.Slave
local State = 0

local InteractVendor = false
local BlackListPlayer = { "Fulart", "Minekki", "Paraindy", "Guservo" }
local ItemTokenName = { 
  102318, 102291, 104347, 
  104345, 102282, 102281, 102280,
  102283, 102278, 102322, 102277,
  102279
}

local function CheckForChest()
  local GameObject = Hilex.GameObjects
  local px,py,pz = lb.ObjectPosition('player')
  for _, i in pairs(GameObject) do
    if i.Chest then
      return i.GUID
    end
  end
  return nil
end

local function CheckPlayerName(guid)
  local TableList = BlackListPlayer
  local Name = lb.UnitTagHandler(UnitName, guid)
  for _, i in pairs(TableList) do
    if i == Name then return true end
  end
  return nil
end

local function CheckPlayerAround()
  local Unit = Hilex.Units
  for _, i in pairs(Unit) do
    if lb.ObjectType(i.GUID) == 6 then
      if not CheckPlayerName(i.GUID) then
        return i.GUID
      end
    end
  end
  return nil
end

local function CheckItemToken()
  local Token = ItemTokenName
  for _, i in pairs(Token) do
    if GetItemCount(i) >= 1 then
      return GetItemInfo(i)
    end
  end
  return nil
end

local function CheckRobot()
  local Unit = Hilex.Units
  for _, i in pairs(Unit) do
    if i.ObjectID == 24780 then
      return true
    end
  end
  return false
end

local function maxBagSlot()
  local Slots = 0
  for i = 0, 4, 1 do
    Slots = Slots + GetContainerNumSlots(i)
  end
  return Slots
end

local function VendorStep()
  
  local maxBagSlot = maxBagSlot()
  local Slot = (maxBagSlot - Hilex.Player:GetFreeBagSlots())

  if IsMounted() and Hilex.Time > Hilex.Pause then
    if Slave.MerchantOpen == false
      and Hilex.Player.Faction == "Alliance" 
    then
      local Units = Hilex.Units
      for _, Unit in pairs(Units) do
        if Unit.ObjectID == 32639 then
          lb.Unlock(lb.ObjectInteract, Unit.GUID) 
          return true
        end
      end
    end

    if Slave.MerchantOpen == false
      and Hilex.Player.Faction == "Horde" 
    then
      local Units = Hilex.Units
      for _, Unit in pairs(Units) do
        if Unit.ObjectID == 32641 then
          lb.Unlock(lb.ObjectInteract, Unit.GUID) 
          return true
        end
      end
    end

    if not InteractVendor
      and Slave.MerchantOpen == true 
    then
      InteractVendor = Hilex.Time + 10
      return true
    end

    if Slave.MerchantOpen == true
      and InteractVendor
      and Hilex.Time > InteractVendor 
      and Slot <= 10
    then
      InteractVendor = false
      State = 0
      CloseMerchant()
      return true
    end
  else
    if not IsMounted() and not Hilex.Player.Casting then
      lb.Unlock(RunMacroText, "/cast Traveler's Tundra Mammoth")
      Hilex.Pause = Hilex.Time + 6
    end
  end

end

local function Core()

  local Chest = CheckForChest()
  local ObjLockType = lb.ObjectLocked(Chest)
  local maxBagSlot = maxBagSlot()
  local Slot = maxBagSlot - (maxBagSlot - Hilex.Player:GetFreeBagSlots())

  if CheckItemToken() and not Hilex.Player.Casting then
    local Item = CheckItemToken()
    lb.Unlock(UseItemByName, Item)
    Hilex.Pause = Hilex.Time + 0.5
    return true
  end

  if State == 1 then
    VendorStep()
  end

  if Slot <= 10 and State == 0 then
    State = 1
  end
  
  if C_QuestSession.HasJoined()
    and not Hilex.Player.Casting
    and State == 0
  then
    print("Join")
    if Slot > 10 then
      if Chest and ObjLockType == false then
        print("Interact")
        lb.Unlock(lb.ObjectInteract, Chest)
        Hilex.Pause = Hilex.Time + 0.5
      end
    end
  end

  if QuestSessionManager.StartDialog:IsShown() then
    QuestSessionManager.StartDialog:Confirm()
    Hilex.Pause = Hilex.Time + 0.5
    return true
  end

end

function Slave.Run()
  if Hilex.Time > Hilex.Pause then
    Core()
  end
end