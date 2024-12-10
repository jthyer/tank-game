local bg = {}

local quads = {}
local canvas, canvasBackLayer
local dim = global.TILE_DIMENSION
local tileset

local x, y = 0, 0
local parallaxSpeed = 3

-- private function declarations
local setCanvas, setCanvasBackLayer

function bg.load(BGDATA)
  -- make it so you can change tilesets between levels later
  -- the tileset name is stored in the json export
  tileset = love.graphics.newImage("assets/tiles/tile_labyrinth.png")
  
  local image_width = tileset:getWidth()
  local image_height = tileset:getHeight()
  
  local rows = image_width / dim
  local cols = image_height / dim
  
  for i = 0, cols-1 do
    for j = 0, rows-1 do
      table.insert(quads,love.graphics.newQuad(
        j*dim, i*dim, dim, dim, image_width,image_height))
    end
  end 
  
  setCanvasBackLayer(BGDATA)
  setCanvas(BGDATA)
end

function bg.draw()
  love.graphics.draw(canvasBackLayer,x,y)
  love.graphics.draw(canvas,0,0)
end

function bg.setParallaxSpeed(s)
  parallaxSpeed = s
end

function bg.drawBGColor()
  -- background color
  love.graphics.setColor(.2,.2,.2)
  love.graphics.rectangle("fill",0,0,
    global.WINDOW_WIDTH,global.WINDOW_HEIGHT)
  love.graphics.setColor(1,1,1)
end
  
function bg.move(m,v)
  x = x + (m / parallaxSpeed)
  y = y + (v / parallaxSpeed)
end
  
function setCanvasBackLayer(BGDATA)
  local bg = asset.bg["bg_stars"]
  local bgWidth = bg:getWidth()
  local bgHeight = bg:getHeight()
  local canvasWidth = BGDATA.width * 3
  local canvasHeight = BGDATA.height * 3
  local numHor = math.ceil(canvasWidth / bgWidth)
  local numVert = math.ceil(canvasHeight / bgHeight)
  
  x = -BGDATA.width
  y = -BGDATA.height
  
  -- draw back layer
  canvasBackLayer = love.graphics.newCanvas(canvasWidth,canvasHeight)
  love.graphics.setCanvas(canvasBackLayer)
  
  for i=1,numHor do
    for j=1,numVert do
      love.graphics.draw(bg,(i-1)*bgWidth,(j-1)*bgHeight)
    end
  end

  love.graphics.setCanvas()
end

function setCanvas(BGDATA)
  canvas = love.graphics.newCanvas(BGDATA.width,BGDATA.height)
  love.graphics.setCanvas(canvas)
  
  -- tiles
  for i,v in ipairs(BGDATA.tileData) do
    for j,v2 in ipairs(v) do
      if v2 ~= -1 then
        love.graphics.draw(tileset,quads[v2+1],(j-1)*dim,(i-1)*dim)
      end
    end
  end 
  
  love.graphics.setCanvas()
end

return bg