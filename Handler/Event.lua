local Hilex = Hilex
local EventFrame = CreateFrame("Frame")
local delay = 0

EventFrame:RegisterEvent("LOOT_OPENED")
EventFrame:RegisterEvent("LOOT_READY")
EventFrame:RegisterEvent("LOOT_CLOSED")
EventFrame:RegisterEvent("LOOT_BIND_CONFIRM")
EventFrame:RegisterEvent("MERCHANT_SHOW")
EventFrame:RegisterEvent("MERCHANT_CLOSED")
EventFrame:RegisterEvent("GOSSIP_SHOW")
EventFrame:RegisterEvent("GOSSIP_CLOSED")
EventFrame:RegisterEvent("UI_ERROR_MESSAGE")
EventFrame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
EventFrame:RegisterEvent("PARTY_INVITE_REQUEST")
EventFrame:RegisterEvent("PLAYER_DEAD")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function Handler(self, event, ...)
  
  if lb then

    if event == "LOOT_READY" then
      Hilex.Player.Looting = true
      if (GetTime() - delay) >= 0.5 then
        for i = GetNumLootItems(), 1, -1 do
          LootSlot(i)
          ConfirmLootSlot(i)
        end
        delay = GetTime()
      end
    end

    if event == "LOOT_OPENED" then
      if Hilex.Player:GetFreeBagSlots() == 1 then
        CloseLoot()
      end
    end

    if event == "LOOT_CLOSED" then
      Hilex.Player.Looting = false
    end

    if event == "LOOT_BIND_CONFIRM" then
      StaticPopup1Button1:Click()
    end
    
    if event == "MERCHANT_SHOW" then
      Hilex.Helpers.Slave.MerchantOpen = true
    end

    if event == "MERCHANT_CLOSED" then
      Hilex.Helpers.Slave.MerchantOpen = false
    end

    if event == "GOSSIP_SHOW" then
      -- Hilex.Helpers.Dungeon.Vendor.MerchantGossipShow = true
    end

    if event == "GOSSIP_CLOSED" then
      -- Hilex.Helpers.Dungeon.Vendor.MerchantGossipShow = false
    end

    if event == "UI_ERROR_MESSAGE" then
      
      local _, msg = ...
      
      if msg == "You can't mount here" then
        -- Dungeon
        -- Hilex.Helpers.Dungeon.Mount.IsMounting = false
        -- Hilex.Helpers.Dungeon.Mount.CannotMountHere = true
        -- Hilex.Helpers.Dungeon.Mount.MountTimer = GetTime() + 10
      end

      if msg == "Out of range." then
        lb.Unlock(ClearTarget)
      end
      
    end

    if event == "PARTY_INVITE_REQUEST" then
      AcceptGroup()
    end

    if event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
      if not Hilex.Player.Mounted then
        --Hilex.Helpers.Dungeon.Mount.CannotMountHere = false
      end
    end

    if event == "PLAYER_DEAD" then
      if Hilex.Navigator then Hilex.Navigator.Stop() end
      Hilex.Pause = Hilex.Time + 2
      if Hilex.Player.InInstance then
        if Hilex.DeadCount then
          Hilex.DeadCount = Hilex.DeadCount + 1
        end
      end
    end

    if event == "PLAYER_ENTERING_WORLD" then
      if Hilex.Navigator then
        Hilex.Navigator.Stop()
      end
    end

  end

end

EventFrame:SetScript("OnEvent", Handler)