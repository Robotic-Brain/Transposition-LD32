require("GameObjects.GameObject")

Decal = GameObject:new()

function Decal:init(drawable, layer)
	assert(type(layer) == "number")
	GameObject.init(self)
	self:setName("Decal")
	self.drawable = drawable
	self:setDrawLayer(layer)
	return self
end

function Decal:draw()
	love.graphics.push()
	love.graphics.translate(self:getPosition():unpack())
	love.graphics.draw(self.drawable)
	love.graphics.pop()
end