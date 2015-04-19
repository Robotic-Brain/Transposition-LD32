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

function Collider:__tostring()
	if self.type == "circle" then
		return "Circle: r="..self.radius.." pos="..tostring(self.pos)
	elseif self.type == "aabox" then
		return "AABox: r="..self.radius.." pos="..tostring(self.pos).." dim="..tostring(self.dim)
	elseif self.type == "line" then
		return "Line: r="..self.radius.." pos="..tostring(self.pos).." extend="..tostring(self.extend)
	else
		return "Unknown: r="..self.radius.." pos="..tostring(self.pos)
	end
end

-- public: new circle collider with radius
function Collider:newCircle(r)
	return self:new{type="circle", radius=r}
end

-- public: new line collider with start/end
function Collider:newLine(s, e)
	local o = self:new{
		type="line",
		extend=e-s,
		radius=(e-s):len()
	}
	o:setPosition(s)
	return o
end

-- public: new Axis aligned Box collider with width/height
function Collider:newAABox(w, h)
	return self:new{
		type="aabox",
		dim=Vector.new(w,h),
		radius=Vector.new(w,h):len()}
end

function Collider:setPosition(p)
	self.pos = p
end

function Collider:onCollision(other)
	print(tostring(self.pos).." collided with "..tostring(other.pos))
end

function Collider:onAdded()
	print("Collider onAdded: "..tostring(self.type))
end

function Collider:onRemoved()
	print("Collider onRemoved: "..tostring(self.type))
end