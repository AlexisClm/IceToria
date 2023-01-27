local screen = require("screen")

local class = {}
local dataList = {}
local timer = {}
local pas 
local snowMax 

local function creatSnow()
  local data =  {}
  data.w = 3
  data.h = 3
  data.x = love.math.random(screen.getWidth())
  data.y = -data.h
  data.speed = love.math.random( 100, 300)
  data.color = love.math.random(0.3,0.7)
  table.insert(dataList,data)
end

function class.update(dt)
  for dataId,data in ipairs(dataList) do
    data.y = data.y + data.speed * dt
    if data.y > screen.getHeight() then
      table.remove(dataList, dataId)
    end
    data.x = data.x + 100 * dt
    if data.x > screen.getWidth() then
      data.x = - data.w
    end
  end
  if #dataList <= 700 then
    for i = 1 ,1 do
      creatSnow()
    end
  end
end

function class.draw()
  for dataId,data in ipairs(dataList) do
    love.graphics.setColor(1,1,1,data.color)
    love.graphics.rectangle("fill", data.x, data.y, data.w, data.h)
  end
end

return class