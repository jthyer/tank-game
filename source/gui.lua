local gui = {}

local port = {}

port.x = 160
port.y = 80
port.width = 320
port.height = 320
port.border = 3

local canvas = love.graphics.newCanvas(global.WINDOW_WIDTH,global.WINDOW_HEIGHT)
  
function gui.drawBGColor()
  -- background color
  love.graphics.setColor(.5,.6,.6)
  love.graphics.rectangle("fill",0,0,
    global.WINDOW_WIDTH,global.WINDOW_HEIGHT)
  love.graphics.setColor(1,1,1)
end
  
function gui.load()
  gui.drawCanvas()
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
  gui.drawBox(19,port.y-61,602,33)
  gui.drawBox(19,port.y+80,113,port.height-160)
  gui.drawBox(19,port.y+28+port.height,602,33)
  love.graphics.printf("RADAR",19,port.y+80,113,"center")
  love.graphics.printf("T A N K   B E A R T A L L I O N",20,port.y-64,global.WINDOW_WIDTH-40,"center")
  love.graphics.printf("HOSTILES NEUTRALIZED:    / ",100,port.y+port.height+25,global.WINDOW_WIDTH,"left")

  love.graphics.setCanvas()
end

function gui.draw()
  love.graphics.draw(canvas)
end

return gui