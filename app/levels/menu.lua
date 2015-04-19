return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)
	p:setPosition(Vector.new(100, 100))

	--world:addObject(GridGO:new():init())

	-- setup level
	local l = Level:new():init()
	world:addObject(l)
	local w, h = love.graphics.getDimensions()
	print(w, h)

	l:addLineStrip(0,0, w,0, w,h, 0,h, 0,0)

	local c = love.graphics.newCanvas()
	love.graphics.setCanvas(c)
	local r,g,b,a = love.graphics.getColor()
	local lw = love.graphics.getLineWidth()

	love.graphics.setColor(255, 0, 255)
	love.graphics.setLineWidth(5)
	love.graphics.line(0,0, w,0, w,h, 0,h, 0,0)
	love.graphics.setCanvas()

	love.graphics.setLineWidth(lw)
	love.graphics.setColor(r,g,b,a)
	l:setDrawable(c)

	l:buildBackground(10, 5,
		1,2,3,4,5,6,7,1,1,1,
		1,1,5,1,1,1,1,1,1,1,
		1,1,1,1,1,7,1,1,1,1,
		1,1,1,1,1,8,1,1,1,1,
		1,1,1,1,1,8,1,1,1,1
		)
end