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
  
  self.bullet = true
  self.enemy = true -- swap these two if I want to make a player bullet
  self.playerBullet = nil
end

function bullet:step()
  self:move(self.hspeed,self.vspeed)
  local barrierCollide = self:checkCollision("barrier")
  if barrierCollide then
    barrierCollide:instanceDestroy()
    self:instanceDestroy()
    return
  end
  
  if self.target == nil then
    self.target = objectManager.getObjectByTag("player")
    if self.target == nil then
      return
    end
  end
  
  local bulletCollide = self:checkCollision("bullet")
  if bulletCollide then
    bulletCollide:instanceDestroy()
    self:instanceDestroy()
    return
  end
  
  if self:distanceToObject(self.target) > 200 then
    self:instanceDestroy()
  end
end

return bullet