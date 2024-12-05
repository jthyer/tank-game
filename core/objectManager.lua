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
 
  return obj
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
  for i,obj in ipairs(OBJECTDATA) do
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

return objectManager