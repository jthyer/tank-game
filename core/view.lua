local view = {}

function view.load()
  view[1] = {}
  view[1].x = 160
  view[1].y = 80
  view[1].xview = 160
  view[1].yview = 80
  view[1].width = 320
  view[1].height = 320
  view[1].angle = 0 
end

function view.stepBegin()
  view[1].oldX = view[1].x
  view[1].oldY = view[1].y
end

function view.stepEnd()
  local h = view[1].oldX - view[1].x
  local v = view[1].oldY - view[1].y
  
  bg.move(h,v)
end

function view.startDrawView()
  love.graphics.push()  
  
	love.graphics.translate(view[1].xview+view[1].width/2, view[1].yview+view[1].height/2)
  love.graphics.rotate(view[1].angle)
	love.graphics.translate(-view[1].xview+-view[1].width/2, -view[1].yview+-view[1].height/2)  

 	love.graphics.translate(view[1].x, view[1].y) 
  love.graphics.setScissor(view[1].xview, view[1].yview,view[1].width, view[1].height)
end

function view.endDrawView()
  love.graphics.setScissor()
  love.graphics.pop()
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

return view