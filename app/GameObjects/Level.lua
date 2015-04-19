require("GameObjects.GameObject")
Level = GameObject:new()

function Player:init()
	GameObject.init(self)
	self:setName("Level")
	self.image = love.graphics.newImage("images/Player.png")
	return self
end

function Player:onAddedToWorld()
	GameObject.onAddedToWorld(self)
	self.collider = Collider:newCircle(10):setOwner(self)
	self:getWorld().physics:addCollider(self.collider)
end