local barrier = Object:extend()

function barrier:create()
  self.solid = true  
  self.barrier = true
  self.sprite = asset.sprite["spr_barrier"]
  
  self.origin_offset = 8
  self.width = 16
  self.height = 16
  self.mask.width = 16
  self.mask.height = 16
end

function barrier:update()
  -- overwriting the update step because walls never do anything
end

return barrier