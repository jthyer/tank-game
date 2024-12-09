--[[
A scene is basically a room from Game Maker. It reads tile and object data
from my Ogmo scene files in the "scene" folder into a big table, then draws
that data on the screen. 

Let's start with just the tiles and bg images.
--]]

local scene = {}
local sceneData = require("core.sceneData")
local sceneNum = 1

view = {}
view[1] = {}
view[1].x = 160
view[1].y = 120
view[1].xview = 0--160
view[1].yview = 0--120
view[1].width = 640--320
view[1].height = 480--240
view[1].angle = 0

function scene.load(s)
  sceneNum = s
  
  bg.load(sceneData[sceneNum])
  objectManager.load(sceneData[sceneNum].objectData)
end

function scene.update()
  objectManager.update()
end

function scene.draw()
   -- bg.draw()
  love.graphics.push()
  
	love.graphics.translate(view[1].width/2, view[1].height/2)
  love.graphics.rotate(view[1].angle)
	love.graphics.translate(-view[1].width/2, -view[1].height/2)  
  
 	love.graphics.translate(view[1].x, view[1].y) 
 
-- love.graphics.setScissor(view[1].xview, view[1].yview,view[1].width, view[1].height)

 --	love.graphics.translate(200, 200)  
  
  bg.draw()
  objectManager.draw()
  
  
  
  love.graphics.pop()
end

function scene.restart()
  scene.load(sceneNum)
end

function view.move(v,x,y)
  view[v].x = view[v].x + x
  view[v].y = view[v].y + y
end

function view.setPosition(v,x,y)
  view[v].x = x + view[v].xview
  view[v].y = y + view[v].yview
end

function view.setAngle(v,a)
  view[v].angle = a
end

return scene