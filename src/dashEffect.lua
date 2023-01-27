local player = require("player")
local images = require("images")

local class = {}
local dataList = {}

function class.getList()
  return dataList
end

function class.resetList()
  dataList = {}
end

local function createEffectDash()
  local data = {}
  data.dashU = images.getImage("dashU")
  data.dashD = images.getImage("dashD")
  data.dashL = images.getImage("dashL")
  data.dashR = images.getImage("dashR")

  if (player.getDir() == "down") then
    data.image = data.dashD
  elseif (player.getDir() == "up") then
    data.image = data.dashU
  elseif (player.getDir() == "left") then
    data.image = data.dashL
  elseif (player.getDir() == "right") then
    data.image = data.dashR
  end
  data.w = data.image:getWidth()/2
  data.h = data.image:getHeight()/2
  data.x = player.getX()
  data.y = player.getY()
  data.duration = 1
  table.insert(dataList, data)
end

function class.update(dt)
  if (player.getDash() == true) then
    createEffectDash()
  end

  for dataId, data in ipairs(dataList) do
    data.duration = data.duration - 1 * dt
    if (data.duration < 0) then
      table.remove(dataList, dataId)
    end
  end
end

function class.draw()
  for dataId, data in ipairs(dataList) do
    love.graphics.setColor(1, 1, 1, data.duration)
    love.graphics.draw(data.image, data.x, data.y - 10, 0, 1, 1, data.w, data.h)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return class
