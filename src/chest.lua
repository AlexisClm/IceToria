local screen = require("screen")
local images = require("images")
local animation = require("animation")
local player = require("player")

local chestList = {}

local class = {}

function class.getHitboxes()
  local hitboxes = {}

  for chestId, chest in ipairs(chestList) do
    local hitbox = {}

    hitbox.x = chest.x
    hitbox.y = chest.y + 12
    hitbox.w = chest.w
    hitbox.h = chest.h - 12

    table.insert(hitboxes, hitbox)
  end
  
  return hitboxes
end

function class.getChestList()
  return chestList
end

function class.resetChestList()
  chestList = {}
end

function class.createChest(x, y)
  local chest = {}

  chest.sheet = images.getImage("chestSheet")
  chest.x = x
  chest.y = y
  chest.w = 105
  chest.h = 75
  chest.pressE = false
  chest.open = false

  chest.animation = animation.new(chest.sheet, 4, 6, 0, 0, chest.w, chest.h)

  table.insert(chestList, chest)
end

function class.load()
  class.createChest(398, 440)
  class.createChest(1423, 440)
end

function class.update(dt)
  for chestId, chest in ipairs(chestList) do
    if (chest.open) then
      if (chest.animation.currentFrame < 4) then
        animation.update(chest.animation, dt)
      else
        chest.animation.currentFrame = 4
      end
    end
  end
end

function class.draw()
  for chestId, chest in ipairs(chestList) do
    love.graphics.setColor(1, 1, 1)
    animation.draw(chest.animation, chest.x, chest.y, 0, 0)
    if (chest.pressE) and (not chest.open) then
      love.graphics.draw(images.getImage("pressE"),player.getX() - 45,player.getY() - 100)
    end
  end
end

return class