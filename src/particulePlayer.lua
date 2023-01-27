local player = require("player")
local images = require("images")

local class = {}
local dataList = {}
local number

function class.getList()
  return dataList
end

local function createParticules()
  local data = {}

  data.red = images.getImage("particuleDashRed")
  data.blue = images.getImage("particuleDash")
  data.image = data.blue
  data.w = data.image:getWidth()/2
  data.h = data.image:getHeight()/2
  if player.getKill() < 10 then
    data.random = 5
    data.image = data.blue
  else
    data.random = 10
    data.image = data.red
  end
  data.x = love.math.random(-data.random,data.random) + player.getX()
  data.y = love.math.random(-data.random,data.random) +player.getY()
  data.angle = math.rad(0)
  data.speed = 50
  data.duration = 2
  table.insert(dataList, data)
end

function class.load()
  number = 1
end

function class.update(dt)

  if player.getKill() < 10 then
    number = 1
  else
    number = 2
  end

  if (player.getDash() == false) and player.getAlive() then
    for i = 1, number do
      createParticules()
    end
  end

  for dataId, data in ipairs(dataList) do
    if (player.getDir() == "down") then
      data.y = data.y  - data.speed * dt
    elseif (player.getDir() == "up") then
      data.y = data.y  - data.speed * dt
    elseif (player.getDir() == "left") then
      data.y = data.y  - data.speed * dt
    elseif (player.getDir() == "right") then
      data.y = data.y  - data.speed * dt
    end
    data.duration = data.duration - 10 * dt
    if (data.duration < 0) then
      table.remove(dataList, dataId)
    end
  end
end

function class.draw()
  for dataId, data in ipairs(dataList) do
    love.graphics.setColor(1, 1, 1, data.duration)

    love.graphics.draw(data.image, data.x - 20, data.y + 30, 0, 1, 1, data.w, data.h)
    love.graphics.draw(data.image, data.x + 20, data.y + 30, 0, 1, 1, data.w, data.h)
  end
  love.graphics.setColor(1, 1, 1, 1)

end

return class 