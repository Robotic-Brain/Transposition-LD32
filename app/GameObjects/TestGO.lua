require("GameObjects.GameObject")

TestGO = GameObject:new()

function TestGO:draw()
	love.graphics.push()
	love.graphics.translate(self.pos:unpack())
	--love.graphics.print("Test", love.math.random() * 100, love.math.random() * 100)
	love.graphics.rectangle("fill", 0, 0, 30, 10)
	love.graphics.print("Pos: "..tostring(self.pos), 0, 0)
	love.graphics.pop()
end

function TestGO:onAddedToWorld()
	GameObject.onAddedToWorld(self)
	self:getWorld().physics:addCollider(Collider:newCircle(10))
end