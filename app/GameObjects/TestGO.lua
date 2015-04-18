require("GameObject")

TestGO = GameObject:new()

function TestGO:draw()
	love.graphics.print("Test", love.math.random() * 100, love.math.random() * 100)
end