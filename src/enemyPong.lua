local screen = require("screen")
local images = require("images")
local lootList = require("lootList")
local animation = require("animation")

local enemyPongList = {}

local class = {}

function class.remove()
  enemyPongList = {}
end

function class.getCenterHitboxes()
  local hitboxes = {}

  for enemyPongId, enemyPong in ipairs(enemyPongList) do
    local hitbox = {}

    hitbox.x = enemyPong.x
    hitbox.y = enemyPong.y
    hitbox.r = enemyPong.r

    table.insert(hitboxes, hitbox)
  end
  return hitboxes
end

function class.getFeetHitboxes()
  local hitboxes = {}

  for enemyPongId, enemyPong in ipairs(enemyPongList) do
    local hitbox = {}

    hitbox.x = enemyPong.x - 32
    hitbox.y = enemyPong.y + 32
    hitbox.w = enemyPong.w - 32
    hitbox.h = enemyPong.h - 84

    table.insert(hitboxes, hitbox)
  end
  return hitboxes
end

function class.setHp(id, value)
  enemyPongList[id].hp = value
end

function class.getHp(id)
  return enemyPongList[id].hp
end

function class.setDirectionX(id, value)
  enemyPongList[id].directionX = value
end

function class.setDirectionY(id, value)
  enemyPongList[id].directionY = value
end

function class.getEnemyPongDmg()
  for enemyPongId, enemyPong in ipairs(enemyPongList) do
    return enemyPong.dmg
  end
end

function class.getEnemyPongList()
  return enemyPongList
end

function class.getNbEnemy()
  return #enemyPongList  
end

function class.createEnemies(x, y)
  local enemyPong = {}
  enemyPong.sheet      = images.getImage("enemyPongSheet")
  enemyPong.w          = 101
  enemyPong.h          = 101
  enemyPong.r          = enemyPong.w/2
  enemyPong.x          = x
  enemyPong.y          = y
  enemyPong.speed      = 200
  enemyPong.hp         = 200
  enemyPong.dmg        = 50
  enemyPong.death      = false
  enemyPong.deathTime  = 0
  enemyPong.activeTrigger = false

  if (love.math.random(2) == 1) then
    enemyPong.directionX = "right"
  else
    enemyPong.directionX = "left"
  end
  if (love.math.random(2) == 1) then
    enemyPong.directionY = "up"
  else
    enemyPong.directionY = "down"
  end

  enemyPong.animations = {}
  enemyPong.animations.idle    = animation.new(enemyPong.sheet, 4, 10, 0, 0, enemyPong.w, enemyPong.h)
  enemyPong.animations.right   = animation.new(enemyPong.sheet, 6, 10, 0, 101, enemyPong.w, enemyPong.h)
  enemyPong.animations.left    = animation.new(enemyPong.sheet, 6, 10, 0, 202, enemyPong.w, enemyPong.h)
  enemyPong.animations.death   = animation.new(enemyPong.sheet, 5, 10, 0, 303, enemyPong.w, enemyPong.h)

  enemyPong.currentAnimation = enemyPong.animations.idle

  table.insert(enemyPongList, enemyPong)
end

local function direction(obj)
  if (obj.directionX == "right") then
    obj.image = obj.right
  elseif (obj.directionX == "left") then
    obj.image = obj.left
  end
  if (obj.activeTrigger) then
    if obj.directionX == "right" then
      obj.currentAnimation = obj.animations.right
    elseif obj.directionX == "left" then
      obj.currentAnimation = obj.animations.left
    elseif obj.speed == 0 then
      obj.currentAnimation = obj.animations.idle
    end
  end
end

local function rolling(obj, dt)
  if (obj.activeTrigger) then
    if (obj.directionX == "right") then
      obj.x = obj.x + obj.speed * dt
    elseif (obj.directionX == "left") then
      obj.x = obj.x - obj.speed * dt
    end
    if (obj.directionY == "down") then
      obj.y = obj.y + obj.speed * dt
    elseif (obj.directionY == "up") then
      obj.y = obj.y - obj.speed * dt
    end
  end
end

local function checkDeath(dt)
  for enemyPongId, enemyPong in ipairs(enemyPongList) do
    if (enemyPong.hp < 200) then
      enemyPong.activeTrigger = true
    end
    if (enemyPong.hp <= 100) then
      enemyPong.speed = 400
    end
    if (enemyPong.hp <= 0) then
      enemyPong.death = true
      enemyPong.currentAnimation = enemyPong.animations.death
      enemyPong.deathTime = enemyPong.deathTime + 1 * dt
      if (enemyPong.deathTime >= 0.5) then
        lootList.createLoot("coin", enemyPong.x, enemyPong.y)
        table.remove(enemyPongList, enemyPongId)
      end
    end
  end
end

function class.update(dt)
  for enemyPongId, enemyPong in ipairs(enemyPongList) do
    if (not enemyPong.death) then
      direction(enemyPong)
      rolling(enemyPong, dt)
    end
    animation.update(enemyPong.currentAnimation, dt)
  end
  checkDeath(dt)
end

local function drawEnemy()
  for enemyPongId, enemyPong in ipairs(enemyPongList) do
    love.graphics.setColor(1, 1, 1)
    animation.draw(enemyPong.currentAnimation, enemyPong.x, enemyPong.y, enemyPong.w, enemyPong.h)
    if (not enemyPong.death) then
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle("fill", enemyPong.x - 50, enemyPong.y - 75, enemyPong.hp/2,10)
      love.graphics.draw(images.getImage("lifeEnemyPong"), enemyPong.x, enemyPong.y - 26, 0,1,1,enemyPong.w/2, enemyPong.h/2)
    end
  end
end

function class.draw()
  drawEnemy()
end

return class