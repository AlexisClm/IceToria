local screen = require("screen")
local gameState = require("gameState")
local mouse = require("mouse")
local images = require("images")
local sounds = require("sounds")
local game = require("game")

local class = {}

local menu = {}
local play = {}
local options = {}
local credits = {}
local quit = {}
local button = {}
local wiki = {}

local function selection(obj)
  return (mouse.getX() < obj.x + obj.w) and (mouse.getX() > obj.x) and (mouse.getY() > obj.y) and (mouse.getY() < obj.y + obj.h) 
end

local function loadMenu()
  menu.menuImage = images.getImage("backgroundMenu")
  menu.x = 0
  menu.y = 0
 
  button.between = 100
  button.x = screen.getWidth()/2 - button.between/2
  button.y = screen.getHeight()/2
end

local function loadPlay()
  play.unselectedImage = images.getImage("play")
  play.selectedImage = images.getImage("playSelected")
  play.image = play.unselectedImage
  play.w = play.image:getWidth()
  play.h = play.image:getHeight()
  play.x = screen.getWidth()/2 - button.between/2
  play.y = screen.getHeight()/2 - button.between
  play.isSelected = false
end

local function loadOptions()
  options.unselectedImage = images.getImage("options")
  options.selectedImage = images.getImage("optionSelected")
  options.image = options.unselectedImage
  options.w = options.image:getWidth()
  options.h = options.image:getHeight()
  options.x = screen.getWidth()/2 - button.between/2
  options.y = screen.getHeight()/2 + button.between
  options.isSelected = false
end

local function loadCredits()
  credits.unselectedImage = images.getImage("credits")
  credits.selectedImage = images.getImage("creditsSelected")
  credits.image = credits.unselectedImage
  credits.w = credits.image:getWidth()
  credits.h = credits.image:getHeight()
  credits.x = screen.getWidth()/2 - button.between/2
  credits.y =  screen.getHeight()/2 + button.between*2
  credits.isSelected = false
end

local function loadQuit()
  quit.unselectedImage = images.getImage("quit")
  quit.selectedImage = images.getImage("quitSelected")
  quit.image = quit.unselectedImage
  quit.w = quit.image:getWidth()
  quit.h = quit.image:getHeight()
  quit.x = screen.getWidth()/2 - button.between/2
  quit.y = screen.getHeight()/2 + button.between*3
  quit.isSelected = false
end

local function loadWiki()
  wiki.unselectedImage = images.getImage("wiki")
  wiki.selectedImage = images.getImage("wikiSelected")
  wiki.image = wiki.unselectedImage
  wiki.w = wiki.image:getWidth()
  wiki.h = wiki.image:getHeight()
  wiki.x = screen.getWidth()/2 - button.between/2
  wiki.y = screen.getHeight()/2 
  wiki.isSelected = false
end

function class.load()
  loadMenu()
  loadPlay()
  loadOptions()
  loadCredits()
  loadQuit()
  loadWiki()
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
  changeImage(play)
  changeImage(options)
  changeImage(credits)
  changeImage(quit)
  changeImage(wiki)
end

local function drawSameImage(name)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(name.image, name.x, name.y + 25) 
end

function class.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(menu.menuImage, menu.x, menu.y) 
  drawSameImage(play)
  drawSameImage(options)
  drawSameImage(credits)
  drawSameImage(quit)
  drawSameImage(wiki)
end

function class.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function class.mousepressed(x, y, button)
  if button == 1 then
    sounds.getSound("click"):play()
    if play.isSelected then
      gameState.setState("game")
      game.load()
    elseif options.isSelected then
      gameState.setState("options")
    elseif credits.isSelected then
      gameState.setState("credits")
      elseif wiki.isSelected then
      gameState.setState("wiki")
    elseif quit.isSelected then
      love.event.quit()
    end
  end
end

return class