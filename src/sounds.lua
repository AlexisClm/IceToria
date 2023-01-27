local gameState = require("gameState")

local class = {}
local data = {}

function class.getSound(name)
  return data[name]
end

function class.getMasterVolume()
return data.masterVolume  
end

function class.setMasterVolume(value)
  data.masterVolume = value
  end

local function loadMusics()
  data.musicMenu = love.audio.newSource("Assets/Songs/Menu.mp3", "stream")
  data.musicGame = love.audio.newSource("Assets/Songs/Game.mp3", "stream")
end

local function loadSoundWeapons()
  data.switch = love.audio.newSource("Assets/Songs/Switch.mp3", "static")
  data.fireRealist = love.audio.newSource("Assets/Songs/Fire.mp3", "static")
  data.fire = love.audio.newSource("Assets/Songs/Fire1.mp3", "static") 
  data.fireShotgun = love.audio.newSource("Assets/Songs/FirePompe.mp3", "static") 
  data.fireSniper = love.audio.newSource("Assets/Songs/FireSniper.mp3", "static") 
  data.fireSnowX = love.audio.newSource("Assets/Songs/FireSnowX.mp3", "static") 
  data.fireRay = love.audio.newSource("Assets/Songs/Ray.mp3", "static") 
  data.reload = love.audio.newSource("Assets/Songs/Reload.mp3", "static") 
  data.reloadPompe = love.audio.newSource("Assets/Songs/ReloadPompe.mp3", "static") 
end

local function loadHit()
    data.playerHit = love.audio.newSource("Assets/Songs/PlayerHit.mp3", "static") 
    data.enemyHit = love.audio.newSource("Assets/Songs/EnemyHit.mp3", "static") 

end

local function loadMisc()
  data.click = love.audio.newSource("Assets/Songs/Click.mp3", "static")
  data.dash = love.audio.newSource("Assets/Songs/Dash.mp3", "static")
  data.walk = love.audio.newSource("Assets/Songs/Walk.mp3", "static")
end

function class.load()
  data.masterVolume = 0.4
  loadMusics()
  loadSoundWeapons()
  loadMisc()
  loadHit()
end

local function upMusic()
  if gameState.getState() == "menu" or gameState.getState() == "options" or gameState.getState() == "credtis" then
    data.musicMenu:play()
    data.musicGame:stop()
  elseif  gameState.getState() == "game" or gameState.getState() == "pause" then
    data.musicMenu:stop()
    data.musicGame:play()
  end
end

function class.update(dt)
  love.audio.setVolume(data.masterVolume)
  upMusic() 
end

function class.mousepressed(x,y,button)
  if button == 1 then
    if gameState.getState() ~= "game" then
      data.click:play()
    end
  end
end

return class