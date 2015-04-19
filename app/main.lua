require("GameObjects.GameObject")
require("GameObjects.World")
require("GameObjects.TestGO")
require("GameObjects.GridGO")
require("GameObjects.Player")
require("GameObjects.Level")
require("InputManager")

local world = nil

function love.load()
	world = World:new()
	world:init()
	world:loadLevel("menu")

	print("Setup complete...")
end

function love.update( dt )
	InputManager:update(dt)
	world:update(dt)
end

function love.draw()
	world:draw()
end