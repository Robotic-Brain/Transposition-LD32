return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)
	p:setPosition(Vector.new(100, 100))

	-- setup level
	local l = Level:new():init()
	
	l:buildBackground(10, 7,
		8,8,8,8,8,8,8,8,8,8,
		8,1,1,1,8,1,1,1,4,8,
		8,1,1,1,5,1,1,1,1,8,
		8,1,2,1,8,1,1,1,1,8,
		8,1,2,1,8,1,1,3,1,8,
		8,1,1,1,8,1,1,1,1,8,
		8,8,8,8,8,8,8,8,8,8
		)
	world:addObject(l)

	-- setup objects
	world:addObject(Entity:new():init("crate"):setPosition(Vector.new(64+16, 64+16)))
end