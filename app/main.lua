require("GameObjects.World")
require("GameObjects.TestGO")
require("GameObjects.Player")

local world = nil

function love.load()
	world = World:new()
	world:init()

	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)
	world:addObject(TestGO:new():init())

	print("Setup complete...")
end

function love.update( dt )
	world:update(dt)
end

function love.draw()
	world:draw()
end