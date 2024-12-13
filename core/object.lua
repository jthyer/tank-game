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
  self.hspeed = 0
  self.vspeed = 0
  
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
  
  --if self.x < -100 or self.x > global.WINDOW_WIDTH + 100 or 
  --  self.y < -100 or self.y > global.WINDOW_HEIGHT + 100 then
  --  self:instanceDestroy()
  --end
  
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

function Object:moveIfNoSolid()
  local old_x, old_y = self.x, self.y
  
  self:move(self.hspeed,0)
  
  local collide = self:checkCollision("solid")
  if (collide) then
    self:move(old_x-self.x,0)
    self:moveToContactHor(collide)
  end
  
  self:move(0,self.vspeed)
  
  collide = self:checkCollision("solid")
  if (collide) then
    self:move(0,old_y-self.y)
    self:moveToContactVert(collide)
  end  
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

function Object:distanceToObject(obj)
  local dist = ((obj.x-self.x)^2+(obj.y-self.y)^2)^0.5
  return dist
end

function Object:setVector(hspeed,vspeed)
  self.hspeed = hspeed
  self.vspeed = vspeed
end

function Object:setVectorAngle(angle,speed,rotate)      
  if rotate then
    self.rotation = angle + 1.571  -- rotate sprite
  end
  
  self.hspeed = speed * math.cos(angle - 1.591)
  self.vspeed = speed * math.sin(angle - 1.591)
end

function Object:getVectorAngle(target_x,target_y)
  local angle = math.atan2((target_y - self.y), (target_x - self.x))
  
  return angle
end

function Object:setVectorAimed(angle, speed, rotate, offset)       
  if offset then 
    angle = angle + offset
  end
  
  if rotate then
    self.rotation = angle + 1.571 -- rotate sprite
  end
  
  self.hspeed = speed * math.cos(angle)
  self.vspeed = speed * math.sin(angle)
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