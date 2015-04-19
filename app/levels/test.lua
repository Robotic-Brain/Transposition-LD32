require("GameObjects.GridGO")

return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)
	world:addObject(TestGO:new():init())
	world:addObject(GridGO:new():init())
end