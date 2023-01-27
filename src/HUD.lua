local images = require("images")
local screen = require("screen")
local player = require("player")

local class = {}
local hud = {}

local function loadHUD()
  hud.image = images.getImage("HUD")
  hud.w = hud.image:getWidth()
  hud.h = hud.image:getHeight()
  hud.x = 0
  hud.y = screen.getHeight() - hud.h
  hud.ratioStamina = 5
  hud.ratioHp = 1.25
  hud.ratioAmmo = 0
end

function class.load()
  loadHUD()
end

local function drawDash()
  if player.getStamina() < 100 then
    love.graphics.setColor(1,0.2,0.2)
  else
    love.graphics.setColor(0,0.9,1)
  end
  love.graphics.rectangle("fill", hud.x + 20, hud.y + hud.h/2, player.getStamina() * hud.ratioStamina, 75)

end

local function drawHp()
  if player.getHp() > 0 then
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", hud.x + 25, hud.y + 20 , player.getHp() * hud.ratioHp, 75)
  end
end

local function drawAmmo()
  if player.getWeapon("pistol") then
    hud.ratioAmmo = 24
  elseif  player.getWeapon("rifle") then
    hud.ratioAmmo = 10.5
  elseif  player.getWeapon("shotgun") then
    hud.ratioAmmo = 20
  elseif  player.getWeapon("sniper") then
    hud.ratioAmmo = 175
  elseif  player.getWeapon("snowX") then
    hud.ratioAmmo = 33
  elseif  player.getWeapon("ray") then
    hud.ratioAmmo = 0.79
  else
    hud.ratioAmmo = 0
  end
  love.graphics.setColor(1,1,0)
  love.graphics.rectangle("fill", hud.x + 350, hud.y + 20 , player.getAmmo() * hud.ratioAmmo, 75)
end

function class.draw()
  drawHp()
  drawDash()
  drawAmmo()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(hud.image, hud.x , hud.y)

end

return class