require("GameObjects.GameObject")
require("Collider")
Vector = require("hump.vector")

Entity = GameObject:new()
Entity._images = {}
Entity._images["crate"] = love.graphics.newImage("images/crate.png")

function Entity:init(t)
	assert(t == "crate")
	GameObject.init(self)
	self:setName("Entity")
	self.entityType = t
	if t == "crate" then self:initCrate() end
	self:setDrawLayer(10)
	return self
end

function Entity:initCrate()
	assert(self.entityType == "crate")
	self.collider = Collider:newAABox(25, 25):setOwner(self):setTag("moveable")
	self.image = Entity._images["crate"]
end

function Entity:draw()
	love.graphics.push()
	love.graphics.translate(self:getPosition():unpack())
	--love.graphics.rotate(self.rot)
	love.graphics.translate(-16,-16)
	love.graphics.draw(self.image)
	love.graphics.pop()
end