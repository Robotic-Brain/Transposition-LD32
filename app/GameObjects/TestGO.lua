require("GameObjects.GameObject")

TestGO = GameObject:new()

function TestGO:draw()
	love.graphics.push()
	love.graphics.translate(self.pos:unpack())
	--love.graphics.print("Test", love.math.random() * 100, love.math.random() * 100)
	--love.graphics.rectangle("fill", -10, -10, 20, 20)
	--love.graphics.line(-10, -10, 10, 10)
	love.graphics.line(-15, -10, 100, 100)
	love.graphics.circle("fill", 0, 0, 10, 10)
	love.graphics.print("Pos: "..tostring(self.pos), 0, 0)
	love.graphics.pop()
end

function TestGO:onAddedToWorld()
	GameObject.onAddedToWorld(self)
	--self.collider = Collider:newAABox(20, 20)
	--self.collider = Collider:newLine(Vector.new(-10, -10), Vector.new(10, 10))
	--self.collider = Collider:newLine(Vector.new(-15, -10), Vector.new(100, 100))
	self.collider = Collider:newCircle(10):setOwner(self)
	self:getWorld().physics:addCollider(self.collider)

	--self:setPosition(Vector.new(10, 30))
	--self.collider:setPosition(self:getPosition())
end