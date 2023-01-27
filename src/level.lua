local mapManager = require("mapManager")
local dungeon = require("dungeon")
local player = require("player")
local enemy = require("enemy")
local enemyPong = require("enemyPong")
local chest = require("chest")
local shootEnemy = require("shootEnemy")
local shootPlayer = require("shootPlayer")
local dashEffect = require("dashEffect")
local lootList = require("lootList")
local gameState = require("gameState")

local class = {}
local random = {}
local snowBall = {}

function class.remove()
  chest.resetChestList()
  shootEnemy.resetShootList()
  shootPlayer.resetShootList()
  dashEffect.resetList()
  lootList.resetLootList()
end

local function initChests()
  chest.createChest(398, 440)
  chest.createChest(1423, 440)
end

local function initRandomPos()
  random.pos = love.math.random(1, 4)

  if (random.pos) == 1 then
    random.x = love.math.random(832, 1088)
    random.y = love.math.random(192, 384)

  elseif (random.pos) == 2 then
    random.x = love.math.random(192, 384)
    random.y = love.math.random(448, 704)

  elseif (random.pos) == 3 then
    random.x = love.math.random(1728, 1792)
    random.y = love.math.random(448, 704)

  elseif (random.pos) == 4 then
    random.x = love.math.random(832, 1088)
    random.y = love.math.random(768, 960)
  end
end

local function initSnowBallPos()
  if (mapManager.getActualMap() == mapManager.isMap(1)) then
    local rng = love.math.random(1, 2)

    if (rng == 1) then
      snowBall.x = love.math.random(256, 640)
    else
      snowBall.x = love.math.random(1280, 1664)
    end
    snowBall.y = love.math.random(448, 832)

  elseif (mapManager.getActualMap() == mapManager.isMap(2)) then
    snowBall.x = love.math.random(768, 1152)
    snowBall.y = love.math.random(384, 832)

  elseif (mapManager.getActualMap() == mapManager.isMap(3)) or (mapManager.getActualMap() == mapManager.isMap(5)) then
    snowBall.x = love.math.random(256, 1664)
    snowBall.y = love.math.random(448, 832)

  elseif (mapManager.getActualMap() == mapManager.isMap(4)) then
    snowBall.x = 960
    snowBall.y = love.math.random(448, 768)
  end
end

local function initEnemies()
  local line = player.getLine()
  local column = player.getColumn()

  if (not dungeon.isClearedRoom(line, column)) then
    local distance = dungeon.getDistance(line, column)

    if (distance > 0) then
      initRandomPos()
      enemy.createEnemies("pistol", random.x, random.y)
    end

    if (distance > 1) then
      initRandomPos()
      enemy.createEnemies("rifle", random.x, random.y)
    end

    if (distance > 2) then
      initRandomPos()
      enemy.createEnemies("shotgun", random.x, random.y)
    end

    if (distance > 3) then
      initRandomPos()
      enemy.createEnemies("sniper", random.x, random.y)
    end

    if (distance > 4) then
      initSnowBallPos()
      enemyPong.createEnemies(snowBall.x, snowBall.y)
    end
  end
end

local function initEntities()
  if (mapManager.getActualMap() == mapManager.isMap(5)) then
    initChests()
  else
    initEnemies()
  end
end

function class.load()
  initEntities()
end

local function isClearedRoom()
  if (enemy.getNbEnemy() == 0) and (enemyPong.getNbEnemy() == 0) then
    dungeon.setClearedRoom(player.getLine(), player.getColumn(), true)
  end
end

local function checkVictory()
  local line = player.getLine()
  local column = player.getColumn()
  local distance = dungeon.getDistance(line, column)

  if (mapManager.getActualMap() ~= mapManager.isMap(5)) and (distance > 4) and (dungeon.isClearedRoom(line, column)) then 
    gameState.setState("win")
  end
end

function class.update(dt)
  isClearedRoom()
  checkVictory()
end

return class