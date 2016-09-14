return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)
	p:setPosition(Vector.new(100, 100))

	-- setup level
	local l = Level:new():init()
	
	l:buildBackgroundFromText(20, 20,[[
w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,k,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,k,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,k,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,k,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,p,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,l,w,
w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w
]]
		)
	world:addObject(l)

	-- setup objects
	world:addObject(Entity:new():init("crate"):setPosition(Vector.new(64+16, 64+16)))

	-- adding exit
	l:addExit(Vector.new(18, 18), "Level1")
end