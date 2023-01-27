local screen = require("screen")
local mouse = require("mouse")
local images = require("images")
local sounds = require("sounds")
local gameState = require("gameState")
local menu = require("menu")
local wiki = require("wiki")
local options = require("options")
local credits = require("credits")
local game = require("game")
local pause = require("pause")
local win = require("win")
local over = require("over")

-- Debug--
--if (arg[#arg] == "-debug") then
--  require("mobdebug").start()
--  print("Mode Debug")
--end

function love.load()
  gameState.setState("menu")
  screen.load()
  sounds.load()
  images.load()
  mouse.load()
  menu.load()
  options.load()
  credits.load()
  wiki.load()
end

function love.update(dt)
  if (gameState.getState() == "game") then
    game.update(dt)
  elseif (gameState.getState() == "menu") then
    menu.update(dt)
  elseif (gameState.getState() == "options") then
    options.update(dt)
  elseif (gameState.getState() == "credits") then
    credits.update(dt)
  elseif (gameState.getState() == "wiki") then
    wiki.update(dt)
  elseif (gameState.getState() == "win") then
    win.update(dt)
  elseif (gameState.getState() == "over") then
    over.update(dt)
  end
  love.mouse.setVisible(false)
  sounds.update(dt)
end

function love.draw()
  if (gameState.getState() == "game") or (gameState.getState() == "pause") then
    game.draw()
    if (gameState.getState() == "pause") then
      pause.draw()
    end
  elseif (gameState.getState() == "menu") then
    menu.draw()
  elseif (gameState.getState() == "options") then
    options.draw()
  elseif (gameState.getState() == "credits") then
    credits.draw()
  elseif (gameState.getState() == "wiki") then
    wiki.draw()
  elseif (gameState.getState() == "win") then
    win.draw()
  elseif (gameState.getState() == "over") then
    over.draw()
  end
  mouse.draw()

  if (options.getShowFPS()) then
    love.graphics.setFont(options.getFontFPS())
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  end
end

function love.keypressed(key)
  if (gameState.getState() == "game") then
    game.keypressed(key)
  elseif (gameState.getState() == "menu") then
    menu.keypressed(key)
  elseif (gameState.getState() == "options") then
    options.keypressed(key)
  elseif (gameState.getState() == "credits") then
    credits.keypressed(key)
  elseif (gameState.getState() == "wiki") then
    wiki.keypressed(key)
  elseif  (gameState.getState() == "pause") then
    pause.keypressed(key)
  elseif (gameState.getState() == "win") then
    win.keypressed(key)
  elseif (gameState.getState() == "over") then
    over.keypressed(key)
  end
end

function love.mousepressed(x, y, button)
  if (gameState.getState() == "menu") then
    menu.mousepressed(x,y,button)
  elseif (gameState.getState() == "options") then
    options.mousepressed(x,y,button)
  elseif (gameState.getState() == "credits") then
    credits.mousepressed(x,y,button)
  elseif (gameState.getState() == "wiki") then
    wiki.mousepressed(x,y,button)
  elseif (gameState.getState() == "pause") then
    pause.mousepressed(x,y,button)
  elseif (gameState.getState() == "win") then
    win.mousepressed(x,y,button)
  elseif (gameState.getState() == "over") then
    over.mousepressed(x,y,button)
  end
  sounds.mousepressed(x,y,button)
end

function love.mousemoved(x, y)
  mouse.mousemoved(x,y)
end