require("GameObjects.GameObject")
require("Collider")
Vector = require("hump.vector")

Entity = GameObject:new()
Entity._images = {}
Entity._images["crate"] = love.graphics.newImage("images/crate.png")
Entity._images["wall"] = love.graphics.newImage("images/tile08.png")

function Entity:init(t)
	assert(t == "crate" or t == "wall")
	GameObject.init(self)
	self:setName("Entity")
	self.entityType = t
	if t == "crate" then self:initCrate() end
	if t == "wall" then self:initWall() end
	self:setDrawLayer(10)
	return self
end

function Entity:initCrate()
	assert(self.entityType == "crate")
	self.collider = Collider:newAABox(25, 25, true):setOwner(self):setTag("moveable")
	self.image = Entity._images["crate"]
end

function Entity:initWall()
	assert(self.entityType == "wall")
	self.collider = Collider:newAABox(32, 32, "dynamic"):setOwner(self):setTag("solid")
	self.collider.fixture:setDensity(100000000000)
	self.collider.fixture:getBody():resetMassData()
	self.image = Entity._images["wall"]
end

function Entity:draw()
	love.graphics.push()
	love.graphics.translate(self:getPosition():unpack())
	--love.graphics.rotate(self.rot)
	love.graphics.translate(-16,-16)
	love.graphics.draw(self.image)
	love.graphics.pop()
end