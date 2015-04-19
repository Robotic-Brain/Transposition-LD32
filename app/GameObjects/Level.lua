require("GameObjects.GameObject")
require("Collider")
Vector = require("hump.vector")

Level = GameObject:new()

function Level:init()
	GameObject.init(self)
	self:setName("Level")
	self.collider = Collider:newCompound():setOwner(self)
	return self
end

-- args: p1, p2
-- p1 = left/top corner
-- p2 = right/bottom corner
function Level:addBox( ... )
	local args = { ... }
	assert(#args == 2 or #args == 4)
	local a = 0
	local b = 0
	if #args == 4 then
		a = Vector.new(args[1], args[2])
		b = Vector.new(args[3], args[4])
		print("addingBox: ", a, b)
	else
		a = args[1]
		b = args[2]
	end

	self.collider:addChild(Collider:newAABox((b-a):unpack()):setPosition(a))
end

-- add collision line args: start/end point
function Level:addLine( ... )
	local args = { ... }
	assert(#args == 2 or #args == 4)
	local a = 0
	local b = 0
	if #args == 4 then
		a = Vector.new(args[1], args[2])
		b = Vector.new(args[3], args[4])
		print("addingBox: ", a, b)
	else
		a = args[1]
		b = args[2]
	end

	self.collider:addChild(Collider:newLine(a,b))
end

function Level:setDrawable(d)
	self.drawable = d
end

function Level:draw()
	GameObject.draw(self)
	if self.drawable then
		love.graphics.draw(self.drawable)
	end
end