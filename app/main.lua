require("GameObjects.World")
require("GameObjects.TestGO")
require("GameObjects.Player")

local world = nil

function love.load()
	world = World:new()
	world:init()
	world:loadLevel("main")

	print("Setup complete...")
end

function love.update( dt )
	world:update(dt)
end

function love.draw()
	world:draw()
end