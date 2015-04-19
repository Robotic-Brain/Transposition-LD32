require("GameObjects.GameObject")
Level = GameObject:new()

function Level:init()
	GameObject.init(self)
	self:setName("Level")
	self.image = love.graphics.newImage("images/Player.png")
	self.colliders = {}
	return self
end