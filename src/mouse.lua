local images = require("images")

local class = {}
local data = {}

function class.getPoint()
  local hitbox = {}
  hitbox.x = data.x
  hitbox.y = data.y
  return hitbox
end

function class.getX()
  return data.x  
end
function class.getY()
  return data.y
end

function class.load()
  data.image = images.getImage("crosshair")
  data.w     = data.image:getWidth()
  data.h     = data.image:getHeight()
  data.x     = 0
  data.y     = 0
end

function class.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(data.image, data.x, data.y + 25 , 0, 1, 1, data.w/2, data.h/2)
end

function class.mousemoved(x, y)
  data.x = x
  data.y = y
end

return class