require("GameObjects.GameObject")
require("GameObjects.World")
require("GameObjects.TestGO")
require("GameObjects.GridGO")
require("GameObjects.Player")
require("GameObjects.Level")
require("GameObjects.Entity")
require("GameObjects.TriggerZone")
require("InputManager")

THE_WORLD = nil


function love.load()
	THE_WORLD = World:new()
	THE_WORLD:init()
	THE_WORLD:loadLevel("menu")

	print("Setup complete...")
end

function love.update( dt )
	InputManager:update(dt)
	THE_WORLD:update(dt)
end

function love.draw()
	THE_WORLD:draw()
end