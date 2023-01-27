local class = {}

local data = {}


function class.setWidth(width)
  data.w = width
end
function class.getWidth()
  return data.w
end

function class.setHeight(height)
  data.h = height
end
function class.getHeight()
  return data.h
end

function class.load()
  data.w = love.graphics.getWidth()
  data.h = love.graphics.getHeight()
end

return class