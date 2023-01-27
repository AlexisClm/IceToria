local screen = require("screen")
local player = require("player")
local dungeon = require("dungeon")
local images = require("images")
local enemy = require("enemy")
local enemyPong = require("enemyPong")

local data = {}
local class = {}

function class.getHitbox()
  local hitbox = {}
  hitbox.w = data.w
  hitbox.h = data.h
  hitbox.isUpX = data.isUpX
  hitbox.isUpY = data.isUpY
  hitbox.isDownX = data.isDownX
  hitbox.isDownY = data.isDownY
  hitbox.isLeftX = data.isLeftX
  hitbox.isLeftY = data.isLeftY
  hitbox.isRightX = data.isRightX
  hitbox.isRightY = data.isRightY

  return hitbox
end

function class.load()
  data.size = 111
  data.w = 111
  data.h = 111
  data.isUpX = screen.getWidth()/2 - data.w/2
  data.isUpY = 0
  data.isDownX = screen.getWidth()/2 - data.w/2
  data.isDownY = screen.getHeight() - data.h/2-1
  data.isLeftX = ((data.size/2) - data.w) -16
  data.isLeftY = screen.getHeight()/2 - data.h/2
  data.isRightX = (screen.getWidth() - data.w/2)+16
  data.isRightY = screen.getHeight()/2 - data.h/2  
end

function class.draw()
  if (enemy.getNbEnemy() == 0) and (enemyPong.getNbEnemy() == 0) and (player.isStuff()) then
    if (dungeon.isDoorUp(player.getLine(), player.getColumn())) then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(images.getImage("openDoorU"), data.isUpX-25, data.isUpY+55, 0, 1, 1, data.w/18, data.h/20)
    end
    if (dungeon.isDoorDown(player.getLine(), player.getColumn())) then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(images.getImage("openDoorD"), data.isDownX-25, data.isDownY-130, 0, 1, 1, data.w/20, data.h/3)   
    end
    if (dungeon.isDoorLeft(player.getLine(), player.getColumn())) then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(images.getImage("openDoorL"), data.isLeftX+183, data.isLeftY-85, 0, 1, 1, data.w/2, data.h/20)
    end
    if (dungeon.isDoorRight(player.getLine(), player.getColumn())) then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(images.getImage("openDoorR"), data.isRightX-191, data.isRightY-85, 0, 1, 1, data.w/2, data.h/20)
    end

  else
    if (dungeon.isDoorUp(player.getLine(), player.getColumn())) then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(images.getImage("up"), data.isUpX-25, data.isUpY+55, 0, 1, 1, data.w/18, data.h/20)
    end
    if (dungeon.isDoorLeft(player.getLine(), player.getColumn())) then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(images.getImage("left"), data.isLeftX+183, data.isLeftY-85, 0, 1, 1, data.w/2, data.h/20)
    end
    if (dungeon.isDoorRight(player.getLine(), player.getColumn())) then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(images.getImage("right"), data.isRightX + 8, data.isRightY-85, 0, 1, 1, data.w/2, data.h/20)
    end
  end       
end

return class