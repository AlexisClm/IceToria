local screen = require("screen")
local gameState = require("gameState")
local mouse = require("mouse")
local images = require("images")

local class = {}
local credits = {}
local quit = {}

local function selection(obj)
  return (mouse.getX() < obj.x + obj.w) and (mouse.getX() > obj.x) and (mouse.getY() > obj.y) and (mouse.getY() < obj.y + obj.h) 
end

local function loadCredits()
  credits.image = images.getImage("backgroundCredits")
  credits.x = 0 
  credits.y = 0
end

local function loadQuit()
  quit.unselectedImage = images.getImage("quit")
  quit.selectedImage = images.getImage("quitSelected")
  quit.image = quit.unselectedImage
  quit.w = quit.image:getWidth()
  quit.h = quit.image:getHeight()
  quit.x = quit.w/2
  quit.y = screen.getHeight() - quit.h*2
  quit.isSelected = false
end

function class.load()
  loadCredits()
  loadQuit()
end

local function changeImage(obj)
  if(selection(obj)) then
    obj.image = obj.selectedImage
    obj.isSelected = true
  else
    obj.image = obj.unselectedImage
    obj.isSelected = false
  end
end

function class.update(dt)
  changeImage(quit)
end

function class.draw()
  love.graphics.draw(credits.image, credits.x, credits.y)
  love.graphics.draw(quit.image, quit.x, quit.y + 25) 
end

function class.keypressed(key)
  if key == "escape" then
    gameState.setState("menu")
  end
end

function class.mousepressed(x,y,button)
  if button == 1 then
    if quit.isSelected then
      gameState.setState("menu")
    end
  end
end

return class