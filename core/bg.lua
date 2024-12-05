local bg = {}

local quads = {}
local canvas = love.graphics.newCanvas(640,480)
local dim = global.TILE_DIMENSION
local tileset

local x, y = 0, 0
local angle = 0

-- private function declarations
local setCanvas

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
  
  setCanvas(BGDATA)
end

function bg.draw()
  love.graphics.draw(canvas,x,y,angle,1,1)
end

function bg.setPosition(new_x,new_y)
  x, y = new_x, new_y
end

function setCanvas(BGDATA)
  love.graphics.setCanvas(canvas)
  
  -- background color
  love.graphics.setColor(.2,.2,.2)
  love.graphics.rectangle("fill",0,0,
    global.WINDOW_WIDTH,global.WINDOW_HEIGHT)
  love.graphics.setColor(1,1,1)
  
  -- draw bg
  love.graphics.setColor(1,1,1,.5)
  love.graphics.draw(asset.bg["bg_bloodmoon"])
  love.graphics.setColor(1,1,1)
  
  -- tiles
  for i,v in ipairs(BGDATA) do
    for j,v2 in ipairs(v) do
      if v2 ~= -1 then
        love.graphics.draw(tileset,quads[v2+1],(j-1)*dim,(i-1)*dim)
      end
    end
  end 
  
  love.graphics.setColor(.8,.8,.8)
  love.graphics.rectangle("line",16*13,16*10,16*14,16*10)
  love.graphics.setColor(1,1,1)  
  
  love.graphics.setCanvas()
end

return bg