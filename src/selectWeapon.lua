local mouse = require("mouse")
local player = require("player")

local class = {}
local data = {}

function class.setSlot(name, value)
  data[name] = value  
end

function class.setSelection(value)
  data.selection = value
end

function class.setInventory(value)
  data.selected = value
end

function class.load()
  data.selected = false
  data.selection = 0
  data.r = 150
end

function class.update(dt)
  if (data.selection == 0) then
    player.setWeapon("pistol", false)
    player.setWeapon("rifle", false)
    player.setWeapon("sniper", false)
    player.setWeapon("shotgun", false)
    player.setWeapon("snowX", false)
    player.setWeapon("ray", false)
  end
  
  if (data.selection == 1) then
    player.setWeapon("pistol", true)
    player.setWeapon("rifle", false)
    player.setWeapon("sniper", false)
    player.setWeapon("shotgun", false)
    player.setWeapon("snowX", false)
    player.setWeapon("ray", false)
  end
  
  if (data.selection == 2) then
    player.setWeapon("pistol", false)
    player.setWeapon("rifle", true)
    player.setWeapon("sniper", false)
    player.setWeapon("shotgun", false)
    player.setWeapon("snowX", false)
    player.setWeapon("ray", false)
  end
  
  if data.selection == 3 then
    player.setWeapon("pistol", false)
    player.setWeapon("rifle", false)
    player.setWeapon("sniper", true)
    player.setWeapon("shotgun", false)
    player.setWeapon("snowX", false)
    player.setWeapon("ray", false)
  end
  
  if (data.selection == 4) then
    player.setWeapon("pistol", false)
    player.setWeapon("rifle", false)
    player.setWeapon("sniper", false)
    player.setWeapon("shotgun", true)
    player.setWeapon("snowX", false)
    player.setWeapon("ray", false)
  end
  
  if (data.selection == 5) then
    player.setWeapon("pistol", false)
    player.setWeapon("rifle", false)
    player.setWeapon("sniper", false)
    player.setWeapon("shotgun", false)
    player.setWeapon("snowX", true)
    player.setWeapon("ray", false)
  end
  
  if (data.selection == 6) then
    player.setWeapon("pistol", false)
    player.setWeapon("rifle", false)
    player.setWeapon("sniper", false)
    player.setWeapon("shotgun", false)
    player.setWeapon("snowX", false)
    player.setWeapon("ray", true)
  end
end

function class.keypressed(key)
  data.x = mouse.getX()
  data.y = mouse.getY()
end

return class