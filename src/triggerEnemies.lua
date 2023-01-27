local enemy = require("enemy")
local enemyPong = require("enemyPong")
local player = require("player")

local class  = {}

local function isCollidingTriggerActive(circle1, circle2)
  return ((circle1.x - circle2.x)^2 + (circle1.y - circle2.y)^2 <= (circle1.r + circle2.activeTrigger)^2) 
end
local function isCollidingTriggerPassive(circle1, circle2)
  return ((circle1.x - circle2.x)^2 + (circle1.y - circle2.y)^2 <= (circle1.r + circle2.passiveTrigger)^2) 
end

local function mouveIn(dt)
  local enemyList = enemy.getEnemyList()

  for enemyId, enemy in ipairs(enemyList) do
    if (not enemy.death) then
      if enemy.moveIn == true then
        if player.getX() > enemy.x then
          enemy.x = enemy.x  + enemy.speed * dt
          if enemy.speed > 0 then
            enemy.currentAnimation = enemy.animations.right
          else
            enemy.currentAnimation = enemy.animations.idleRight
          end
        end
        if player.getX() < enemy.x then
          enemy.x = enemy.x  - enemy.speed * dt
          if enemy.speed > 0 then
            enemy.currentAnimation = enemy.animations.left
          else
            enemy.currentAnimation = enemy.animations.idleLeft
          end
        end
        if player.getY() < enemy.y then
          enemy.y = enemy.y  - enemy.speed * dt
        end
        if player.getY() > enemy.y then
          enemy.y = enemy.y  + enemy.speed * dt
        end
      end
    end
  end
end

local function mouveOut(dt)
  local enemyList = enemy.getEnemyList()

  for enemyId, enemy in ipairs(enemyList) do
    if (not enemy.death) then
      if enemy.moveOut == true then
        if player.getX() > enemy.x then
          enemy.x = enemy.x  - enemy.speed * dt
        end
        if player.getX() < enemy.x then
          enemy.x = enemy.x  + enemy.speed * dt
        end
        if player.getY() < enemy.y then
          enemy.y = enemy.y + enemy.speed * dt
        end
        if player.getY() > enemy.y then
          enemy.y = enemy.y - enemy.speed * dt
        end
      end
    end
  end
end

local function ActiveTrigger()
  local enemyList = enemy.getEnemyList()
  local playerHitbox = player.getCenterHitbox()

  for enemyId, enemy in ipairs(enemyList) do
    if isCollidingTriggerActive(enemy, playerHitbox) then
      enemy.activeTrigger = true
      enemy.weapon.isFire = true
      if enemy.weapon.type ~= "shotgun" then
        enemy.speed = 0
      end
    else
      enemy.speed = 50
      if enemy.weapon.type == "pistol" then
        enemy.activeTrigger = false
      end
    end
  end
end

local function PassiveTrigger(dt)
  local enemyList = enemy.getEnemyList()
  local enemyPongList = enemyPong.getEnemyPongList()
  local playerHitbox = player.getCenterHitbox()

  for enemyId, enemy in ipairs(enemyList) do
    if isCollidingTriggerPassive(enemy, playerHitbox) then
      enemy.isTriggered = true
      if enemy.isTriggered then
        enemy.isTargeting = true
        if enemy.weapon.type == "sniper" then
          enemy.moveIn = false
          enemy.moveOut = true
          enemy.weapon.isFire = true
        elseif enemy.weapon.type == "rifle" then
          enemy.moveIn = true
          enemy.weapon.isFire = true
        elseif enemy.weapon.type == "pistol" then
          enemy.moveIn = true
        elseif enemy.weapon.type == "shotgun" then
          enemy.moveIn = true
        end
      else
        enemy.moveOut = false
      end
    end
  end
  for enemyPongId, enemyPong in ipairs(enemyPongList) do
    if isCollidingTriggerPassive(enemyPong, playerHitbox) then
      enemyPong.activeTrigger = true
    end
  end
end

function class.update(dt)
  PassiveTrigger(dt)
  ActiveTrigger()
  mouveIn(dt)
  mouveOut(dt)
end


return class