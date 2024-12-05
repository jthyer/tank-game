-- Love's keyboard commands don't give me access to all the information I want
-- for my games. I use this interface file to check for stuff like whether a 
-- key was released or pressed that frame, plus it lets me put all my hard key
-- checks in one file. This way I can easily change them or add rebinding
-- down the line.

local kb = {}

local spaceHeld = false
local spaceActive = false

function kb.left()
  return love.keyboard.isDown("left") and 
    not love.keyboard.isDown("right")
end

function kb.right()
  return love.keyboard.isDown("right") and
   not love.keyboard.isDown("left")
end

function kb.up()
  return love.keyboard.isDown("up") and
   not love.keyboard.isDown("down")
end

function kb.down()
  return love.keyboard.isDown("down") and
   not love.keyboard.isDown("up")
end

function kb.spaceHeld()
  return spaceHeld
end

function kb.shift()
  return love.keyboard.isDown("lshift") 
end

function kb.update()
  if love.keyboard.isDown('space') then
    if spaceActive == true then
      spaceHeld = true 
    end
  else
    spaceActive = true
    spaceHeld = false
  end
end

function kb.reset()
  spaceActive = false
  spaceHeld = false
end

return kb