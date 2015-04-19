return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)
	p:setPosition(Vector.new(100, 100))

	-- setup level
	local l = Level:new():init()
	
	l:buildBackground(10, 7,
		w,w,w,w,w,w,w,w,w,w,
		w,1,1,1,w,1,1,1,4,w,
		w,1,1,1,5,1,1,1,1,w,
		w,1,2,1,w,1,1,1,1,w,
		w,1,2,1,w,1,1,3,1,w,
		w,1,1,1,1,1,1,1,1,w,
		w,w,w,w,w,w,w,w,w,w
		)
	world:addObject(l)

	-- setup objects
	world:addObject(Entity:new():init("crate"):setPosition(Vector.new(64+16, 64+16)))
end