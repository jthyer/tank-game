local bullet = Object:extend()

function bullet:create()
  self.sprite = asset.sprite["spr_bullet"]
  self.width = 12
  self.height = 12
  self.mask.width = 6
  self.mask.height = 6
  self.origin_offset = 6
  self.mask.x_offset = 3
  self.mask.y_offset = 3
  
  self.hspeed = 0
  self.vspeed = 0
  
  self.enemy = true
end

function bullet:step()
  self:move(self.hspeed,self.vspeed)
end

function bullet:setVector(hspeed,vspeed)
  self.hspeed = hspeed
  self.vspeed = vspeed
end

function bullet:setArrow()
  self.width = 32
  self.height = 32
  self.mask.width = 10
  self.mask.height = 10
  self.mask.x_offset = 11
  self.mask.y_offset = 11
  self.origin_offset = 16
  
  self.sprite = asset.sprite["spr_arrow"]
end

function bullet:setVectorAngle(angle,speed,rotate)      
  if rotate then
    self.rotation = angle + 1.571  -- rotate bullet
  end
  
  self.hspeed = speed * math.cos(angle - 1.591)
  self.vspeed = speed * math.sin(angle - 1.591)
end

function bullet:setVectorAimed(target_x,target_y, speed, rotate, offset)      
  local angle = math.atan2((target_y - self.y), (target_x - self.x))
  
  if offset then 
    angle = angle + offset
  end
  
  if rotate then
    self.rotation = angle + 1.571 -- rotate bullet
  end
  
  self.hspeed = speed * math.cos(angle)
  self.vspeed = speed * math.sin(angle)
end

return bullet