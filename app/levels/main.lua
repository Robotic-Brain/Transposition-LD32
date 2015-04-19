return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)

	world:addObject(GridGO:new():init())

	-- setup level
	local l = Level:new():init()
	world:addObject(l)
	l:addBox(-20, -20, 10, 100)
end