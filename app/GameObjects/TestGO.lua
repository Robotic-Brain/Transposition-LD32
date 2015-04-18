require("GameObjects.GameObject")

TestGO = GameObject:new()

function TestGO:draw()
	--love.graphics.print("Test", love.math.random() * 100, love.math.random() * 100)
	love.graphics.rectangle("fill", 0, 0, 30, 10)
end