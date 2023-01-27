local mouse = require("mouse")
local player = require("player")
local gameState = require("gameState")
local images = require("images")
local screen = require("screen")
local lootList = require("lootList")
local animation = require("animation")

local class = {}
local data = {}
local quit = {}

local font 

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

local function loadPlayerWin()
  data.spriteSheet = images.getImage("winSheet")
  data.x = screen.getWidth()/2 - 115
  data.y = screen.getHeight()/2 - 275
  data.timer = 0

  data.background = images.getImage("gameWin")
  data.animation = animation.new(data.spriteSheet, 9, 8, 0, 0, 221, 310)
end

function class.load()
  loadQuit()
  loadPlayerWin()
  font = love.graphics.newFont("Assets/Images/Font.ttf", 50)
end

local function selection(obj)
  return (mouse.getX() < obj.x + obj.w) and (mouse.getX() > obj.x) and (mouse.getY() > obj.y) and (mouse.getY() < obj.y + obj.h) 
end

local function changeImage(obj)
  if (selection(obj)) then
    obj.image = obj.selectedImage
    obj.isSelected = true
  else
    obj.image = obj.unselectedImage
    obj.isSelected = false
  end
end

local function updateAnimation(dt)
  if (data.animation.currentFrame < 9) then
    animation.update(data.animation, dt)
  else
    data.animation.currentFrame = 9
  end
end

function class.update(dt)
  changeImage(quit)
  updateAnimation(dt)
end

function class.draw()
  love.graphics.draw(data.background)
  love.graphics.draw(quit.image, quit.x, quit.y + 25) 
  love.graphics.setFont(font)
  love.graphics.print(" "..player.getKill(), 310, 390)
  love.graphics.print(" "..math.floor(player.getTimePlayed()), 310, 230)
  love.graphics.print(" "..lootList.getNumberCoins(), 310, 310)

  animation.draw(data.animation, data.x, data.y, 0, 0)
end

function class.keypressed(key)
  if (key == "escape") then
    gameState.setState("menu")
  end
end

function class.mousepressed(x,y,button)
  if (button == 1) then
    if (quit.isSelected) then
      gameState.setState("menu")
    end
  end
end

return class