local screen = require("screen")
local images = require("images")
local sounds = require("sounds")
local shootPlayer = require("shootPlayer")
local shootEnemy = require("shootEnemy")

local class = {}

function class.create(type, x, y)
  local weapon = {}

  weapon.type = type

  if (type == "rifle") then
    weapon.sound = sounds.getSound("fire")
    weapon.soundReload = sounds.getSound("reload")
    weapon.left     =  images.getImage("rifleL")
    weapon.right     =  images.getImage("rifleR")
    weapon.image     = weapon.right
    weapon.fireReset = 0.3
    weapon.fireRate  = 0.1
    weapon.speed     = 600
    weapon.range = 5
    weapon.dmg = 10
    weapon.ammoMax = 15
    weapon.ammo = weapon.ammoMax
    weapon.reloadReset = 2
    weapon.reloadTime = 1
    weapon.reload = weapon.reloadReset

  elseif (type == "pistol") then
    weapon.soundReload = sounds.getSound("reload")
    weapon.sound = sounds.getSound("fire")
    weapon.left     = images.getImage("pistolL")
    weapon.right     = images.getImage("pistolR")
    weapon.image     = weapon.right
    weapon.fireReset = 0.5
    weapon.fireRate  = 0.1
    weapon.speed     = 350
    weapon.range = 5
    weapon.dmg = 15
    weapon.ammoMax = 7
    weapon.ammo = weapon.ammoMax
    weapon.reloadReset = 2
    weapon.reloadTime = 3
    weapon.reload = weapon.reloadReset

  elseif (type == "sniper") then
    weapon.soundReload = sounds.getSound("reload")
    weapon.sound = sounds.getSound("fireSniper")
    weapon.left     = images.getImage("sniperL")
    weapon.right     = images.getImage("sniperR")
    weapon.image     = weapon.right
    weapon.fireReset = 0
    weapon.fireRate  = 0.1
    weapon.speed     = 1500
    weapon.range = 5
    weapon.dmg = 100
    weapon.ammoMax = 1
    weapon.ammo = weapon.ammoMax
    weapon.reloadReset = 2
    weapon.reloadTime = 0.5
    weapon.reload = weapon.reloadReset

  elseif (type == "shotgun") then
    weapon.soundReload = sounds.getSound("reloadPompe")
    weapon.sound = sounds.getSound("fireShotgun")
    weapon.left     = images.getImage("shotgunL")
    weapon.right     = images.getImage("shotgunR")
    weapon.image     = weapon.right
    weapon.fireReset = 0.6
    weapon.fireRate  = 0.1
    weapon.speed     = 750
    weapon.range = 0.5
    weapon.dmg = 5
    weapon.ammoMax = 8
    weapon.ammo = weapon.ammoMax
    weapon.reloadReset = 2
    weapon.reloadTime = 1.5
    weapon.reload = weapon.reloadReset

  elseif (type == "snowX") then
    weapon.soundReload = sounds.getSound("reload")
    weapon.sound = sounds.getSound("fireSnowX")
    weapon.left     = images.getImage("snowXL")
    weapon.right     = images.getImage("snowXR")
    weapon.image     = weapon.right
    weapon.fireReset = 0.4
    weapon.fireRate  = 0.1
    weapon.speed     = 0
    weapon.range = 5
    weapon.dmg = 20
    weapon.ammoMax = 5
    weapon.ammo = weapon.ammoMax
    weapon.reloadReset = 2
    weapon.reloadTime = 0.90
    weapon.reload = weapon.reloadReset

  elseif (type == "ray") then
    weapon.soundReload = sounds.getSound("reload")
    weapon.sound = sounds.getSound("fireRay")
    weapon.left     = images.getImage("rayL")
    weapon.right     = images.getImage("rayR")
    weapon.image     = weapon.right
    weapon.fireReset = -1
    weapon.fireRate  = 0.1
    weapon.speed     = 1000
    weapon.range = 5
    weapon.dmg = 1
    weapon.ammoMax = 200
    weapon.ammo = weapon.ammoMax
    weapon.reloadReset = 2
    weapon.reloadTime = 0.75
    weapon.reload = weapon.reloadReset
  end

  weapon.w      = weapon.image:getWidth()
  weapon.h      = weapon.image:getHeight()
  weapon.x      = x - 20
  weapon.y      = y
  weapon.angle  = math.rad(0)
  weapon.isFire = false

  return weapon 
end

local function shootShotgun(obj, weapon)
  obj.create(weapon, weapon.angle - math.rad(20))
  obj.create(weapon, weapon.angle - math.rad(10))
  obj.create(weapon, weapon.angle - math.rad(5))
  obj.create(weapon, weapon.angle)
  obj.create(weapon, weapon.angle + math.rad(5))
  obj.create(weapon, weapon.angle + math.rad(10))
  obj.create(weapon, weapon.angle + math.rad(20))
end

local function reloadAmmo(weapon, bool, dt)
  if weapon.ammo <= 0 then
    weapon.reload = weapon.reload - weapon.reloadTime * dt
    if bool == true then
      weapon.soundReload:play()
    end
    if weapon.reload < 0 then
      weapon.ammo = weapon.ammoMax
      weapon.reload = weapon.reloadReset
    end
  end
end

local function soundWeapons(weapon, bool)
  if bool == true then
    if weapon.fireRate <= 0 and weapon.ammo > 0 then
      if love.mouse.isDown("1") then
        local soundClone = weapon.sound:clone()
        soundClone:play()
      end
    end
  end
end

function class.update(weapon, x, y, value, bool, dt)
  weapon.x = x
  weapon.y = y + 25
  if bool == false then
    if weapon.type == "sniper" then
      weapon.fireRate = weapon.fireRate - 0.1 * dt
    else
      weapon.fireRate = weapon.fireRate - 1 * dt
    end
  else
    weapon.fireRate = weapon.fireRate - 1 * dt
  end
  soundWeapons(weapon, bool)
  if (weapon.isFire == value) then
    if (weapon.fireRate < 0) then
      if weapon.type ~= "axe" then
        if (weapon.ammo > 0) then
          if (bool == true) then
            if weapon.type == "shotgun" then
              shootShotgun(shootPlayer, weapon)
              weapon.ammo =  weapon.ammo - 1
            else
              shootPlayer.create(weapon, weapon.angle)
              weapon.ammo =  weapon.ammo - 1
            end
          else
            if weapon.type == "shotgun" then
              shootShotgun(shootEnemy, weapon)
              weapon.ammo =  weapon.ammo - 1
            else
              shootEnemy.create(weapon, weapon.angle)
              weapon.ammo =  weapon.ammo - 1
            end
          end
        end
      end
      weapon.fireRate = weapon.fireReset
    end
  end
  reloadAmmo(weapon, bool, dt)
end

function class.draw(weapon, x, y)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(weapon.image, x , y + 25, weapon.angle, 1, 1, weapon.w/2, weapon.h/2)
  if weapon.ammo <= 0 then
    love.graphics.setColor(1,1,0)
    love.graphics.rectangle("fill",weapon.x - 25 , weapon.y - 90, weapon.reload * 25, 10)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(images.getImage("reload"), weapon.x - 25 , weapon.y - 90)
  end
end

function class.keypressed(key, weapon)
  if key == "r" then
    if weapon.ammo < weapon.ammoMax then
      weapon.ammo = 0
      weapon.soundReload:play()
    end
  end
end

return class