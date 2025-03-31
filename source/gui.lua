local gui = {}

local score = 0
local scoreText = "00000000000"
local lives = 3

local levelTimer = 90
local levelTimerDisplay = "1:30"
local frames = 60

local port = {}

port.x = 301
port.y = 80
port.width = 320
port.height = 320
port.border = 3

local canvas = love.graphics.newCanvas(global.WINDOW_WIDTH,global.WINDOW_HEIGHT)
  
local removeZeros, returnDisplayTime
  
function returnDisplayTime(s)
  return math.floor(s/60) .. ":" ..
    math.floor((s % 60)/10) ..
    s % 10
end

function removeZeros(num, length)
  local newNum = string.rep('0',length-#num)..num
  return newNum
end

function gui.addScore(s)
  score = score + s
  scoreText = removeZeros(tostring(score),11)
end
  
function gui.resetScore()
  score = 0
  scoreText = "00000000000"
end

function gui.resetLives()
  lives = 3
end
  
function gui.getTimer()
  return levelTimer
end

function gui.resetTimer()
  levelTimer = 90
  levelTimerDisplay = returnDisplayTime(levelTimer)
end
  
function gui.loseLife()
  lives = lives - 1
  if lives == 0 then 
    return "game over"
  else
    return "continue"
  end
end
  
function gui.drawBGColor()
  -- background color
  love.graphics.setColor(.5,.6,.6)
  love.graphics.rectangle("fill",0,0,
    global.WINDOW_WIDTH,global.WINDOW_HEIGHT)
  love.graphics.setColor(1,1,1)
end
  
function gui.load()
  gui.drawCanvas()
  gui.resetTimer()
end

function gui.update()
  if scene.getSceneType() == "title" then

  end
  if scene.getSceneType() == "game" then
    frames = frames - 1
    if frames <= 0 then
      levelTimer = levelTimer - 1
      levelTimerDisplay = returnDisplayTime(levelTimer)
      frames = 60
    end
  end
end

function gui.drawBox(x,y,w,h)
  love.graphics.setColor(1,1,1,.6)
  love.graphics.rectangle("fill",x-port.border*3,y-port.border*3,
    w+(port.border*6),h+(port.border*6))
  love.graphics.setColor(.5,.6,.6,.5)
  love.graphics.rectangle("fill",x-port.border*2,y-port.border*2,
    w+(port.border*4),h+(port.border*4))  
  love.graphics.setColor(1,1,1,.5)
  love.graphics.rectangle("fill",x-port.border,y-port.border,
    w+(port.border*2),h+(port.border*2))
  love.graphics.setColor(0,0,0,.3)
  love.graphics.rectangle("fill",x,y,w,h)
  love.graphics.setColor(1,1,1,1)
end

function gui.drawCanvas()
  love.graphics.setCanvas(canvas)
  gui.drawBGColor()
  gui.drawBox(port.x,port.y,port.width,port.height)
  --gui.drawBox(port.x,port.y-61,port.width,33)
  gui.drawBox(19,port.y-61,602,33) -- title
  -- gui.drawBox(19,port.y+80,113,port.height-160)
  gui.drawBox(19+141,port.y,113,port.height-160) -- radar
  gui.drawBox(19,port.y,113,port.height-160-80) -- lives
  gui.drawBox(19,port.y+109,113,port.height-160-109) -- face
  gui.drawBox(19,port.y+189,port.width-66,port.height-160-29) -- score
  gui.drawBox(19,port.y+28+port.height,602,33)
  
  love.graphics.printf("LIVES",19,port.y,113,"center")
  love.graphics.printf("RADAR",19+141,port.y,113,"center")
  love.graphics.printf("SCORE",19+11,port.y+189,113,"left")
  love.graphics.printf("HISCORE",19+11,port.y+189+62,200,"left")
  love.graphics.printf("T A N K   B E A R T A L I O N",20,port.y-64,global.WINDOW_WIDTH-40,"center")
  love.graphics.printf("HOSTILES NEUTRALIZED:    / ",100-10,port.y+port.height+25,global.WINDOW_WIDTH,"left")

  love.graphics.setCanvas()
end

function gui.draw()
  love.graphics.draw(canvas)
  love.graphics.printf(scoreText,30,port.y+189+31,300,"left")
  love.graphics.printf(scoreText,30,port.y+189+93,300,"left")
  love.graphics.printf(lives,19,port.y+37,113,"center")
  love.graphics.printf(levelTimerDisplay,19,port.y+115,113,"center")
end

return gui