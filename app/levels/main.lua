return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)
	world:addObject(TestGO:new():init())
end