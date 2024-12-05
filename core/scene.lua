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
  scene.x = 0
  scene.y = 0
  scene.angle = 0
  scene.width, scene.height = love.graphics.getDimensions()
  scene.centerX = scene.width / 2
  scene.centerY = scene.height / 2
  
  bg.load(sceneData[sceneNum].tileData)
  objectManager.load(sceneData[sceneNum].objectData)
end

function scene.update()
  scene.angle = scene.angle - 0.01
  objectManager.update()
end

function scene.draw()
  love.graphics.push()
  
	love.graphics.translate(scene.centerX, scene.centerY)
  love.graphics.rotate(scene.angle)
	love.graphics.translate(-scene.centerX, -scene.centerY)
  
  bg.draw()
  objectManager.draw()
  
  love.graphics.pop()
end

function scene.restart()
  scene.load(sceneNum)
end

return scene