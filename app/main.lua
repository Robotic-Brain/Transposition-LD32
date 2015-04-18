require("world")
require("GameObjects.TestGO")

local world = nil

function love.load()
	world = World:new()
	world:init()
end

function love.update( dt )
	world:update(dt)
end

function love.draw()
	local o = TestGO:new()
	world:addObject(o)
	world:draw()
	o:destroy()
end