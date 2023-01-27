local mapManager = require("mapManager")
local player = require("player")
local enemy = require("enemy")
local enemyPong = require("enemyPong")
local shootPlayer = require("shootPlayer")
local shootEnemy = require("shootEnemy")

local class = {}

local function isCollidingRectRect(a, b)
  return (a.x + a.w > b.x) and (a.x < b.x + b.width) and (a.y + a.h > b.y) and (a.y < b.y + b.height)
end

local function rectRect(a, b)
  local collision = {side = "", value = 0}

  if (isCollidingRectRect(a, b)) then
    local colLeft  = b.x + b.width - a.x
    local colRight = a.x + a.w - b.x
    local colUp    = b.y + b.height - a.y
    local colDown  = a.y + a.h - b.y
    local colMin   = math.min(colLeft, colRight, colUp, colDown)

    if (colMin == colLeft) then
      collision.side = "left"
    elseif (colMin == colRight) then
      collision.side = "right"
    elseif (colMin == colUp) then
      collision.side = "up"
    elseif (colMin == colDown) then
      collision.side = "down"
    end
    collision.value = colMin
  end
  return collision
end

local function checkColPlayerMap(object)
  local playerHitbox = player.getFeetHitbox()
  local collision = rectRect(playerHitbox, object)

  if (collision.side == "up") then
    player.setY(collision.value)
  elseif (collision.side == "down") then
    player.setY(-collision.value)
  elseif (collision.side == "left") then
    player.setX(collision.value)
  elseif (collision.side == "right") then
    player.setX(-collision.value)
  end
end

local function checkColEnemiesMap(object)
  local enemyHitboxes = enemy.getFeetHitboxes()

  for enemyId, enemyHitbox in ipairs(enemyHitboxes) do
    local collision = rectRect(enemyHitbox, object)

    if (collision.side == "up") then
      enemy.moveY(enemyId, collision.value)
    elseif (collision.side == "down") then
      enemy.moveY(enemyId, -collision.value)
    elseif (collision.side == "left") then
      enemy.moveX(enemyId, collision.value)
    elseif (collision.side == "right") then
      enemy.moveX(enemyId, -collision.value)
    end
  end
end

local function checkColEnemiesPongMap(object)
  local enemyPongHitboxes = enemyPong.getFeetHitboxes()

  for enemyPongId, enemyPongHitbox in ipairs(enemyPongHitboxes) do
    local collision = rectRect(enemyPongHitbox, object)

    if (collision.side == "up") then
      enemyPong.setDirectionY(enemyPongId, "down")
    elseif (collision.side == "down") then
      enemyPong.setDirectionY(enemyPongId, "up")
    elseif (collision.side == "left") then
      enemyPong.setDirectionX(enemyPongId, "right")
    elseif (collision.side == "right") then
      enemyPong.setDirectionX(enemyPongId, "left")
    end
  end
end

local function checkColShootsMap(object)
  local playerShootList = shootPlayer.getShootList()
  local enemyShootList = shootEnemy.getShootList()

  for shootId, shoot in ipairs(playerShootList) do
    if (isCollidingRectRect(shoot, object)) then
      table.remove(playerShootList, shootId)
    end
  end

  for shootId, shoot in ipairs(enemyShootList) do
    if (isCollidingRectRect(shoot, object)) then
      table.remove(enemyShootList, shootId)
    end
  end
end

function class.update(dt)
  local map = mapManager.getActualMap()

  for layerId, layer in ipairs(map.layers) do
    if (layer.type == "objectgroup") then
      for objectId, object in ipairs(layer.objects) do
        if (object.shape == "rectangle") then
          if (object.properties["walk"]) then
            checkColPlayerMap(object)
            checkColEnemiesMap(object)
            checkColEnemiesPongMap(object)
          end
          if (object.properties["shoot"]) then
            checkColShootsMap(object)
          end
        end
      end
    end
  end
end

return class