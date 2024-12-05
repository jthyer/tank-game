local asset = {}

asset.sprite = {}
asset.sound = {}
asset.bg = {}
asset.tileset = {}
asset.font = {}

-- could define different assets with one function

local function defineSprites()
  local dir = "assets/sprites"
  local files = love.filesystem.getDirectoryItems(dir)
  
  for i, file in ipairs(files) do
    if string.sub(file, -4) == '.png' then
      local spriteIndex = string.sub(file,1,string.len(file)-4)
      local filePath = "assets/sprites/" .. file
      asset.sprite[spriteIndex] = love.graphics.newImage(filePath)
    end
  end
end

local function defineBGs()
  local dir = "assets/backgrounds"
  local files = love.filesystem.getDirectoryItems(dir)
  
  for i, file in ipairs(files) do
    if string.sub(file, -4) == '.png' then
      local bgIndex = string.sub(file,1,string.len(file)-4)
      local filePath = dir .. "/" .. file
      asset.bg[bgIndex] = love.graphics.newImage(filePath)
    end
  end
end

defineSprites()
defineBGs()

return asset