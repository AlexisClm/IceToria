local screen = require("screen")
local images = require("images")
local animation = require("animation")
local gameState = require("gameState")
local weapons = require("weapons")
local mouse = require("mouse")
local dungeon = require("dungeon")
local sounds = require("sounds")

local class = {}
local data = {}

function class.getHitbox()
  local hitbox = {}

  hitbox.x = data.x - data.w/2
  hitbox.y = data.y - data.h/2
  hitbox.w = data.w
  hitbox.h = data.h

  return hitbox
end

function class.getCenterHitbox()
  local hitbox = {}

  hitbox.x = data.x
  hitbox.y = data.y
  hitbox.r = data.r
  hitbox.passiveTrigger = data.passiveTrigger
  hitbox.activeTrigger  = data.activeTrigger
  hitbox.lootTrigger    = data.lootTrigger

  return hitbox
end

function class.getFeetHitbox()
  local hitbox = {}

  hitbox.x = data.x - 20
  hitbox.y = data.y + 30
  hitbox.w = data.w - 50
  hitbox.h = data.h - 85

  return hitbox
end

function class.setX(value)
  data.x = data.x + value 
end

function class.setY(value)
  data.y = data.y + value
end

function class.getX()
  return data.x
end

function class.getY()
  return data.y
end

function class.getW()
  return data.w
end

function class.getDir()
  return data.dir
end

function class.setDir(value)
  data.dir = value
end

function class.getSpeed()
  return data.speed
end

function class.setSpeed(value)
  data.speed = value
end

function class.getHpMax()
  return data.hpMax
end

function class.getHp()
  return data.hp
end

function class.setHp(value)
  data.hp = value
end

function class.getDash()
  return data.dash
end
function class.setWeapon(name, value)
  data[name] = value
end

function class.getWeapon(name)
  return data[name]
end

function class.isStuff()
  return data.stuff
end

function class.setLine(value)
  data.line = value
end

function class.setColumn(value)
  data.column = value
end

function class.setStun(value)
  data.stun = value
end

function class.getLine()
  return data.line  
end

function class.getColumn()
  return data.column
end

function class.getAlive()
  return data.alive
end

function class.getStamina()
  return data.stamina  
end

function class.isImmunity()
  return data.immunity
end

function class.setImmunity(value)
  data.immunity = value
end

function class.getAmmo()
  return data.ammo  
end

function class.getKill()
  return data.kill
end

function class.setKill(value)
  data.kill = value
end

function class.getTimePlayed()
  return data.timePlayed  
end

local function initPlayer()
  local actualRoom = dungeon.getActualRoom()

  data.line = actualRoom.line
  data.column = actualRoom.column

  data.sprite = images.getImage("playerSheet")
  data.w = 90
  data.h = 109
  data.x = screen.getWidth()/2
  data.y = 250
  data.r = data.h/2
  data.angle = math.rad(0)
  data.passiveTrigger = 600
  data.activeTrigger = 400
  data.lootTrigger = 200
  data.speed = 300
  data.speedMax = 1000
  data.hpMax = 200
  data.ammo = 0
  data.kill = 0
  data.timePlayed = 0
  data.hp = data.hpMax
  data.alive = true
  data.stamina = 100
  data.isMooving = false
  data.sprint = false
  data.dash = false
  data.notFire = true
  data.immunity = false
  data.isState = false
  data.stun = false
  data.stunTime = 0
  data.dir = "down"

  data.timerImmunity    = 0
  data.timerImmunityMax = 2
  data.timerState    = 0
  data.timerStateMax = 0.2

  data.animations = {}
  data.animations.up    = animation.new(data.sprite, 8, 10, 0, 0, data.w, data.h)
  data.animations.down  = animation.new(data.sprite, 8, 10, 0, data.h, data.w, data.h)
  data.animations.left  = animation.new(data.sprite, 6, 10, 0, data.h*2, data.w, data.h)
  data.animations.right = animation.new(data.sprite, 6, 10, 0, data.h*3, data.w, data.h)

  data.animations.staticUp    = animation.new(data.sprite, 6, 10, 0, data.h*4, data.w, data.h)
  data.animations.staticDown  = animation.new(data.sprite, 6, 10, 0, data.h*5, data.w, data.h)
  data.animations.staticLeft  = animation.new(data.sprite, 6, 10, 0, data.h*6, data.w, data.h)
  data.animations.staticRight = animation.new(data.sprite, 6, 10, 0, data.h*7, data.w, data.h)

  data.animations.death = animation.new(data.sprite, 12, 10, 0, data.h*8, data.w, data.h)

  data.stuff = false
  data.pistol = false
  data.weaponPistol = weapons.create("pistol", data.x, data.y)
  data.rifle = false
  data.weaponRifle = weapons.create("rifle", data.x, data.y)
  data.sniper = false
  data.weaponSniper = weapons.create("sniper", data.x, data.y)
  data.shotgun = false
  data.weaponShotgun = weapons.create("shotgun", data.x, data.y)
  data.snowX = false
  data.weaponSnowX = weapons.create("snowX", data.x, data.y)
  data.ray = false
  data.weaponRay = weapons.create("ray", data.x, data.y)
end

function class.load()
  initPlayer()
end

local function dash(dt)
  if (not data.stun) then
    if (love.keyboard.isDown('space')) then
      if data.stamina >= 100 then
        local soundDash = sounds.getSound("dash")
        soundDash:play()
        data.sprint = true
      end
    end
  end
  if (data.sprint) then
    data.dash = true
    data.speed = data.speedMax
    data.stamina = data.stamina - 500 * dt
    if data.stamina <= 0 then
      data.stamina = 0
      data.sprint = false
    end
  elseif (not data.sprint) then
    data.speed = 300
    data.stamina = data.stamina + 100 * dt
    data.dash = false
  end
  if (data.stamina >= 100) then
    data.stamina = 100
  end
end

local function movePlayer(dt)
  data.isMooving = false
  if (love.keyboard.isDown('z')) then
    data.y = data.y - data.speed * dt
    data.isMooving = true
    data.dir = "up"
    data.currentAnimation = data.animations.up
  end
  if (love.keyboard.isDown('s')) then
    data.y = data.y + data.speed * dt
    data.isMooving = true
    data.dir = "down"
    data.currentAnimation = data.animations.down
  end
  if (love.keyboard.isDown('q')) then
    data.x = data.x - data.speed * dt
    data.isMooving = true
    data.dir = "left"
    data.currentAnimation = data.animations.left
  end
  if (love.keyboard.isDown('d')) then
    data.x = data.x + data.speed * dt
    data.isMooving = true
    data.dir = "right"
    data.currentAnimation = data.animations.right
  end
  if data.isMooving then
    local soundWalk = sounds.getSound("walk")
    soundWalk:play()
  end
end

local function upAnimationDirection(dt)
  if (not data.isMooving) then
    if (data.dir == "up") then
      data.currentAnimation = data.animations.staticUp
    elseif (data.dir == "down") then
      data.currentAnimation = data.animations.staticDown
    elseif (data.dir == "left") then
      data.currentAnimation = data.animations.staticLeft
    elseif (data.dir == "right") then
      data.currentAnimation = data.animations.staticRight
    end
  end
  animation.update(data.currentAnimation, dt)
end

local function checkStun(dt)
  if (data.stun) then
    data.speed = data.speed/2
    data.stunTime = data.stunTime + 1 * dt
    if (data.stunTime > 4) then
      data.stun = false
      data.stunTime = 0
    end
  end
end

local function checkDeath(dt)
  if (data.hp <= 0) then
    data.alive = false
    data.currentAnimation = data.animations.death
    if (data.animations.death.currentFrame < 11) then
      animation.update(data.currentAnimation, dt)
    else
      data.animations.death.currentFrame = 12
      gameState.setState("over")
    end
  end
end

local function upWeapons(obj,dt)
  weapons.update(obj, data.x, data.y, data.notFire, true, dt)
  obj.angle = math.atan2(mouse.getY() - data.y, mouse.getX() - data.x)
  if mouse.getX() > data.x then
    obj.image = obj.right
  else
    obj.image = obj.left
  end
end

local function playerWeapon(dt)
  if love.mouse.isDown("1") then
    data.notFire = false
  else 
    data.notFire = true
  end
  if data.pistol then
    upWeapons(data.weaponPistol,dt)
    data.ammo = data.weaponPistol.ammo
    data.stuff = true
  elseif data.rifle then
    upWeapons(data.weaponRifle,dt)
    data.ammo = data.weaponRifle.ammo
    data.stuff = true
  elseif data.sniper then
    upWeapons(data.weaponSniper,dt)
    data.ammo = data.weaponSniper.ammo
    data.stuff = true
  elseif data.shotgun then
    upWeapons(data.weaponShotgun,dt)
    data.ammo = data.weaponShotgun.ammo
    data.stuff = true
  elseif data.snowX then
    upWeapons(data.weaponSnowX,dt)
    data.ammo = data.weaponSnowX.ammo
    data.stuff = true
  elseif data.ray then
    upWeapons(data.weaponRay,dt)
    data.ammo = data.weaponRay.ammo
    data.stuff = true
  else
    data.ammo = 0
    data.stuff = false
  end
end

local function respawn(dt)
  if (data.hp > 0) then
    if (not data.isImmunity) then
      data.timerImmunity = data.timerImmunity + dt
      if (not data.isState) then
        data.timerState = data.timerState + dt
        if (data.timerState > data.timerStateMax) then
          data.isState = true
          data.timerState = 0
        end
      else
        data.timerState = data.timerState + dt
        if (data.timerState > data.timerStateMax) then
          data.isState = false
          data.timerState = 0
        end
      end
      if (data.timerImmunity > data.timerImmunityMax) then
        data.immunity = false
        data.timerImmunity = 0
      end
    end
  end
end

local function upTimeplayed(dt)
  data.timePlayed =   data.timePlayed + 1 * dt
end

function class.update(dt)
  if (data.alive) then
    movePlayer(dt)
    dash(dt)
    playerWeapon(dt)
    upAnimationDirection(dt)
    checkStun(dt)
    respawn(dt)
    upTimeplayed(dt)
  end
  checkDeath(dt)
end

local function drawPlayer()
  if (not data.immunity) or (not data.isState) then
    love.graphics.setColor(1, 1, 1)
  else
    love.graphics.setColor(1, 0, 0)
  end
  animation.draw(data.currentAnimation, data.x, data.y, data.w, data.h)
--  love.graphics.rectangle("line",data.x - data.w/2,data.y-data.h/2,data.w,data.h)
--  love.graphics.rectangle("line",data.x - 20,data.y+30,data.w-50,data.h-85)
--  love.graphics.circle("line", data.x, data.y, data.passiveTrigger)
--  love.graphics.circle("line", data.x, data.y, data.activeTrigger)
--  love.graphics.circle("line", data.x, data.y, data.lootTrigger)
--  love.graphics.circle("line", data.x, data.y, data.r)
end

local function drawLife()
  if (data.hp > 0) then
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill",data.x - 25 , data.y - 78, data.hp/4, 10)
  end
  love.graphics.setColor(1,1,1)
  love.graphics.draw(images.getImage("lifePlayer"), data.x + 20 , data.y - 25, 0,1,1,data.w/2, data.h/2)
end

local function drawWeapons(bool, weapon)
  love.graphics.setColor(1,1,1)
  if data.alive then
    if bool then
      weapons.draw(weapon, data.x, data.y)
    end
  end
end

local function drawCurrentWeapon()
  drawWeapons(data.pistol, data.weaponPistol)
  drawWeapons(data.rifle, data.weaponRifle)
  drawWeapons(data.shotgun, data.weaponShotgun)
  drawWeapons(data.sniper, data.weaponSniper)
  drawWeapons(data.snowX, data.weaponSnowX)
  drawWeapons(data.ray, data.weaponRay)
end

function class.draw()
  if data.dir == "up" then
    drawCurrentWeapon()
    drawPlayer()
  else
    drawPlayer()
    drawCurrentWeapon()
  end
  drawLife()
end

function class.keypressed(key)
  weapons.keypressed(key, data.weaponPistol)  
  weapons.keypressed(key, data.weaponRifle)  
  weapons.keypressed(key, data.weaponShotgun)  
  weapons.keypressed(key, data.weaponSnowX)  
  weapons.keypressed(key, data.weaponRay)  
end

return class