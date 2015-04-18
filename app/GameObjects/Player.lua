require("GameObjects.GameObject")

Player = GameObject:new()

function GameObject:draw()
	love.graphics.rectangle("fill", self.pos.x, self.pos.y, 10, 10)
end