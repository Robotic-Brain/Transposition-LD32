return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)

	-- setup level
	local l = Level:new():init()
	world:addObject(l)
	--l:addBox()
end