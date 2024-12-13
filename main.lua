global = {}
global.WINDOW_WIDTH = 640
global.WINDOW_HEIGHT = 480
global.TILE_DIMENSION = 16
global.current_width = global.WINDOW_WIDTH
global.current_height = global.WINDOW_HEIGHT

local gameTitle = "Tank Game"
local fontPath = "assets/fonts/BetterComicSans.ttf"
local fontSize = 32

Object = require "core.object" 
objectManager = require "core.objectManager"
asset = require "core.asset"
scene = require "core.scene"
view = require "core.view"
bg = require "core.bg"
kb = require "core.kb"
util = require "core.util"

local tickPeriod = 1/60
local accumulator = 0.0

local frameCount = 0
local dtCount = 0
local fps = 0

local frameCanvas = love.graphics.newCanvas(global.WINDOW_WIDTH,global.WINDOW_HEIGHT)

local gameStart = false
local gameActive = false

function love.load()
  love.graphics.setDefaultFilter("linear", "linear", 1)
  love.window.setTitle(gameTitle)
  love.window.setVSync( 1 )  
  font = love.graphics.newFont(fontPath,fontSize,"mono")
  --local song = love.audio.newSource("assets/sounds/macabre.ogg", "stream")
  --song:setLooping(true)
  --song:play()
  math.randomseed(os.time())
  scene.load(2)
end

function love.update(dt)
  local delta = dt

  dtCount = dtCount + delta
  accumulator = accumulator + delta
  if accumulator >= tickPeriod then
    kb.update()
    scene.update()
    accumulator = accumulator - tickPeriod
    
    frameCount = frameCount + 1

    if frameCount == 60 then
      fps = math.floor(6000/dtCount)/100
      frameCount = 0
      dtCount = 0
    end
  end  
end

function love.draw()
  --love.graphics.setCanvas(frameCanvas)
  scene.draw()
  love.graphics.printf(fps,10,10, 200, "left")
  --[[love.graphics.setCanvas()
  
  local frameScale = math.min(
    global.current_width / global.WINDOW_WIDTH,
    global.current_height / global.WINDOW_HEIGHT
  )
  
  local frameX = (global.current_width - (global.WINDOW_WIDTH*frameScale)) / 2
  local frameY = (global.current_height - (global.WINDOW_HEIGHT*frameScale)) / 2
 
  love.graphics.draw(frameCanvas,frameX,frameY,0,frameScale,frameScale)--]]
end

function love.keypressed(key, scancode)
   if key == "escape" then
      love.event.quit()
   end
   
   if key == "f" then
     --changeFullscreen()
  end
end

function changeFullscreen()  
  local fullscreen = love.window.getFullscreen()
  
  love.window.setFullscreen(not fullscreen)
  if fullscreen then
    global.current_width, global.current_height = global.WINDOW_WIDTH,global.WINDOW_HEIGHT
  else
    global.current_width, global.current_height = love.graphics.getDimensions()
  end
end
