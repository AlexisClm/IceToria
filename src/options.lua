local screen = require("screen")
local gameState = require("gameState")
local mouse = require("mouse")
local images = require("images")
local sounds = require("sounds")

local class = {}
local option = {}
local buttons = {}
local volume = {}
local volumeButton = {}
local upVolume = {}
local downVolume = {}
local quit = {}

local function selection(obj)
  return (mouse.getX() < obj.x + obj.w) and (mouse.getX() > obj.x) and (mouse.getY() > obj.y) and (mouse.getY() < obj.y + obj.h) 
end

function class.getShowFPS()
  return buttons.fps   
end

function class.getFontFPS()
  return buttons.font   
end

local function loadVolume()
  volume.w = 1550
  volume.h = 490
  volume.x = 1017
  volume.y = volume.h

  downVolume.w = 50
  downVolume.h = 50
  downVolume.x = volume.x 
  downVolume.y = volume.y - downVolume.w/2

  upVolume.w = 50
  upVolume.h = 50
  upVolume.x = volume.w 
  upVolume.y = volume.y - upVolume.h/2 

  volumeButton.image = images.getImage("ballOptions")
  volumeButton.w =  volumeButton.image:getWidth()
  volumeButton.h =  volumeButton.image:getHeight()
  volumeButton.x = downVolume.x + downVolume.w + 10 + sounds.getMasterVolume()*350
  volumeButton.y = volume.y -  volumeButton.image:getHeight()/2
end

local function loadOptions()
  option.image = images.getImage("backgroundOptions")
  option.x = 0
  option.y = 0

end

local function loadButton()
  buttons.image = images.getImage("off")
  buttons.w = buttons.image:getWidth()
  buttons.h = buttons.image:getHeight()
  buttons.x = 1260
  buttons.y = 685
  buttons.is = 0
  buttons.fps = false
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
  buttons.font = love.graphics.newFont(15)
  loadOptions()
  loadQuit()
  loadButton()
  loadVolume()
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

function class.update(dt)
  changeImage(quit)
  volumeButton.x = downVolume.x + downVolume.w + 10 + sounds.getMasterVolume()*350
end

local function drawButton()
  love.graphics.setColor(1,1,1,buttons.is)
  love.graphics.draw(buttons.image, buttons.x, buttons.y + 25) 
end

local function drawVolume()
  love.graphics.setColor(1,1,1,1)
--  love.graphics.line(volume.x, volume.y + 25, volume.w ,volume.h + 25) 
  love.graphics.draw(volumeButton.image, volumeButton.x , volumeButton.y + 25) 
--  love.graphics.rectangle("fill",upVolume.x, upVolume.y + 25, upVolume.w ,upVolume.h) 
--  love.graphics.rectangle("fill",downVolume.x, downVolume.y + 25, downVolume.w ,downVolume.h) 
end

function class.draw()
  love.graphics.draw(option.image)
  love.graphics.draw(quit.image, quit.x, quit.y + 25) 
  drawButton()
  drawVolume()
end

function class.keypressed(key)
  if key == "escape" then
    gameState.setState("menu")
  end
end

local function buttonFps()
  if selection(buttons) then
    buttons.is = buttons.is + 1
    if buttons.is > 1 then
      buttons.is = 0
    end
    if buttons.is == 1 then
      buttons.fps = true
    else
      buttons.fps = false
    end
  end
end

local function buttonVolume()
  if selection(upVolume) and sounds.getMasterVolume() < 1 then
    sounds.setMasterVolume(sounds.getMasterVolume() + 0.1)
  elseif selection(downVolume) and sounds.getMasterVolume() > 0.1 then
    sounds.setMasterVolume(sounds.getMasterVolume() - 0.1)
  end
end

function class.mousepressed(x,y,button)
  if button == 1 then
    buttonFps()
    buttonVolume()
    if quit.isSelected then
      gameState.setState("menu")
    end
  end
end

return class