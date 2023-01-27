local images = require("images")

local shootList = {}
local class = {}

function class.getShootList()
  return shootList
end

function class.resetShootList()
  shootList = {}
end

function class.create(weapon, angle)
  local shoot = {}
   if weapon.type == "pistol" then
    shoot.image     = images.getImage("pistolBall")
    shoot.speed     = weapon.speed
    shoot.range    = weapon.range
    shoot.dmg    = weapon.dmg
  elseif weapon.type == "rifle" then
    shoot.image     = images.getImage("rifleBall")
    shoot.speed     = weapon.speed
    shoot.range    = weapon.range
    shoot.dmg    = weapon.dmg
  elseif weapon.type == "shotgun" then
    shoot.image     = images.getImage("rifleBall")
    shoot.speed     = weapon.speed
    shoot.range    = weapon.range
    shoot.dmg    = weapon.dmg
  elseif weapon.type == "sniper" then
    shoot.image     = images.getImage("sniperBall")
    shoot.speed     = weapon.speed
    shoot.range    = weapon.range
    shoot.dmg    = weapon.dmg
  elseif weapon.type == "snowX" then
    shoot.image     = images.getImage("snowBall")
    shoot.speed     = weapon.speed
    shoot.range    = weapon.range
    shoot.dmg    = weapon.dmg
  elseif weapon.type == "ray" then
    shoot.image     = images.getImage("rayBall")
    shoot.speed     = weapon.speed
    shoot.range    = weapon.range
    shoot.dmg    = weapon.dmg
  end
  shoot.w         = shoot.image:getWidth()
  shoot.h         = shoot.image:getHeight()
  shoot.r         = shoot.h/2
  shoot.x         = weapon.x
  shoot.y         = weapon.y - 15
  shoot.angle     = angle
  shoot.speed     = weapon.speed
  table.insert(shootList, shoot)
end

function class.update(dt)
  for shootId, shoot in ipairs(shootList) do
    shoot.range = shoot.range - 1 * dt
    if shoot.range < 0 then
      table.remove(shootList, shootId)
    end
  end

  for shootId, shoot in ipairs(shootList) do
    shoot.x = shoot.x + math.cos(shoot.angle) * shoot.speed * dt
    shoot.y = shoot.y + math.sin(shoot.angle) * shoot.speed * dt
  end
end

function class.draw()
  for shootId, shoot in ipairs(shootList) do
    love.graphics.setColor(1,1,1)
    love.graphics.draw(shoot.image, shoot.x, shoot.y, shoot.angle, 1, 1, shoot.w/2, shoot.h/2)
--    love.graphics.rectangle("line", shoot.x, shoot.y, shoot.w, shoot.h)
  end
end

return class
