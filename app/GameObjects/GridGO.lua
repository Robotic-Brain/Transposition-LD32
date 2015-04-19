require("GameObjects.GameObject")

GridGO = GameObject:new()

function GridGO:draw()
	local r,g,b,a = love.graphics.getColor()

	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.line(0, 0, 600, 0) -- x Axis
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.line(0, 0, 0, 600) -- y Axis

	love.graphics.setColor(r,g,b,a)
end