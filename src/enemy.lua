local screen = require("screen")
local player = require("player")
local images = require("images")
local lootList = require("lootList")
local weapons = require("weapons")
local animation = require("animation")

local enemyList = {}

local class = {}

function class.remove()
  enemyList = {}
end

function class.getCenterHitboxes()
  local hitboxes = {}

  for enemyId, enemy in ipairs(enemyList) do
    local hitbox = {}

    hitbox.x = enemy.x
    hitbox.y = enemy.y
    hitbox.r = enemy.r

    table.insert(hitboxes, hitbox)
  end
  return hitboxes
end

function class.getFeetHitboxes()
  local hitboxes = {}

  for enemyId, enemy in ipairs(enemyList) do
    local hitbox = {}

    hitbox.x = enemy.x - 26
    hitbox.y = enemy.y + 30
    hitbox.w = enemy.w - 18
    hitbox.h = enemy.h - 84

    table.insert(hitboxes, hitbox)
  end
  return hitboxes
end

function class.moveX(id, value)
  enemyList[id].x = enemyList[id].x + value
end

function class.moveY(id, value)
  enemyList[id].y = enemyList[id].y + value
end

function class.setHp(id, value)
  enemyList[id].hp = value
end

function class.getHp(id)
  return enemyList[id].hp
end

function class.setIsTriggered(id, value)
  enemyList[id].isTriggered = value
end

function class.getEnemyList()
  return enemyList
end

function class.getNbEnemy()
  return #enemyList  
end

function class.createEnemies(type, x, y)
  local enemy = {}
  enemy.sheet = images.getImage("enemySheet")
  enemy.deathSheet = images.getImage("enemyDeathSheet")
  enemy.w     = 69
  enemy.h     = 105
  enemy.r     = enemy.h/2
  enemy.x     = x 
  enemy.y     = y 
  enemy.angle = math.rad(0)
  enemy.speed = 50
  enemy.hp = 100
  enemy.passiveTrigger = false
  enemy.activeTrigger  = false
  enemy.moveIn         = false
  enemy.moveOut        = false
  enemy.isMoovingRight = false
  enemy.isMoovingLeft  = false
  enemy.isTargeting    = false
  enemy.isTriggered    = false
  enemy.death          = false
  enemy.deathTime      = 0
  enemy.weapon = weapons.create(type, enemy.x, enemy.y)

  enemy.animations = {}

  enemy.animations.right = animation.new(enemy.sheet, 7, 10, 0, 105, enemy.w, enemy.h)
  enemy.animations.left  = animation.new(enemy.sheet, 7, 10, 0, 210, enemy.w, enemy.h)

  enemy.animations.idleDown  = animation.new(enemy.sheet, 6, 10, 0, 0, enemy.w, enemy.h)
  enemy.animations.idleRight = animation.new(enemy.sheet, 7, 10, 0, 315, enemy.w, enemy.h)
  enemy.animations.idleLeft  = animation.new(enemy.sheet, 7, 10, 0, 420, enemy.w, enemy.h)

  enemy.animations.death  = animation.new(enemy.deathSheet, 6, 10, 0, 0, 122, 108)

  enemy.currentAnimation = enemy.animations.idleDown

  table.insert(enemyList, enemy)
end

local function angleShoot(dt,obj,dest)
  obj.x = dest.x  + math.cos(obj.angle) * obj.speed * dt
  obj.y = dest.y  + math.sin(obj.angle) * obj.speed * dt
end

local function direction(obj)
  if obj.isTargeting == true then
    if obj.x > player.getX() + player.getW() then
      obj.image = obj.left
    elseif obj.x < player.getX() - player.getW() then
      obj.image = obj.right
    end
  end
  if obj.isMoovingRight then
    obj.currentAnimation = obj.animations.right
  elseif obj.isMoovingLeft then
    obj.currentAnimation = obj.animations.left
  elseif obj.speed == 0 and obj.isMoovingRight then
    obj.currentAnimation = obj.animations.idleRight
  end
end

local function checkDeath(dt)
  for enemyId, enemy in ipairs(enemyList) do
    if enemy.hp < 100 then
      enemy.isTargeting = true
      if enemy.weapon.type == "sniper" then
        enemy.moveOut = true
        enemy.weapon.isFire = true
      elseif enemy.weapon.type == "rifle" or enemy.weapon.type == "pistol" or enemy.weapon.type == "shotgun" then
        enemy.moveIn = true 
      end
    end
    if (enemy.hp <= 0) then
      enemy.death = true
      enemy.currentAnimation = enemy.animations.death
      enemy.deathTime = enemy.deathTime + 1 * dt
      if (enemy.deathTime >= 0.5) then
        lootList.createLoot("coin", enemy.x-25, enemy.y)
        local rng = love.math.random(3)
        if (rng == 1) then
          lootList.createLoot("heal", enemy.x+25, enemy.y)
        end
        player.setKill(player.getKill() + 1)
        table.remove(enemyList, enemyId)
      end
    end
  end
end

local function upWeapons(enemy, dt)
  local playerX = player.getX()
  local playerY = player.getY()
  weapons.update(enemy.weapon, enemy.x, enemy.y , true, false, dt)
  if (enemy.isTargeting) then
    enemy.weapon.angle = math.atan2(playerY - enemy.y, playerX - enemy.x )
    if player.getX() > enemy.x then
      enemy.weapon.image = enemy.weapon.right
    else
      enemy.weapon.image = enemy.weapon.left
    end

  end
end

function class.update(dt)
  for enemyId, enemy in ipairs(enemyList) do
    if (not enemy.death) then
      upWeapons(enemy, dt)
      direction(enemy)
    end
    animation.update(enemy.currentAnimation, dt)
  end
  checkDeath(dt)
end

local function drawEnemy(type)
  for enemyId, enemy in ipairs(enemyList) do

    love.graphics.setColor(1, 1, 1)
    animation.draw(enemy.currentAnimation, enemy.x, enemy.y, enemy.w, enemy.h)
--    love.graphics.rectangle("line", enemy.x-26, enemy.y+30, enemy.w-18, enemy.h-84)
    if enemy.isTargeting == true then
      weapons.draw(enemy.weapon, enemy.x , enemy.y - 15 )
    end
    if (not enemy.death) then
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle("fill",enemy.x - 24,enemy.y - 75 ,enemy.hp/2,10)
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(images.getImage("lifeEnemy"), enemy.x+9, enemy.y - 24, 0,1,1,enemy.w/2, enemy.h/2)
    end
--    love.graphics.circle("line",enemy.x, enemy.y, enemy.r)
  end
end

function class.draw(type)
  drawEnemy(type)
end

return class