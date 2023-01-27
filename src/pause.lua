local screen = require("screen")
local gameState = require("gameState")

local class = {}
local pause = {}
local exit = {}
local menu = {}

local function selection(a, x, y)
  return (x < a.x + a.w) and (x > a.x) and (y > a.y) and (y < a.y + a.h)
end

function class.load()
  pause.font = love.graphics.newFont("Assets/Images/Font.ttf", 50)
  pause.x = 864
  pause.y = 350

  menu.x = 500
  menu.y = 700
  menu.w = 200
  menu.h = 80

  exit.x = 1200
  exit.y = 700
  exit.w = 190
  exit.h = 80
end

function class.draw()
  love.graphics.setColor(0, 0, 0, 0.7)
  love.graphics.rectangle("fill", 0, 0, screen.getWidth(), screen.getHeight())
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.setFont(pause.font)
  love.graphics.printf("PAUSE", pause.x, pause.y, screen.getWidth(), 'left')
  love.graphics.printf("MENU", menu.x + 10, menu.y + 30, screen.getWidth(), 'left')
  love.graphics.rectangle("line", menu.x, menu.y+25, menu.w, menu.h)
  love.graphics.printf("EXIT", exit.x + 15, exit.y + 30, screen.getWidth(), 'left')
  love.graphics.rectangle("line", exit.x, exit.y+25, exit.w, exit.h)
end

function class.keypressed(key)
  if (key == "escape") then
    gameState.setState("game")
  end
end

function class.mousepressed(x, y, button)
  if (selection(menu, x, y)) and (button == 1) then
    gameState.setState("menu")
  elseif (selection(exit, x, y)) and (button == 1) then
    love.event.quit()
  end
end

return class