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
  local barrierCollide = self:checkCollision("barrier")
  if barrierCollide then
    barrierCollide:instanceDestroy()
    self:instanceDestroy()
    return
  end
  
  local wallCollide = self:checkCollision("solid")
  if wallCollide then
    self:instanceDestroy()
    return
  end
end

return bullet