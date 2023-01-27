local screen = require("screen")
local sounds = require("sounds")
local player = require("player")
local chest = require("chest")
local enemy = require("enemy")
local enemyPong = require("enemyPong")
local shootPlayer = require("shootPlayer")
local shootEnemy = require("shootEnemy")
local dungeon = require("dungeon")
local door = require("door")
local level = require("level")

local class = {}

local function isCollidingCircleCircle(a, b)
  return (a.x - b.x)^2 + (a.y - b.y)^2 <= (a.r + b.r)^2
end

local function isCollidingRectRect(a, b)
  return (a.x + a.w > b.x) and (a.x < b.x + b.w) and (a.y + a.h > b.y) and (a.y < b.y + b.h)
end

local function rectRect(a, b)
  local collision = {side = "", value = 0}

  if (isCollidingRectRect(a, b)) then
    local colLeft  = b.x + b.w - a.x
    local colRight = a.x + a.w - b.x
    local colUp    = b.y + b.h - a.y
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

--colPortes
local function isCollidingRectRectUp(a, b)
  return (a.x < b.isUpX + b.w) and (a.x + a.w > b.isUpX) and (a.y < b.isUpY + b.h) and (a.y + a.h > b.isUpY)
end

local function isCollidingRectRectDown(a, b)
  return (a.x < b.isDownX + b.w) and (a.x + a.w > b.isDownX) and (a.y < b.isDownY + b.h) and (a.y + a.h > b.isDownY)
end

local function isCollidingRectRectLeft(a, b)
  return (a.x < b.isLeftX + b.w) and (a.x + a.w > b.isLeftX) and (a.y < b.isLeftY + b.h) and (a.y + a.h > b.isLeftY)
end

local function isCollidingRectRectRight(a, b)
  return (a.x < b.isRightX + b.w) and (a.x + a.w > b.isRightX) and (a.y < b.isRightY + b.h) and (a.y + a.h > b.isRightY)
end

local function checkColPlayerChests()
  local playerHitbox = player.getFeetHitbox()
  local chestHitboxes = chest.getHitboxes()

  for chestId, chest in ipairs(chestHitboxes) do
    local collision = rectRect(playerHitbox, chest)

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
end

local function checkColPlayerShoots()
  local playerHitbox = player.getCenterHitbox()
  local enemyShootList = shootEnemy.getShootList()

  for shootId, shoot in ipairs(enemyShootList) do
    if (isCollidingCircleCircle(playerHitbox, shoot)) then
      table.remove(enemyShootList, shootId)
      if (player.getAlive()) and (not player.isImmunity()) then
        player.setHp(player.getHp() - shoot.dmg)
        player.setImmunity(true)
        local hit = sounds.getSound("playerHit")
        hit:play()
      end
    end
  end
end

local function checkColEnemiesShoots()
  local playerShootList = shootPlayer.getShootList()
  local enemyHitboxes = enemy.getCenterHitboxes()

  for shootId, shoot in ipairs(playerShootList) do
    for enemyId, enemyHitbox in ipairs(enemyHitboxes) do
      if (isCollidingCircleCircle(shoot, enemyHitbox)) then
        local hit = sounds.getSound("enemyHit")
        hit:play()
        table.remove(playerShootList, shootId)
        enemy.setHp(enemyId, enemy.getHp(enemyId) - shoot.dmg)

      end
    end
  end
end

local function checkColEnemiesPongShoots()
  local playerShootList = shootPlayer.getShootList()
  local enemyPongHitboxes = enemyPong.getCenterHitboxes()

  for shootId, shoot in ipairs(playerShootList) do
    for enemyPongId, enemyPongHitbox in ipairs(enemyPongHitboxes) do
      if (isCollidingCircleCircle(shoot, enemyPongHitbox)) then
        table.remove(playerShootList, shootId)
        enemyPong.setHp(enemyPongId, enemyPong.getHp(enemyPongId) - shoot.dmg)
      end
    end
  end
end

local function checkColEnemiesPongPlayer(dt)
  local playerHitbox = player.getCenterHitbox()
  local enemyPongHitboxes = enemyPong.getCenterHitboxes()

  for enemyPongId, enemyPongHitbox in ipairs(enemyPongHitboxes) do
    if (isCollidingCircleCircle(playerHitbox, enemyPongHitbox)) then
      if (not player.isImmunity()) then
        player.setHp(player.getHp() - enemyPong.getEnemyPongDmg())
        player.setStun(true)
        player.setImmunity(true)
      end
    end
  end
end

local function checkColPlayerDoors()
  local playerHitbox = player.getHitbox()
  local doorHitbox = door.getHitbox()
  local nextRoom = {line = player.getLine(), column = player.getColumn()}

  if (enemy.getNbEnemy() == 0) and (enemyPong.getNbEnemy() == 0) and (player.isStuff()) then
    if (dungeon.isDoorUp(player.getLine(), player.getColumn())) then
      if (isCollidingRectRectUp(playerHitbox, doorHitbox)) then
        player.setLine(player.getLine()-1)
        player.setY((screen.getHeight()/2)+260)
        dungeon.setActualRoom(nextRoom)

        level.remove()
        level.load()
      end
    end
    if (dungeon.isDoorDown(player.getLine(), player.getColumn())) then
      if(isCollidingRectRectDown(playerHitbox, doorHitbox)) then
        player.setLine(player.getLine()+1)
        player.setY((-screen.getHeight()/2)-260)
        dungeon.setActualRoom(nextRoom)

        level.remove()
        level.load()
      end
    end
    if (dungeon.isDoorLeft(player.getLine(), player.getColumn())) then
      if(isCollidingRectRectLeft(playerHitbox, doorHitbox)) then
        player.setColumn(player.getColumn()-1)
        player.setX(screen.getWidth()-200)
        dungeon.setActualRoom(nextRoom)

        level.remove()
        level.load()
      end
    end
    if (dungeon.isDoorRight(player.getLine(), player.getColumn())) then
      if(isCollidingRectRectRight(playerHitbox, doorHitbox)) then
        player.setColumn(player.getColumn()+1)
        player.setX(-screen.getWidth()+200)
        dungeon.setActualRoom(nextRoom)

        level.remove()
        level.load()
      end
    end
  end
  dungeon.setUsingRoom(player.getLine(), player.getColumn(), true)
  dungeon.setUsedRoom(player.getLine(), player.getColumn(), true)
end

function class.update(dt)
  checkColPlayerChests()
  checkColPlayerShoots()
  checkColEnemiesShoots()
  checkColEnemiesPongShoots()
  checkColPlayerDoors()
  checkColEnemiesPongPlayer()
end

return class