local class = {}
local data = {}

function class.getImage(name)
  return data[name]
end

local function loadPlayer()
  data.playerSheet = love.graphics.newImage("Assets/Images/Players/PlayerSheet.png")
  data.ghostSheet  = love.graphics.newImage("Assets/Images/Players/GhostSheet.png")
  data.winSheet    = love.graphics.newImage("Assets/Images/Players/WinSheet.png")
  data.dashD       = love.graphics.newImage("Assets/Images/Players/DashD.png")
  data.dashL       = love.graphics.newImage("Assets/Images/Players/DashL.png")
  data.dashR       = love.graphics.newImage("Assets/Images/Players/DashR.png")
  data.dashU       = love.graphics.newImage("Assets/Images/Players/DashU.png")

  data.particuleDash    = love.graphics.newImage("Assets/Images/Players/ParticuleDash.png")
  data.particuleDashRed = love.graphics.newImage("Assets/Images/Players/ParticuleDashRed.png")
  data.lifePlayer       = love.graphics.newImage("Assets/Images/HUD/LifePlayer.png")
end

local function loadEnemies()
  data.enemySheet      = love.graphics.newImage("Assets/Images/Enemies/EnemySheet.png")
  data.enemyDeathSheet = love.graphics.newImage("Assets/Images/Enemies/EnemyDeathSheet.png")
  data.lifeEnemy       = love.graphics.newImage("Assets/Images/HUD/LifeEnemy.png")
end

local function loadEnemiesPong()
  data.enemyPongSheet = love.graphics.newImage("Assets/Images/Enemies/EnemyPongSheet.png")
  data.lifeEnemyPong  = love.graphics.newImage("Assets/Images/HUD/LifeEnemyPong.png")
end

local function loadWeapons()
  data.pistolR  = love.graphics.newImage("Assets/Images/Weapons/PistolR.png")
  data.pistolL  = love.graphics.newImage("Assets/Images/Weapons/PistolL.png")
  data.rifleR   = love.graphics.newImage("Assets/Images/Weapons/RifleR.png")
  data.rifleL   = love.graphics.newImage("Assets/Images/Weapons/RifleL.png")
  data.sniperR  = love.graphics.newImage("Assets/Images/Weapons/SniperR.png")
  data.sniperL  = love.graphics.newImage("Assets/Images/Weapons/SniperL.png")
  data.shotgunR = love.graphics.newImage("Assets/Images/Weapons/ShotgunR.png")
  data.shotgunL = love.graphics.newImage("Assets/Images/Weapons/ShotgunL.png")
  data.snowXR   = love.graphics.newImage("Assets/Images/Weapons/SnowXR.png")
  data.snowXL   = love.graphics.newImage("Assets/Images/Weapons/SnowXL.png")
  data.rayL     = love.graphics.newImage("Assets/Images/Weapons/RayL.png")
  data.rayR     = love.graphics.newImage("Assets/Images/Weapons/RayR.png")
end

local function loadShoot()
  data.snowBall   = love.graphics.newImage("Assets/Images/Weapons/SnowBall.png")
  data.pistolBall = love.graphics.newImage("Assets/Images/Weapons/PistolBall.png")
  data.rifleBall  = love.graphics.newImage("Assets/Images/Weapons/RifleBall.png")
  data.sniperBall = love.graphics.newImage("Assets/Images/Weapons/SniperBall.png")
  data.rayBall    = love.graphics.newImage("Assets/Images/Weapons/RayBall.png")
end

local function loadDivers()
  data.coinSheet         = love.graphics.newImage("Assets/Images/Divers/CoinSheet.png")
  data.coin              = love.graphics.newImage("Assets/Images/HUD/Coin.png")
  data.ballOptions       = love.graphics.newImage("Assets/Images/Menu/BallOptions.png")
  data.healSheet         = love.graphics.newImage("Assets/Images/Divers/HealSheet.png")
  data.chestSheet        = love.graphics.newImage("Assets/Images/Divers/ChestSheet.png")
  data.crosshair         = love.graphics.newImage("Assets/Images/HUD/Crosshair.png")
  data.pressE            = love.graphics.newImage("Assets/Images/HUD/PressE.png")
  data.reload            = love.graphics.newImage("Assets/Images/HUD/Reload.png")
  data.HUD               = love.graphics.newImage("Assets/Images/HUD/HUD.png")
  data.numberCoins       = love.graphics.newImage("Assets/Images/HUD/NumberCoins.png")
  data.backgroundMenu    = love.graphics.newImage("Assets/Images/Menu/BackgroundMenu.png")
  data.wiki              = love.graphics.newImage("Assets/Images/Menu/Wiki.png")
  data.play              = love.graphics.newImage("Assets/Images/Menu/Play.png")
  data.options           = love.graphics.newImage("Assets/Images/Menu/Options.png")
  data.backgroundOptions = love.graphics.newImage("Assets/Images/Menu/BackgroundOptions.png")
  data.credits           = love.graphics.newImage("Assets/Images/Menu/Credits.png")
  data.backgroundCredits = love.graphics.newImage("Assets/Images/Menu/BackgroundCredits.png")
  data.quit              = love.graphics.newImage("Assets/Images/Menu/Quit.png")
  data.playSelected      = love.graphics.newImage("Assets/Images/Menu/PlaySelected.png")
  data.wikiSelected      = love.graphics.newImage("Assets/Images/Menu/WikiSelected.png")
  data.optionSelected    = love.graphics.newImage("Assets/Images/Menu/OptionsSelected.png")
  data.creditsSelected   = love.graphics.newImage("Assets/Images/Menu/CreditsSelected.png")
  data.quitSelected      = love.graphics.newImage("Assets/Images/Menu/QuitSelected.png")
  data.off               = love.graphics.newImage("Assets/Images/Menu/Off.png")
  data.parchemin         = love.graphics.newImage("Assets/Images/Divers/Parchemin.png")
  data.parcheminControls = love.graphics.newImage("Assets/Images/HUD/ParcheminControls.png")
  data.gameOver          = love.graphics.newImage("Assets/Images/Menu/GameOver.png")
  data.gameWin           = love.graphics.newImage("Assets/Images/Menu/GameWin.png")
  data.backgroundWiki    = love.graphics.newImage("Assets/Images/Menu/BackgroundWiki.png")
end

local function loadDoors()
  data.openDoorU = love.graphics.newImage("Assets/Images/Divers/OpenDoorU.png")
  data.openDoorD = love.graphics.newImage("Assets/Images/Divers/OpenDoorD.png")
  data.openDoorL = love.graphics.newImage("Assets/Images/Divers/OpenDoorL.png")
  data.openDoorR = love.graphics.newImage("Assets/Images/Divers/OpenDoorR.png")

  data.up    = love.graphics.newImage("Assets/Images/Divers/Door.png")
  data.left  = love.graphics.newImage("Assets/Images/Divers/DoorL.png")
  data.right = love.graphics.newImage("Assets/Images/Divers/DoorR.png")
  
  data.iconDoorU = love.graphics.newImage("Assets/Images/Dungeon/DoorIconU.png")
  data.iconDoorD = love.graphics.newImage("Assets/Images/Dungeon/DoorIconD.png")
  data.iconDoorL = love.graphics.newImage("Assets/Images/Dungeon/DoorIconL.png")
  data.iconDoorR = love.graphics.newImage("Assets/Images/Dungeon/DoorIconR.png")
end

local function loadDungeon()
  data.start       = love.graphics.newImage("Assets/Images/Dungeon/Start.png")
  data.using       = love.graphics.newImage("Assets/Images/Dungeon/Using.png")
  data.used        = love.graphics.newImage("Assets/Images/Dungeon/Used.png")
  data.iconMiniMap = love.graphics.newImage("Assets/Images/Dungeon/CharaIcon.png")
end

function class.load()
  loadPlayer()
  loadEnemies()
  loadEnemiesPong()
  loadWeapons()
  loadShoot()
  loadDivers()
  loadDoors()
  loadDungeon()
end

return class