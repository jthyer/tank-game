--[[
A scene is basically a room from Game Maker. It reads tile and object data
from my Ogmo scene files in the "scene" folder into a big table, then draws
that data on the screen. 

Let's start with just the tiles and bg images.
--]]

local scene = {}
local sceneData = require("core.sceneData")
local sceneNum = 1

local constTimer = 90
local sceneType = "title"
local startTimer = constTimer
local startUpdate = true

function scene.getSceneNum()
  return sceneNum
end

function scene.getSceneType()
  return sceneType
end

function scene.load(s,skipIntro)
  if skipIntro == nil and sceneType ~= "title" then
    sceneType = "start"
    startUpdate = true
    startTimer = constTimer
  end
  sceneNum = s
  
  gui.load()
  view.load()
  bg.load(sceneData[sceneNum])
  objectManager.load(sceneData[sceneNum].objectData)
  
  objectManager.update() -- set view
end

function scene.update()
  if sceneType == "game" then
    view.stepBegin()
    objectManager.update()
    view.stepEnd()
  elseif sceneType == "start" then
    if startUpdate == true then
      view.stepBegin()
      objectManager.update()
      view.stepEnd() -- kludge -- I don't know why I can't make the view update in restart
      startUpdate = false
    end
    startTimer = startTimer - 1
    if startTimer == 0 then
      sceneType = "game"
    end
  elseif sceneType == "next" then
    startTimer = startTimer - 1
    if startTimer == 0 then
      if sceneNum < 5 then
        sceneType = "start"
        startTimer = constTimer
        sceneNum = sceneNum + 1
        scene.load(sceneNum)
      else
        gui.addScore(gui.getLives()*5000)
        sceneType = "win"
      end
    end
  elseif sceneType == "title" and (kb.actionPressed() or kb.shiftPressed()) then 
    sceneType = "start"
  elseif sceneType == "game over" and kb.actionPressed() then
    gui.resetLives()
    gui.resetScore()
    scene.load(sceneNum)
  elseif (sceneType == "game over" or sceneType == "win") and kb.shiftPressed() then
    gui.resetLives()
    gui.resetScore()
    sceneNum = 1
    scene.load(sceneNum)
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
  elseif sceneType == "next" then
    love.graphics.setColor(0,0,0,.5)
    love.graphics.rectangle("fill",301,80,320,320)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("LEVEL COMPLETE!\n\nTIME BONUS:\n"..gui.getTimer()*100,301,168,320,"center")  
    --love.graphics.printf("LEVEL COMPLETE!\n\nTIME BONUS:"..gui.getTimer(),301,298,320,"center")    
  elseif sceneType == "title" then
    love.graphics.setColor(0,0,0,.5)
    love.graphics.rectangle("fill",301,80,320,320)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("TANK BEARTALION\n\nPRESS Z OR SHIFT TO START",301,168,320,"center")    
  elseif sceneType == "game over" then
    love.graphics.setColor(0,0,0,.5)
    love.graphics.rectangle("fill",301,80,320,320)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("GAME OVER\n\nPRESS Z TO CONTINUE\n\nPRESS SHIFT TO START OVER",301,105,320,"center")    
  elseif sceneType == "win" then
    love.graphics.setColor(0,0,0,.5)
    love.graphics.rectangle("fill",301,80,320,320)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("YOU WON!\n\nLIVES BONUS:\n"..(gui.getLives()*5000).."\n\nPRESS SHIFT TO START OVER",301,105,320,"center")   
  end
end

function scene.win()
  sceneType = "next"
  gui.addScore(gui.getTimer()*100)
  startTimer = constTimer
end

function scene.restart(skipIntro)
  local life = gui.loseLife()
  if life == "continue" then
    scene.load(sceneNum,skipIntro)
  else 
    sceneType = "game over"
  end
end

return scene