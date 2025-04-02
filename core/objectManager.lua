--[[
Objects are defined on a scene by scene basis. The object table is completely
emptied between scenes. 

All the implementation for the basic game world object is done in object.lua.
Specific object implementations are done in the source folder on a per-game
basis. The intent here is to mimic the basic functionality of a blank object
in Game Maker.
--]]

local objectManager = {}
local objectTable = {}
local objectToDestroy = {}
local instanceID 

local Class = {}

local radarScale = {}
radarScale[1] = 0.15
radarScale[2] = 0.15
radarScale[3] = 0.15
radarScale[4] = 0.15
radarScale[5] = 0.15

local hostileKills = 0
local hostileTotal = 0

local function defineClasses()
  local dir = "source/classes"
  local files = love.filesystem.getDirectoryItems(dir)
  
  for i, file in ipairs(files) do
    if string.sub(file, -4) == '.lua' then
      local className = string.sub(file,1,string.len(file)-4)
      Class[className] = require("source.classes." .. className)
    end
  end
end

defineClasses()

function objectManager.addObject(classIndex,x,y)
  local obj = Class[classIndex](instanceID,x,y)
  table.insert(objectTable,obj)
  
  instanceID = instanceID + 1
    
  return obj
end

function objectManager.removeObject(id)
  table.insert(objectToDestroy,id)
end

function objectManager.getObject(id)
  for i,obj in ipairs(objectTable) do
    if obj.id == id then
      return obj
    end
  end
  
  return nil
end

function objectManager.getObjectByTag(tag)
  for i,obj in ipairs(objectTable) do
    if obj[tag] then
      return obj
    end
  end
  
  return nil
end

function objectManager.checkObjects(f,arg)
  -- perform a passed function on all objects 
  -- immediately return true if any f(obj) returns true
  for i,obj in ipairs(objectTable) do
    if f(obj,arg) then
      return obj
    end
  end
  return nil
end  

function objectManager.load(OBJECTDATA)
  objectTable = {}
  objectToDestroy = {}
  instanceID = 1
    
  hostileKills, hostileTotal = 0, 0
    
  for i,obj in ipairs(OBJECTDATA) do
    if obj.class == "skull" then
      hostileTotal = hostileTotal + 1
    end
    objectManager.addObject(obj.class,obj.x,obj.y)
  end
end

function objectManager.update()
  for i,obj in ipairs(objectTable) do
    obj:update()
  end 

  -- destroy all objects marked for death
  for i,id in ipairs(objectToDestroy) do
    for k,obj in ipairs(objectTable) do
      if obj.id == id then
        if obj.skull then
          hostileKills = hostileKills + 1
          if hostileKills == hostileTotal then
            scene.win() 
          end
        end
        table.remove(objectTable,k)
        break
      end
    end 
  end 
  objectToDestroy = {}
end

function objectManager.draw()
  for i,obj in ipairs(objectTable) do
    obj:draw()
  end 
end

function objectManager.drawRadar()
  for i,obj in ipairs(objectTable) do
    if obj.skull and obj.active then
      love.graphics.setColor(1,0,0,1)
      love.graphics.rectangle("fill",165-2+obj.x*radarScale[scene.getSceneNum()],
        120-2+obj.y*radarScale[scene.getSceneNum()],5,5)
      love.graphics.setColor(1,1,1,1)
    elseif obj.player then
      love.graphics.setColor(1,1,0,1)
      love.graphics.rectangle("fill",165-3+obj.x*radarScale[scene.getSceneNum()],
        120-3+obj.y*radarScale[scene.getSceneNum()],6,6)
      love.graphics.setColor(1,1,1,1)
    end
  end
  
  love.graphics.printf(tostring(hostileKills),400,425,100,"right")
  love.graphics.printf(tostring(hostileTotal),460,425,100,"right")
end

function objectManager.getClass(str)
  return Class[str]
end

function objectManager.getObjectCount()
  return #objectTable
end

return objectManager