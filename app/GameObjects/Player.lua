require("GameObjects.GameObject")
Vector = require("hump.vector")
require("InputManager")
require("Collider")

Player = GameObject:new()

function Player:init()
	GameObject.init(self)
	self.rot = 0
	self.speed = 50
	self.range = 300
	self.image = love.graphics.newImage("images/Player.png")
	return self
end

function Player:onAddedToWorld()
	GameObject.onAddedToWorld(self)
	self.collider = Collider:newCircle(20)
	self:getWorld().physics:addCollider(self.collider)
end

function Player:draw()
	love.graphics.push()
	love.graphics.translate(self.pos:unpack())
	love.graphics.circle("fill", 0, 0, 20, 10)
	love.graphics.print("Pos: "..tostring(self.pos), 0, 0)
	love.graphics.rotate(self.rot)
	love.graphics.line(0, 0, self.range, 0)
	love.graphics.translate(-16,-16)
	love.graphics.draw(self.image)
	love.graphics.pop()
end

function Player:update(dt)
	local a = Vector.new(love.graphics.getDimensions())
	local b = Vector.new(love.mouse.getPosition())
	self.rot = (b - (a / 2)):angleTo()

	self:move(InputManager.getMovement() * self.speed * dt)
	self.collider:setPosition(self:getPosition())

	if InputManager:didFire() then self:onClick() end
end

function Player:onClick()
	local ray = Collider:newLine(self:getPosition(), self:getPosition()+Vector.new(self.range, 0):rotated(self.rot))
	local matches = self:getWorld().physics:rayCast(ray)
	if matches[1] == self.collider then table.remove(matches, 1) end
	print(#matches)
end