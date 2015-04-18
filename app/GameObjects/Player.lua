require("GameObjects.GameObject")
require("Util.Vector")
Vector = require("hump.vector")

Player = GameObject:new()

function Player:init()
	GameObject.init(self)
	self.rot = 0
	self.speed = 10
	return self
end

function Player:draw()
	love.graphics.push()
	love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	love.graphics.rotate(self.rot)
	love.graphics.rectangle("fill", 0, 0, 30, 10)
	love.graphics.pop()
end

function Player:update(dt)
	local a = Vector.new(love.graphics.getDimensions())
	local b = Vector.new(love.mouse.getPosition())
	self.rot = (b - (a / 2)):angleTo()

	self:move(--[[InputManager.getMovement() *]] Vector.new() * self.speed * dt)
end

function Player:move(vec)
	self:setPosition((Vector.new(self:getPosition()) + vec):unpack())
end