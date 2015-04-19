require("GameObjects.GameObject")
require("Collider")
Vector = require("hump.vector")

Level = GameObject:new()

function Level:init()
	GameObject.init(self)
	self:setName("Level")
	self.image = love.graphics.newImage("images/Player.png")
	self.collider = Collider:newCompound():setOwner(self)
	return self
end

function Level:addBox( ... )
	local args = { ... }
	assert(#args == 2 or #args == 4)
	local a = 0
	local b = 0
	if #args == 4 then
		a = Vector.new(args[1], args[2])
		b = Vector.new(args[3], args[4])
	else
		a = args[1]
		b = args[2]
	end

	self.collider:addChild(Collider:newAABox((b-a):unpack()):setPosition(a))
end