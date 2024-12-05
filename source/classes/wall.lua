local wall = Object:extend()

function wall:create()
  self.solid = true  
  
  self.origin_offset = 8
  self.width = 16
  self.height = 16
  self.mask.width = 16
  self.mask.height = 16
end

function wall:update()
  -- overwriting the update step because walls never do anything
end

return wall