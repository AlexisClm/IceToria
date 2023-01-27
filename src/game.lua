local mapManager = require("mapManager")
local dungeon = require("dungeon")
local player = require("player")
local lootList = require("lootList")
local selectWeapon = require("selectWeapon")
local door = require("door")
local HUD = require("HUD")
local chest = require("chest")
local pause = require("pause")
local win = require("win")
local over = require("over")
local enemy = require("enemy")
local enemyPong = require("enemyPong")
local shootPlayer = require("shootPlayer")
local shootEnemy = require("shootEnemy")
local dashEffect = require("dashEffect")
local collectLoot = require("collectLoot")
local particulePlayer = require("particulePlayer")
local triggerEnemies = require("triggerEnemies")
local snow = require("snow")
local level = require("level")
local collisionMap = require("collisionMap")
local collision = require("collision")
local gameState = require("gameState")

local class = {}

function class.load()
  level.remove()
  enemy.remove()
  enemyPong.remove()
  mapManager.load()
  dungeon.load()
  particulePlayer.load()
  player.load()
  lootList.load()
  selectWeapon.load()
  door.load()
  HUD.load()
  chest.load()
  pause.load()
  win.load()
  over.load()
end

function class.update(dt)
  dungeon.update(dt)   
  level.update(dt)
  player.update(dt)
  enemy.update(dt)
  enemyPong.update(dt)
  shootPlayer.update(dt)
  shootEnemy.update(dt)
  lootList.update(dt)
  dashEffect.update(dt)
  collectLoot.update(dt)
  particulePlayer.update(dt)
  triggerEnemies.update(dt)
  selectWeapon.update(dt)
  snow.update(dt)
  chest.update(dt)
  collisionMap.update(dt)
  collision.update(dt)
end

function class.draw()
  mapManager.draw("background")
  chest.draw()
  door.draw()
  lootList.draw()
  dashEffect.draw()

  if player.getDir() == "up" then
    shootPlayer.draw()
    player.draw()
  else
    player.draw()
    shootPlayer.draw()
  end

  shootEnemy.draw()
  enemy.draw()
  enemyPong.draw()
  particulePlayer.draw()
  mapManager.draw("foreground")
  dungeon.draw()
  snow.draw()
  HUD.draw()
end

function class.keypressed(key)
  collectLoot.keypressed(key)
  player.keypressed(key)

  if (key == "escape") then
    gameState.setState("pause")
  end
end

return class