local class = {}
local mapList = {}

local actualMap
local quad

function class.getRandomMap()
  return mapList[love.math.random(#mapList)]
end

function class.isMap(mapId)
  return mapList[mapId]
end

function class.setActualMap(map)
  actualMap = map
end

function class.getActualMap()
  return actualMap
end

local function loadTilests(map)
  for tilesetId, tileset in ipairs(map.tilesets) do
    tileset.img = love.graphics.newImage("Assets/Maps/"..tileset.image)
  end
end

function class.load()
  for mapId = 1, 5 do
    local map = require("Assets/Maps/Map"..mapId)
    loadTilests(map)
    table.insert(mapList, map)
  end
  actualMap = mapList[5]
  quad = love.graphics.newQuad(0, 0, 0, 0, 0, 0)
end

local function getTileset(tileId)
  for tilesetId, tileset in ipairs(actualMap.tilesets) do
    if (tileId <= tileset.firstgid + tileset.tilecount - 1) then
      return tileset
    end
  end
end

local function getCellX(id, width)
  return (id % width)*actualMap.tilewidth
end

local function getCellY(id, width)
  return math.floor(id/width)*actualMap.tileheight
end

local function getQuadX(id, width)
  return (id % width)*actualMap.tilewidth
end

local function getQuadY(id, width)
  return math.floor(id/width)*actualMap.tileheight
end

local function drawTileLayer(layer)
  for cellId, tileId in ipairs(layer.data) do
    if (tileId ~= 0) then
      local cellX = getCellX(cellId-1, layer.width)
      local cellY = getCellY(cellId-1, layer.width)
      local tileset = getTileset(tileId)
      local quadX = getQuadX(tileId - tileset.firstgid, tileset.columns)
      local quadY = getQuadY(tileId - tileset.firstgid, tileset.columns)

      quad:setViewport(quadX, quadY, actualMap.tilewidth, actualMap.tileheight, tileset.img:getDimensions())
      love.graphics.draw(tileset.img, quad, cellX, cellY)
    end
  end
end

local function drawMap(property)
  for layerId, layer in ipairs(actualMap.layers) do
    if (layer.visible) and (layer.properties[property]) then
      love.graphics.setColor(1, 1, 1, layer.opacity)
      if (layer.type == "tilelayer") then
        drawTileLayer(layer)
      end
    end
  end
end

function class.draw(property)
  drawMap(property)
end

return class
