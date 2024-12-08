global = {}
global.WINDOW_WIDTH = 640
global.WINDOW_HEIGHT = 480
global.TILE_DIMENSION = 16

local gameTitle = "Tank Game"
local fontPath = "assets/fonts/BetterComicSans.ttf"
local fontSize = 32

Object = require "core.object" 
objectManager = require "core.objectManager"
asset = require "core.asset"
scene = require "core.scene"
bg = require "core.bg"
kb = require "core.kb"
util = require "core.util"

local tickPeriod = 1/60
local accumulator = 0.0

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

  scene.load(1)
end

function love.update(dt)
  local delta = dt

  accumulator = accumulator + delta
  if accumulator >= tickPeriod then
    kb.update()
    scene.update()
    accumulator = accumulator - tickPeriod
  end  
end

function love.draw()
  scene.draw()
end

function love.keypressed(key, scancode)
   if key == "escape" then
      love.event.quit()
   end
end