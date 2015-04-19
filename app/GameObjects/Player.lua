require("GameObjects.GameObject")
Vector = require("hump.vector")
require("InputManager")
require("Collider")

Player = GameObject:new()

function Player:init()
	GameObject.init(self)
	self:setName("Player")
	self.rot = 0
	self.speed = 100
	self.range = 300
	self.image = love.graphics.newImage("images/Player.png")
	self.sounds = {}
	self.sounds.teleport = love.audio.newSource("sounds/Teleport.wav")
	self.collider = Collider:newCircle(12, true):setOwner(self)
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
	local a = Vector.new(love.graphics.getDimensions())
	local b = Vector.new(love.mouse.getPosition())
	self.rot = (b - (a / 2)):angleTo()

	--self:move(InputManager.getMovement() * self.speed * dt)
	--self.collider.fixture:getBody():applyForce((InputManager.getMovement() * self.speed ):unpack())
	self.collider.fixture:getBody():setLinearVelocity((InputManager.getMovement() * self.speed ):unpack())

	if InputManager:didFire() then self:onClick(1) end
	if InputManager:didFire2() then self:onClick(2) end
end

function Player:onClick(mode)
	local ray = {
		type="ray",
		start = self:getPosition(),
		pend = self:getPosition()+Vector.new(self.range, 0):rotated(self.rot)
	}
	local matches = self:getWorld().physics:rayCast(ray)
	--if matches[1] == self.collider then table.remove(matches, 1) end
	local swap = false
	for i=1,#matches do
		local curMatch = matches[i].fix
		print("Match",
				curMatch:getOwner():getName(),
				curMatch:getTag("moveable"),
				curMatch:getTag("pierceable"),
				curMatch:getTag("solid")
			)
		if curMatch ~= self.collider then
			if curMatch:getTag("pierceable") then
				-- ignore
			else
				swap = curMatch
			end
			--[[if curMatch:getTag("moveable") then
				-- hit moveable object
				swap = curMatch
				break
			elseif curMatch:getTag("pierceable") then
				-- ignore
			else
				-- hit wall
				break
			end]]
		end
	end

	if swap and swap:getTag("moveable") then
		print(swap:getOwner():getName())

		if mode == 1 then
			local newPos = swap:getOwner():getPosition()
			swap:getOwner():setPosition(self:getPosition())
			self:setPosition(newPos)
			self.sounds.teleport:play()
		elseif mode == 2 then
			local dir = self:getPosition() - swap:getOwner():getPosition()
			swap.fixture:getBody():applyLinearImpulse((dir*2000):unpack())
		end
	end
end

function Player:onCollision(this, other)
	print("onCollision Player")
	if not love.keyboard.isDown("n") then
		self:setPosition(self.lastPos)
	end
end