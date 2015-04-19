require("GameObjects.GameObject")
Vector = require("hump.vector")
require("InputManager")
require("Collider")

Player = GameObject:new()

function Player:init()
	GameObject.init(self)
	self:setName("Player")
	self.rot = 0
	self.speed = 200
	self.range = 300
	self.image = love.graphics.newImage("images/Player.png")
	self.lastPos = self:getPosition()
	self.collider = Collider:newCircle(10):setOwner(self)
	self:setDrawLayer(100)
	return self
end

function Player:draw()
	love.graphics.push()
	love.graphics.translate(self:getPosition():unpack())
	love.graphics.rotate(self.rot)
	love.graphics.translate(-16,-16)
	love.graphics.draw(self.image)
	love.graphics.pop()
end

function Player:update(dt)
	self.lastPos = self:getPosition()
	local a = Vector.new(love.graphics.getDimensions())
	local b = Vector.new(love.mouse.getPosition())
	self.rot = (b - (a / 2)):angleTo()

	self:move(InputManager.getMovement() * self.speed * dt)

	if InputManager:didFire() then self:onClick() end
end

function Player:onClick()
	local ray = Collider:newLine(self:getPosition(), self:getPosition()+Vector.new(self.range, 0):rotated(self.rot))
	local matches = self:getWorld().physics:rayCast(ray)
	if matches[1] == self.collider then table.remove(matches, 1) end
	if #matches >= 1 then
		local newPos = matches[1]:getOwner():getPosition()
		matches[1]:getOwner():setPosition(self:getPosition())
		self:setPosition(newPos)
	end
end

function Player:onCollision(this, other)
	if not love.keyboard.isDown("n") then
		self:setPosition(self.lastPos)
	end
end