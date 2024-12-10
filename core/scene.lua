--[[
A scene is basically a room from Game Maker. It reads tile and object data
from my Ogmo scene files in the "scene" folder into a big table, then draws
that data on the screen. 

Let's start with just the tiles and bg images.
--]]

local scene = {}
local sceneData = require("core.sceneData")
local sceneNum = 1

function scene.load(s)
  sceneNum = s
  
  view.load()
  bg.load(sceneData[sceneNum])
  objectManager.load(sceneData[sceneNum].objectData)
end

function scene.update()
  view.stepBegin()
  objectManager.update()
  view.stepEnd()
end

function scene.draw()
  bg.drawBGColor()  
  view.startDrawView()
  bg.draw()
  objectManager.draw()
  view.endDrawView()
end

function scene.restart()
  scene.load(sceneNum)
end

return scene