Vector = require("hump.vector")

Collider = {}

-- public: create new game object
function Collider:new(o)
	o = o or {type="none", radius=0}
	setmetatable(o, self)
	self.__index = self
	o:setPosition(Vector.new())
	return o
end

function Collider:newCircle(r)
	return self:new({type="circle", radius=r})
end

function Collider:setPosition(p)
	self.pos = p
end

function Collider:onCollision(other)
	print(tostring(self).." collided with "..tostring(other))
end

function Collider:onAdded()
	print("Collider onAdded: "..tostring(self.type))
end

function Collider:onRemoved()
	print("Collider onRemoved: "..tostring(self.type))
end