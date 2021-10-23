local Hilex = Hilex
Hilex:RegisterChatCommand("hv", "ChatCommand")

local function SplitInput(Input)
  local Table = {}
  Input = strupper(Input)
  for i in string.gmatch(Input, '%S+') do
    table.insert(Table, i)
  end
  return Table
end

function Hilex:ChatCommand(Input)
  if not Input or Input:trim() == "" then
    print("Please Type Your Command Correctly!")
  else
    local Commands = SplitInput(Input)
    if Commands[1] == "START" then
      Hilex.IsRunning = true
      if Commands[2] == "MASTER" then
        Hilex.Role = "Master"
      else
        if Commands[2] == "SLAVE" then
          Hilex.Role = "Slave"
        end
      end
    elseif Commands[1] == "RESET" then
      RecordIndex = 1
    elseif Commands[1] == "STOP" then
      Hilex.IsRunning = false
      if lb then Hilex.Navigator.Stop() end
    elseif Commands[1] == "RECORD" then
      if Hilex.Time > Hilex.Pause then
        PathX = lb.GetGameDirectory() .. "\\Interface\\Addons\\Hilex\\Path\\Coordinate.lua"
        local X,Y,Z = lb.ObjectPosition('player')
        lb.WriteFile(PathX, "[" .. RecordIndex .. "] = { " .. X .. " , " .. Y .. " , " .. Z .. " } " .. "\n", true)
        print("RecordIndex[" .. RecordIndex .. "] = X: " .. X .. "," .. "Y: " .. Y .. "," .. "Z: " .. Z) 
        RecordIndex = RecordIndex + 1
        Hilex.Pause = Hilex.Time + 1
      end
    else
      LibStub("AceConfigCmd-3.0").HandleCommand(Hilex, "rc", "Hilex", Input)
    end
  end
end