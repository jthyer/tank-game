local ObjectParent = require "library.classic"
local Object = ObjectParent:extend()

function Object:new(id, x, y)
  self.id = id
  self.x = x
  self.y = y
  self.width = 32
  self.height = 32  
  self.rotation = 0
  self.origin_offset = 16
  self.flip = 1
  
  self.mask = {}
  self.mask.x_offset = 0
  self.mask.y_offset = 0
  self.mask.x = self.x + self.mask.x_offset
  self.mask.y = self.y + self.mask.y_offset
  self.mask.width = 32
  self.mask.height = 32
  
  self:create()
end

function Object:create()
  -- define on a per-class basis
end

function Object:update()
  self:step()
  
  if self.x < -100 or self.x > global.WINDOW_WIDTH + 100 or 
    self.y < -100 or self.y > global.WINDOW_HEIGHT + 100 then
    self:instanceDestroy()
  end
  
  -- updating sprite animation
end

function Object:step()
  -- define on a per-class basis
end

function Object:draw()
  if self.sprite ~= nil then
     love.graphics.draw(self.sprite,self.x+self.origin_offset,self.y+self.origin_offset,self.rotation,self.flip,1,self.origin_offset,self.origin_offset) 
     end
  --else
    -- love.graphics.setColor(1,1,1)
     --love.graphics.rectangle("line",self.mask.x,self.mask.y,self.mask.width,self.mask.height)
 -- end
end

function Object:move(h,v)
  self.x = self.x + h
  self.y = self.y + v
  self:updateMask()
end

function Object:updateMask()
  self.mask.x = self.x + self.mask.x_offset
  self.mask.y = self.y + self.mask.y_offset 
end

function Object:moveToContactHor(obj)
  local pushback
  if self.mask.x < obj.mask.x then
    pushback = self.mask.x + self.mask.width - obj.mask.x
    self:move(-pushback,0)
  elseif obj.mask.x < self.mask.x then
    pushback = obj.mask.x + obj.mask.width - self.mask.x
    self:move(pushback,0)
  end
end

function Object:moveToContactVert(obj)
  local pushback
  if self.mask.y < obj.mask.y then
    pushback = self.mask.y + self.mask.height - obj.mask.y
    self:move(0,-pushback)
  elseif obj.mask.y < self.mask.y then
    pushback = obj.mask.y + obj.mask.height - self.mask.y
    self:move(0,pushback)
  end
end

function Object:checkCollision(tag)
  local function f(obj,tag)
    local collision = false
    if (tag == nil or obj[tag] ~= nil) and (self.id ~= obj.id) then
      if (util.checkOverlap(self.mask.x,self.mask.y,self.mask.width,self.mask.height,
        obj.mask.x,obj.mask.y,obj.mask.width,obj.mask.height)) then
        collision = true
      end
    end
    
    return collision
  end
      
  return objectManager.checkObjects(f,tag)
end

function Object:instanceCreate(class,x,y)
  -- TO FIX 
  -- If an object calls this function in its creation code, they'll both have
  -- the same instance ID. Make a queue of objects to create and create them at the end.
  -- Make sure THOSE objects can create objects.
  
  return objectManager.addObject(class,x,y)
end

-- can target another ID, or the object can destroy itself
function Object:instanceDestroy(targetID)
  local id = targetID or self.id

  return objectManager.removeObject(id)
end

return Object