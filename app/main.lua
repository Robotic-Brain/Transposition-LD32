require("GameObjects.World")
require("GameObjects.TestGO")
require("GameObjects.Player")
require("GameObjects.Level")
require("InputManager")

local world = nil

function love.load()
	world = World:new()
	world:init()
	world:loadLevel("main")

	print("Setup complete...")
end

function love.update( dt )
	InputManager:update(dt)
	world:update(dt)
end

function love.draw()
	world:draw()
end