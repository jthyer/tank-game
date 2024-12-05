local skull = Object:extend()

function skull:create()
  self.sprite = asset.sprite["spr_skull"]
  self.width = 32
  self.height = 32
  self.mask.width = 10
  self.mask.height = 10
  self.mask.x_offset = 11
  self.mask.y_offset = 11
  self.target = objectManager.getObjectByTag("player")
  
  if self.x < 0 then  
    self.hspeed = 1
  else
    self.hspeed = -1
  end
  
  self.vspeed = 0
  self.timer = love.math.random(50) + 20  
  self.skullType = love.math.random(4)

  self.bullets = {}
  self.enemy = true
end

function skull:step()
  self:move(self.hspeed,self.vspeed)
  
  self.timer = self.timer + 1
  self.sprite = asset.sprite["spr_skull"]  
  
  if self.skullType == 1 then
    self:typeArrow()
  elseif self.skullType == 2 then
    self:typeSpiral()
  elseif self.skullType == 3 then
    self:typeTarget()
  else
    self:typeQuad()
  end
end

function skull:typeSpiral()
  if self.timer == 200 then
    self.hspeed = 0
  elseif self.timer >= 230 and self.timer <= 310 then
    self.rotation = self.rotation + 0.08
    
    if self.timer % 4 == 0 then
      self.sprite = asset.sprite["spr_skullFlash"]
      local bullet = self:instanceCreate("bullet",self.x,self.y)
      bullet:move(12,12)
      bullet:setVectorAngle(self.rotation,3)
    end
  elseif self.timer == 311 then
    self:instanceDestroy()
  end
end

function skull:typeArrow()
  if self.timer == 200 then
    local bullets = {}
    for i = -1, 1 do
      local bullet = self:instanceCreate("bullet",self.x,self.y)
      table.insert(bullets,{ bullet, i/2 })
    end
    
    local target_x, target_y = 0, 0
    
    self.sprite = asset.sprite["spr_skullFlash"]
    if self.target ~= nil then
      target_x, target_y = self.target.x, self.target.y
    end
    for i = 1, #bullets do
      bullets[i][1]:setArrow()
      bullets[i][1]:setVectorAimed(target_x,target_y,5,true,bullets[i][2])
    end
  elseif self.timer == 201 then
    self:instanceDestroy()
  end
end

function skull:typeTarget()
  if self.timer == 200 then
    self.hspeed = 0
  elseif self.timer >= 200 and self.timer <= 280 then
    local angle = 0
    if self.target then
      angle = math.atan2((self.target.y - self.y), (self.target.x -  self.x))
    end
  
    self.rotation = angle + 1.5171
    
    if self.timer  == 280 then
      self.hspeed = 7 * math.cos(angle)
      self.vspeed = 7 * math.sin(angle)
    end
  elseif self.timer > 280 and self.timer % 4 == 1 then
    self.sprite = asset.sprite["spr_skullFlash"]
  end
end

function skull:typeQuad()
  if self.timer == 200 then
    self.hspeed = 0
    self.sprite = asset.sprite["spr_skullFlash"]
    local bullet = self:instanceCreate("bullet",self.x-28,self.y-28)
    bullet:setArrow()
    bullet.target = self.target
    table.insert(self.bullets,bullet)
  elseif self.timer == 220 then
    self.sprite = asset.sprite["spr_skullFlash"]    
    local bullet = self:instanceCreate("bullet",self.x+28,self.y-28)
    bullet:setArrow()
    bullet.target = self.target
    table.insert(self.bullets,bullet)
  elseif self.timer == 240 then
    self.sprite = asset.sprite["spr_skullFlash"]    
    local bullet = self:instanceCreate("bullet",self.x-28,self.y+28)
    bullet:setArrow()
    bullet.target = self.target
    table.insert(self.bullets,bullet)
  elseif self.timer == 260 then
    self.sprite = asset.sprite["spr_skullFlash"]
    local bullet = self:instanceCreate("bullet",self.x+28,self.y+28)
    bullet:setArrow()
    bullet.target = self.target
    table.insert(self.bullets,bullet)
  end
  
  for i, v in ipairs (self.bullets) do
    v.angle = 0
    
    if v.target then
      v.angle = math.atan2((v.target.y - v.y), (v.target.x -  v.x))
    end
    v.rotation = v.angle + 1.5171
    
    if self.timer == 319 then
      self.sprite = asset.sprite["spr_skullFlash"]     
    elseif self.timer  == 320 then
      v.hspeed = 5 * math.cos(v.angle)
      v.vspeed = 5 * math.sin(v.angle)
      self:instanceDestroy()
    end
  end
end

return skull