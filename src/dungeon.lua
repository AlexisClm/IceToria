local screen = require("screen")
local mapManager = require("mapManager")
local images = require("images")

local map = {}
local availableRooms = {}
local actualRoom = {}

local function loadSettings()
  map.lines = 5
  map.columns = 6
  map.roomRate = 0.8
  map.rooms = math.floor(map.lines*map.columns*map.roomRate)
  map.roomWidth = 40
  map.roomHeight = 40
  map.spacing = 4
  map.x = screen.getWidth()/2 + 600
  map.y = 50
  map.doorSize = 13
end

local function initMap()
  map.data = {}
  availableRooms = {}

  for line = 1, map.lines do
    map.data[line] = {}
    for column = 1, map.columns do
      map.data[line][column] = {}
      local room = map.data[line][column]
      room.isFree = true
      room.isUsing = false
      room.isUsed = false
      room.isCleared = false
      room.distance = 0
      room.isDoorUp = false
      room.isDoorDown = false
      room.isDoorLeft = false
      room.isDoorRight = false
      room.map = nil
    end
  end
end

local function addStartingRoom()
  local randomLine = love.math.random(map.lines)
  local randomColumn = love.math.random(map.columns)
  local startingRoom = map.data[randomLine][randomColumn]

  startingRoom.isFree = false
  startingRoom.map = mapManager.getRandomMap()
  actualRoom = {line = randomLine, column = randomColumn}

  table.insert(availableRooms, actualRoom)
end

local function cellIsAvailable(line, column)
  return (line >= 1) and (line <= map.lines) and (column >= 1) and (column <= map.columns)
end

local function roomIsFree(line, column)
  return cellIsAvailable(line, column) and map.data[line][column].isFree
end

local function getRandomDirection(room)
  local availableDirections = {}

  if (roomIsFree(room.line-1, room.column)) then
    table.insert(availableDirections, "Up")
  end
  if (roomIsFree(room.line+1, room.column)) then
    table.insert(availableDirections, "Down")
  end
  if (roomIsFree(room.line, room.column-1)) then
    table.insert(availableDirections, "Left")
  end
  if (roomIsFree(room.line, room.column+1)) then
    table.insert(availableDirections, "Right")
  end

  local randomDirection = availableDirections[love.math.random(#availableDirections)]

  return randomDirection
end

local function getNextRandomRoom(room, direction)
  local nextRoom = {line = room.line, column = room.column}

  if (direction == "Up") then
    nextRoom.line = nextRoom.line-1
  elseif (direction == "Down") then
    nextRoom.line = nextRoom.line+1
  elseif (direction == "Left") then
    nextRoom.column = nextRoom.column-1
  elseif (direction == "Right") then
    nextRoom.column = nextRoom.column+1
  end

  return nextRoom
end

local function checkAvailableRooms()
  for availableRoomId = #availableRooms, 1, -1 do
    local availableRoom = availableRooms[availableRoomId]
    if (getRandomDirection(availableRoom) == nil) then
      table.remove(availableRooms, availableRoomId)
    end
  end
end

local function addDoors(room, direction)
  if (direction == "Up") then
    map.data[room.line][room.column].isDoorUp = true
    map.data[room.line-1][room.column].isDoorDown = true
  elseif (direction == "Down") then
    map.data[room.line][room.column].isDoorDown = true
    map.data[room.line+1][room.column].isDoorUp = true
  elseif (direction == "Left") then
    map.data[room.line][room.column].isDoorLeft = true
    map.data[room.line][room.column-1].isDoorRight = true
  elseif (direction == "Right") then
    map.data[room.line][room.column].isDoorRight = true
    map.data[room.line][room.column+1].isDoorLeft = true
  end
end

local function addRoom()
  local selectedRandomRoom = availableRooms[love.math.random(#availableRooms)]
  local randomDirection = getRandomDirection(selectedRandomRoom)
  local nextRandomRoom = getNextRandomRoom(selectedRandomRoom, randomDirection)
  local nextRoom = map.data[nextRandomRoom.line][nextRandomRoom.column]
  local selectedRoom = map.data[selectedRandomRoom.line][selectedRandomRoom.column]

  nextRoom.isFree = false
  nextRoom.distance = selectedRoom.distance + 1
  nextRoom.map = mapManager.getRandomMap()

  table.insert(availableRooms, nextRandomRoom)
  checkAvailableRooms()

  addDoors(selectedRandomRoom, randomDirection)
end

local function drawRoom(line, column)
  local room = map.data[line][column]
  local roomX = map.x + (column-1) * (map.roomWidth + map.spacing)
  local roomY = map.y + (line-1) * (map.roomHeight + map.spacing)

  love.graphics.setColor(0.9, 0.9, 0.9)
  love.graphics.rectangle("line", roomX, roomY, map.roomWidth, map.roomHeight)

  if (room.distance == 0) then
    if (room.isFree == false) then
      love.graphics.draw(images.getImage("start"), roomX+map.roomWidth/2, roomY+map.roomHeight/2, 0, 1, 1, map.roomWidth/2, map.roomHeight/2)
    end
  end
  if (room.distance > 0) then
    if (room.isUsed) then 
      love.graphics.draw(images.getImage("used"), roomX+map.roomWidth/2, roomY+map.roomHeight/2, 0, 1, 1, map.roomWidth/2, map.roomHeight/2)
    end
  end
  --Using room
  if (room.isUsing) then
    if (room.distance > 0) then
      love.graphics.draw(images.getImage("using"), roomX+map.roomWidth/2, roomY+map.roomHeight/2, 0, 1, 1, map.roomWidth/2, map.roomHeight/2)
    end
    love.graphics.draw(images.getImage("iconMiniMap"), roomX + map.roomWidth*0.75, roomY + map.roomHeight*0.75, 0, 1, 1, map.roomWidth/2, map.roomHeight/2)
  end
  -- Draw the doors
  if (room.isUsed)  then 
    if (room.isDoorUp) then
      love.graphics.draw(images.getImage("iconDoorU"), roomX + map.roomWidth/2 - map.doorSize, roomY - map.spacing/2)
    end
    if (room.isDoorDown) then
      love.graphics.draw(images.getImage("iconDoorD"), roomX + map.roomWidth/2 - map.doorSize, roomY + map.roomHeight - map.doorSize/2 - map.spacing/2)
    end
    if (room.isDoorLeft) then
      love.graphics.draw(images.getImage("iconDoorL"), roomX - map.spacing/2, roomY + map.roomHeight/2 - map.doorSize + 2)
    end
    if (room.isDoorRight) then
      love.graphics.draw(images.getImage("iconDoorR"), roomX + map.roomWidth - map.doorSize/2 - map.spacing/2, roomY + map.roomHeight/2 - map.doorSize + 2)
    end
  end
end

local function addRooms()
  for room = 1, map.rooms do
    if (room == 1) then
      addStartingRoom()
    else
      addRoom()
    end
  end
end

local function generateMap()
  initMap()
  addRooms()
end

local class = {}

function class.getActualRoom()
  return actualRoom
end

function class.setActualRoom(room)
  actualRoom = room
  mapManager.setActualMap(map.data[actualRoom.line][actualRoom.column].map)
end

function class.isClearedRoom(line, column)
  local room = map.data[line][column]
  return room.isCleared
end

function class.getDistance(line, column)
  local room = map.data[line][column]
  return room.distance
end

function class.setClearedRoom(line, column, value)
  local room = map.data[line][column]
  room.isCleared = value
end

function class.setUsingRoom(line, column, value)
  local room = map.data[line][column]
  room.isUsing = value
end

function class.setUsedRoom(line, column, value)
  local room = map.data[line][column]
  room.isUsed = value
end

function class.isUsingRoom(line, column)
  local room = map.data[line][column]
  return room.isUsing
end

function class.isDoorUp(line, column)
  local room = map.data[line][column]
  return room.isDoorUp
end

function class.isDoorDown(line, column)
  local room = map.data[line][column]
  return room.isDoorDown
end

function class.isDoorLeft(line, column)
  local room = map.data[line][column]
  return room.isDoorLeft
end

function class.isDoorRight(line, column)
  local room = map.data[line][column]
  return room.isDoorRight
end

function class.load()
  loadSettings()
  generateMap()
end

function class.update(dt)
  for line = 1, map.lines do
    for column = 1, map.columns do
      local room = map.data[line][column]
      room.isUsing = false
    end
  end
end

function class.draw()
  for line = 1, map.lines do
    for column = 1, map.columns do
      drawRoom(line, column)
    end
  end
end

return class
