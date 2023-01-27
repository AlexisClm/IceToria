local lootList = require("lootList")
local player = require("player")
local selectWeapon = require("selectWeapon")
local images = require("images")
local sounds = require("sounds")
local chest = require("chest")

local class = {}

local function isCollidingCircleActiveTrigger(circle1, circle2)
  return ((circle1.x - circle2.x)^2 + (circle1.y - circle2.y)^2 <= (circle1.r + circle2.lootTrigger)^2) 
end

local function isCollidingCircleCircle(circle1, circle2)
  return ((circle1.x - circle2.x)^2 + (circle1.y - circle2.y)^2 <= (circle1.r + circle2.r)^2) 
end

local function isCollidingRectRect(a, b)
  return (a.x < b.x + b.w) and (a.x + a.w > b.x) and (a.y < b.y + b.h) and (a.y + a.h > b.y)
end

local function setWeapon(name)
  if (player.getWeapon(name) == true) then
    lootList.createLoot(name, player.getX(), player.getY()+100)
    player.setWeapon(name, false)
  end
end

local function lootTriggered()
  local lootsList = lootList.getLootList()
  local playerHitbox = player.getCenterHitbox()
  local playerHitbox2 = player.getHitbox()

  for lootId, loot in ipairs(lootsList) do
    if (isCollidingCircleActiveTrigger(loot,playerHitbox)) then
      if (loot.type == "coin") or (loot.type == "heal") then
        loot.isTrigger = true
        loot.canTriggered = true
      end
      if (isCollidingRectRect(loot,playerHitbox2)) then
        if (loot.type == "pistol") or (loot.type == "rifle") or (loot.type == "sniper") or (loot.type == "shotgun") or (loot.type == "snowX") or (loot.type == "ray") or (loot.type == "parchemin") then
          loot.pressE = true
        else
          loot.delete = true
        end
      else
        loot.pressE = false
      end
      if (loot.type == "parchemin") then
        if love.keyboard.isDown("e") and  (loot.pressE) then
          loot.showControl = true
          player.setDir("up")
        else
          loot.showControl = false
        end
      end
    end
  end
end

local function MoveIn(dt)
  local lootList = lootList.getLootList()
  for lootId, loot in ipairs(lootList) do
    if (loot.isTrigger) and (loot.canTriggered) then
      if (player.getX() > loot.x) then
        loot.x = loot.x  + loot.speed * dt
      end
      if (player.getX() < loot.x) then
        loot.x = loot.x  - loot.speed * dt
      end
      if (player.getY() < loot.y) then
        loot.y = loot.y  - loot.speed * dt
      end
      if (player.getY() > loot.y) then
        loot.y = loot.y  + loot.speed * dt
      end
    end
  end
end

local function checkChest()
  local playerHitbox2 = player.getHitbox()
  local chestList = chest.getChestList()

  for chestId, chest in ipairs(chestList) do
    if (isCollidingRectRect(chest,playerHitbox2)) then
      if (not chest.open) then
        chest.pressE = true
      end
    else
      chest.pressE = false
    end
  end
end

function class.update(dt)
  MoveIn(dt)
  lootTriggered()
  checkChest()
end

function class.keypressed(key)
  local playerHitbox2 = player.getHitbox()
  local lootsList = lootList.getLootList()
  local chestList = chest.getChestList()

  for chestId, chest in ipairs(chestList) do
    if (isCollidingRectRect(chest,playerHitbox2)) then
      if (not chest.open) then
        if (key == "e") then
          chest.open = true
          lootList.createRandomLoot(chest.x + chest.w/2, chest.y + chest.h/2)
        end
      end
    end
  end

  for lootId, loot in ipairs(lootsList) do
    if (isCollidingRectRect(loot,playerHitbox2)) then
      if (key == "e") then
        if (loot.canTriggered == true) then
          lootList.getSoundSwitch():play()
          if (loot.type == "pistol") then
            loot.delete = true
            selectWeapon.setSelection(1)
            setWeapon("rifle")
            setWeapon("sniper")
            setWeapon("shotgun")
            setWeapon("snowX")
            setWeapon("ray")

          elseif (loot.type == "rifle") then
            loot.delete = true
            selectWeapon.setSelection(2)
            setWeapon("pistol")
            setWeapon("sniper")
            setWeapon("shotgun")
            setWeapon("snowX")
            setWeapon("ray")

          elseif (loot.type == "sniper") then
            loot.delete = true
            selectWeapon.setSelection(3)
            setWeapon("pistol")
            setWeapon("rifle")
            setWeapon("shotgun")
            setWeapon("snowX")
            setWeapon("ray")

          elseif (loot.type == "shotgun") then
            loot.delete = true
            selectWeapon.setSelection(4)
            setWeapon("pistol")
            setWeapon("rifle")
            setWeapon("sniper")
            setWeapon("snowX")
            setWeapon("ray")

          elseif (loot.type == "snowX") then
            loot.delete = true
            selectWeapon.setSelection(5)
            setWeapon("pistol")
            setWeapon("rifle")
            setWeapon("sniper")
            setWeapon("shotgun")
            setWeapon("ray")

          elseif (loot.type == "ray") then
            loot.delete = true
            selectWeapon.setSelection(6)
            setWeapon("pistol")
            setWeapon("rifle")
            setWeapon("sniper")
            setWeapon("shotgun")
            setWeapon("snowX")
          end
        else
          loot.pressE = false
        end
      end
    end
  end
end

return class