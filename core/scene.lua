--[[
A scene is basically a room from Game Maker. It reads tile and object data
from my Ogmo scene files in the "scene" folder into a big table, then draws
that data on the screen. 

Let's start with just the tiles and bg images.
--]]

local scene = {}
local sceneData = require("core.sceneData")
local sceneNum = 1

local sceneType = "start"
local startTimer = 90

function scene.getSceneNum()
  return sceneNum
end

function scene.getSceneType()
  return sceneType
end

function scene.load(s,skipIntro)
  if skipIntro == nil then
    sceneType = "start"
    startTimer = 90
  end
  sceneNum = s
  
  gui.load()
  view.load()
  bg.load(sceneData[sceneNum])
  objectManager.load(sceneData[sceneNum].objectData)
  
  objectManager.update() -- adding this just to set view
end

function scene.update()
  if sceneType == "game" then
    view.stepBegin()
    objectManager.update()
    view.stepEnd()
  elseif sceneType == "start" then
    startTimer = startTimer - 1
    if startTimer == 0 then
      sceneType = "game"
    end
  elseif sceneType == "next" then
    startTimer = startTimer - 1
    if startTimer == 0 then
      sceneType = "start"
      startTimer = 90
      sceneNum = sceneNum + 1
      scene.load(sceneNum)
    end
  end
end

function scene.draw()
  gui.draw()
  view.startDrawView()
  bg.draw()
  objectManager.draw()
  view.endDrawView()
  objectManager.drawRadar()
  
  if sceneType == "start" then
    love.graphics.setColor(0,0,0,.5)
    love.graphics.rectangle("fill",301,80,320,320)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("LEVEL "..sceneNum.." of 5\nGET READY!",301,298,320,"center") 
  end
  
  if sceneType == "next" then
    love.graphics.setColor(0,0,0,.5)
    love.graphics.rectangle("fill",301,80,320,320)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("LEVEL COMPLETE!",301,298,320,"center")    
  end
end

function scene.win()
  sceneType = "next"
  startTimer = 90
end

function scene.restart(skipIntro)
  scene.load(sceneNum,skipIntro)
end

return scene