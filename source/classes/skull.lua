local SKULLSPEED = 1
local SPINSPEED = 2
local BULLETSPEED = 3

local skull = Object:extend()

function skull:create()
  self.sprite = asset.sprite["spr_skull"]
  self.width = 32
  self.height = 32
  self.mask.width = 24
  self.mask.height = 24
  self.mask.x_offset = 4
  self.mask.y_offset = 4
  
  self.actualAngle = -1.571
  self.targetAngle = 0
  
  self.timer = 0
  self.timerTarget = (math.random(3)*30)+30

  self.bullets = {}
  self.enemy = true
  self.skull = true
  
  self.bulletTimer = 0
  self.bulletTimerTarget = (math.random(3)*30)+15
  
  self.active = false
  self.moving = false
end

function skull:step()
  local collide = self:checkCollision("playerBullet")
  if collide then
    gui.addScore(1000)
    collide:instanceDestroy()
    self:instanceDestroy()
    return
  end
  
  if self.target == nil then
    self.target = objectManager.getObjectByTag("player")
    if self.target == nil then
      return
    end
  end
  
  if self.active == false then
    if self:distanceToObject(self.target) < 200 then
      self.active = true
    else
      return
    end
  end
  
  if self.timer == self.timerTarget or self.timer == 0 then
    local newAngle = self:getVectorAngle(self.target.x,self.target.y) 
    if math.abs(newAngle - self.targetAngle) > math.rad(15) then
      self.targetAngle = newAngle
      while self.targetAngle < 0 do
        self.targetAngle = self.targetAngle + math.rad(360)
      end
      while self.actualAngle < 0 do
        self.actualAngle = self.actualAngle + math.rad(360)  
      end

      self.moving = false
    end
    self.timer = 1
    self.timerTarget = (math.random(3)*30)+30
    self.bulletTimer = 0
    self.bulletTimerTarget = (math.random(3)*15)+15
  end
  
  self.rotation = self.actualAngle + 1.571
  
  if self.moving == false then
    local actual = math.floor(math.deg(self.actualAngle)/SPINSPEED)
    local target = math.floor(math.deg(self.targetAngle)/SPINSPEED)
    
    if actual - target > 180/SPINSPEED then
      target = target + (360/SPINSPEED)
    elseif actual - target < (-180/SPINSPEED) then
      target = target - (360/SPINSPEED)
    end
    
    if actual < target then
      self.actualAngle = self.actualAngle + math.rad(SPINSPEED)
      return
    elseif actual > target then
      self.actualAngle = self.actualAngle - math.rad(SPINSPEED)
      return
    else
      self:setVectorAimed(self.actualAngle,SKULLSPEED,true)
      self.moving = true
    end
  end
  
  self.timer = self.timer + 1
  self.bulletTimer = self.bulletTimer + 1
  
  if self.bulletTimer == self.bulletTimerTarget then
    local checkAngle = (math.deg(self:getVectorAngle(self.target.x,self.target.y)) + 360) % 360
    local currentAngle = (math.deg(self.actualAngle) + 360) % 360
    local diff = math.abs(checkAngle - currentAngle)

    if diff < 90 then
      local bullet = self:instanceCreate("bullet",self.x+10,self.y+10)
      bullet:setVectorAimed(self.actualAngle,BULLETSPEED)
    end
    self.bulletTimer = 0
    self.bulletTimerTarget = (math.random(3)*15)+15
  end
  self:moveIfNoSolid()
end

return skull