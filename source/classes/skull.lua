local SKULLSPEED = 1.5

local skull = Object:extend()

function skull:create()
  self.sprite = asset.sprite["spr_skull"]
  self.width = 32
  self.height = 32
  self.mask.width = 24
  self.mask.height = 24
  self.mask.x_offset = 4
  self.mask.y_offset = 4
  
  self.hspeed = 0
  self.vspeed = 0
  
  self.actualAngle = -1.571
  self.targetAngle = 0
  
  self.timer = 0

  self.bullets = {}
  self.enemy = true
  
  self.active = false
  self.moving = false
end

function skull:step()
  if self.target == nil then
    self.target = objectManager.getObjectByTag("player")
    if self.target == nil then
      return
    end
  end
  
  if self.active == false then
    if self:distanceToObject(self.target) < 100 then
      self.active = true
    else
      return
    end
  end
  
  if self.timer == 120 or self.timer == 0 then
    self.targetAngle = self:getVectorAngle(self.target.x,self.target.y)
  
    self.timer = 0
  end
  
  self.timer = self.timer + 1
  self.rotation = self.actualAngle + 1.571
  
  if self.moving == false then
    local actual = math.floor(math.deg(self.actualAngle)/2)
    local target = math.floor(math.deg(self.targetAngle)/2)
    if actual < target then
      self.actualAngle = self.actualAngle + math.rad(2)
      return
    elseif actual > target then
      self.actualAngle = self.actualAngle - math.rad(2)
      return
    else
      self:setVectorAimed(self.actualAngle,SKULLSPEED,true)
      self.moving = true
    end
  end
  
  self:moveIfNoSolid()
end

return skull