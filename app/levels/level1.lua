return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)
	p:setPosition(Vector.new(100, 100))

	-- setup level
	local l = Level:new():init()
	world:addObject(l)

	l:buildBackground(10, 7,
		8,8,8,8,8,8,8,8,8,8,
		8,1,1,1,1,1,1,1,1,8,
		8,1,1,1,1,1,1,1,1,8,
		8,1,1,1,8,1,1,1,1,8,
		8,1,1,1,1,1,1,1,1,8,
		8,1,1,1,1,1,1,1,1,8,
		8,8,8,8,8,8,8,8,8,8
		)
end