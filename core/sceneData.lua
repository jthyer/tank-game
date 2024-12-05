--[[
This is the folder where I read in my ogmo json files and turn them into 
actual rooms. 

This is a three step process: 
  - Reading the tile data
  - Reading the solid objects (every game has a "wall" class of objects)
  - Reading the remaining objects
  
This feels pretty good! I changed it so that it just reads every json file
in the scene directory instead of needing to hardcode a number of scenes.
--]]

local json = require("library.json")
local TILEWIDTH = global.WINDOW_WIDTH / global.TILE_DIMENSION
local TILEHEIGHT = global.WINDOW_HEIGHT / global.TILE_DIMENSION

-- private function declarations
local sceneLoad, loadTiles, loadObjects

function sceneLoad()
  local sceneData = {}
  local dir = "scenes"
  local files = love.filesystem.getDirectoryItems(dir)
  
  local numScenes = 0
  
  for i, file in ipairs(files) do
    if string.sub(file, -5) == '.json' then
      numScenes = numScenes + 1
      table.insert(sceneData,{})
      
      local raw = love.filesystem.read("scenes/"..file)
      local jsonData = json.decode(raw)
      
      loadTiles(numScenes,sceneData,jsonData)
      loadObjects(numScenes,sceneData,jsonData)
    end
  end
  
  return sceneData
end

function loadTiles(scene,sceneData,jsonData)
  sceneData[scene].tileData = {} 
  
  for i = 1, TILEHEIGHT do
    local row = {}
    for i2 = 1, TILEWIDTH do
      local coord = jsonData["layers"][1]["data"][i2+((i-1)*TILEWIDTH)]
      table.insert(row,coord)
    end
    table.insert(sceneData[scene].tileData,row)
  end
end

function loadObjects(scene,sceneData,jsonData)
  sceneData[scene].objectData = {}
  
  -- load solids
  --  The only reason these are a separate layer is that ogmo doesn't
  --  let me click and drag to create many "entities", so I have to 
  --  make these in tile mode if I want to easily draw a bunch of them.
  for i = 1, TILEHEIGHT do
    local row = {}
    for i2 = 1, TILEWIDTH do
      local coord = jsonData["layers"][2]["data"][i2+((i-1)*TILEWIDTH)]
      if coord == 0 then
        local object = {}
        object.class = "wall"
        object.x = (i2-1)*16
        object.y = (i-1)*16
        table.insert(sceneData[scene].objectData,object)
      end
    end
  end
  
  -- load entity objects
  for key,v in pairs(jsonData["layers"][3]["entities"]) do
    local object = {}
    object.class = v["name"]
    object.x = v["x"]
    object.y = v["y"]
    table.insert(sceneData[scene].objectData,object)
  end
end

return sceneLoad()