local images = require("images")
local player = require("player")
local animation = require("animation")
local screen = require("screen")
local sounds = require("sounds")

local class = {}
local lootList = {}
local sound = {}

local numberCoins
local font

function class.getLootList()
  return lootList
end

function class.resetLootList()
  lootList = {}
end

function class.getNumberCoins()
  return numberCoins  
end

function class.getSoundSwitch()
  return sound.switch  
end

function class.createLoot(type, x, y)
  local loot = {}
  loot.type = type

  if loot.type == "coin" then
    loot.sprite = images.getImage("coinSheet")
    loot.w = 64
    loot.h = 64
  elseif loot.type == "heal" then
    loot.sprite = images.getImage("healSheet")
    loot.w = 49
    loot.h = 47
    loot.value = 50
  elseif loot.type == "parchemin" then
    loot.image = images.getImage("parchemin")
  elseif loot.type == "pistol" then
    loot.image = images.getImage("pistolR")
  elseif loot.type == "rifle" then
    loot.image = images.getImage("rifleR")
  elseif loot.type == "sniper" then
    loot.image = images.getImage("sniperR")
  elseif loot.type == "shotgun" then
    loot.image = images.getImage("shotgunR")
  elseif loot.type == "snowX" then
    loot.image = images.getImage("snowXR")
  elseif loot.type == "ray" then
    loot.image = images.getImage("rayR")
  end

  if (loot.type == "pistol") or (loot.type == "rifle") or (loot.type == "sniper") or (loot.type == "shotgun") or (loot.type == "snowX") or (loot.type == "ray") or (loot.type == "parchemin") then
    loot.w = loot.image:getWidth()/2
    loot.h = loot.image:getHeight()/2
  end

  loot.x = x
  loot.y = y
  loot.r = loot.w/2
  loot.angle        = math.rad(0)
  loot.speed        = 600
  loot.acceleration = 500
  loot.timer        = 0
  loot.canTriggered = false
  loot.isTrigger    = false
  loot.delete       = false
  loot.showControl  = false
  if (loot.type == "coin") then
    loot.animation = animation.new(loot.sprite, 6, 10, 0, 0, loot.w, loot.h)
  elseif (loot.type == "heal") then
    loot.animation = animation.new(loot.sprite, 7, 10, 0, 0, loot.w, loot.h)
  end

  table.insert(lootList, loot)
end

function class.createRandomLoot(x, y)
  local random = love.math.random(1, 6)

  if (random == 1) then
    class.createLoot("pistol", x, y)
  elseif (random == 2) then
    class.createLoot("rifle", x, y)
  elseif (random == 3) then
    class.createLoot("sniper", x, y)
  elseif (random == 4) then
    class.createLoot("shotgun", x, y)
  elseif (random == 5) then
    class.createLoot("snowX", x, y)
  elseif (random == 6) then
    class.createLoot("ray", x, y)
  end
end

function class.load()
  lootList = {}
  numberCoins = 0
  font = love.graphics.newFont("Assets/Images/Font.ttf", 50)
  class.createLoot("parchemin", screen.getWidth()/2, screen.getHeight()/2)
  sound.switch = sounds.getSound("switch")
end

function class.update(dt)
  for lootId, loot in ipairs(lootList) do
    loot.timer = loot.timer + 1 * dt
    if (loot.timer < 0.1) then
      loot.y = loot.y - loot.speed * dt
    elseif (loot.timer < 0.2) then
      loot.y = loot.y + loot.speed * dt
    else
      loot.canTriggered = true
    end
    if (loot.delete) then
      if loot.type == "coin" then
        numberCoins = numberCoins + 1
      elseif (loot.type == "heal") then
        if (player.getHp() < player.getHpMax() - loot.value) then
          player.setHp(player.getHp() + 50)
        else
          player.setHp(player.getHpMax())
        end
      end
      table.remove(lootList, lootId)
    end
    if (loot.type == "coin") or (loot.type == "heal") then  
      animation.update(loot.animation, dt)
    end
  end
end

function class.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(font)
  
  for lootId, loot in ipairs(lootList) do
    if (loot.type == "pistol") or (loot.type == "rifle") or (loot.type == "sniper") or (loot.type == "shotgun") or (loot.type == "snowX") or (loot.type == "ray") or (loot.type == "parchemin") then
      love.graphics.draw(loot.image, loot.x, loot.y, loot.angle, 1, 1, loot.w, loot.h)
    else
      animation.draw(loot.animation, loot.x, loot.y, loot.w, loot.h)
    end
    if (loot.pressE) then
      love.graphics.draw(images.getImage("pressE"),player.getX() - 45,player.getY() - 100)
    end
    if loot.showControl then
      local controlImg = images.getImage("parcheminControls")
      love.graphics.draw(controlImg, (screen.getWidth()-controlImg:getWidth())/2, 100)
    end
  end
  
  love.graphics.draw(images.getImage("numberCoins"), 35, 23)
  love.graphics.draw(images.getImage("coin"), 50, 20)
  love.graphics.setColor(0,0,0)
  love.graphics.print(": "..numberCoins, 100,20)
  love.graphics.setColor(1,1,1)

end

return class