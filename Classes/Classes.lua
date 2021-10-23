local Hilex = Hilex
Hilex.Classes = {}

local Classes = Hilex.Classes
local function Class()
  local cls = {}
  cls.__index = cls
  setmetatable(
    cls,
    {
      __call = function (self, ...)
        local instance = setmetatable({}, self)
        instance:New(...)
        return instance
      end
    }
  )
  return cls
end

Classes.Spell = Class()
Classes.Buff = Class()
Classes.Debuff = Class()
Classes.Unit = Class()
Classes.LocalPlayer = Class()
Classes.Item = Class()
Classes.GameObject = Class()