local SPEED = 3;
local SPINSPEED = .028 --0.025
local BULLETSPEED = 4

local player = Object:extend()

function player:create()
  self.sprite = asset.sprite["spr_player"]
  self.width = 32
  self.height = 32
  self.mask.width = 24
  self.mask.height = 24
  self.mask.x_offset = 4
  self.mask.y_offset = 4

  self.player = true
end

function player:step()
  if gui.getTimer() <= 0 then
    self:die()
  end
  
  self:readMovement()
  self:checkEnemyCollision()
  self:viewSet()
end

function player:readMovement()
  local old_x = self.x
  local old_y = self.y
  local collide 
  
  self.hspeed = 0
  self.vspeed = 0

  -- read keyboard input
  if kb.actionPressed() then
    sound.play("sfx_shoot")
    local bullet = self:instanceCreate("bullet",self.x+10,self.y+10)
    bullet:setVectorAimed(self.rotation-math.rad(90),BULLETSPEED)
    bullet.enemy = nil
    bullet.playerBullet = true
  end
  
  if kb.shift() then
    if kb.left() then    
      self.hspeed = SPEED * math.cos(self.rotation - 3.1416) / 2
      self.vspeed = SPEED * math.sin(self.rotation - 3.1416) / 2
    elseif kb.right() then
      self.hspeed = SPEED * math.cos(self.rotation) / 2
      self.vspeed = SPEED * math.sin(self.rotation) / 2
    end
  else 
    if kb.left() then    
      self.rotation = self.rotation - SPINSPEED  
    elseif kb.right() then
      self.rotation = self.rotation + SPINSPEED   
    end    
  end

  if kb.up() and not (kb.left() or kb.right()) then 
    self.hspeed = SPEED * math.cos(self.rotation - 1.591)
    self.vspeed = SPEED * math.sin(self.rotation - 1.591)
  elseif kb.down() and not (kb.left() or kb.right()) then
    self.hspeed = SPEED * math.cos(self.rotation + 1.591) * .5
    self.vspeed = SPEED * math.sin(self.rotation + 1.591) * .5
  end
  
  -- set speed
  if self.hspeed ~= 0 and self.vspeed ~= 0 then
    self.hspeed = self.hspeed * .71
    self.vspeed = self.vspeed * .71
  end
  
  self:moveIfNoSolid()
end

function player:checkEnemyCollision()
  local collide = self:checkCollision("enemy")
  
  if (collide) then
    self:die()
  end
end

function player:viewSet()
  view.setPosition(1,
    (view[1].width/2) - self.x - (self.width/2),
    (view[1].height/2) - self.y - (self.height/2))

  view.setAngle(1,-self.rotation)
end

function player:die()
  --self:instanceCreate("fire",self.x,self.y)
  sound.play("sfx_playerDead")
  self:instanceDestroy()
  scene.restart()
end

function player:draw()
  love.graphics.draw(self.sprite,self.x+self.origin_offset,self.y+self.origin_offset,
    self.rotation,self.flip,1,self.origin_offset,self.origin_offset) 
end

return player