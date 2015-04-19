Vector = require("hump.vector")
require("Collider")

Physics = {}

-- public: create new game object
function Physics:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Physics:init()
	self.colliders = {}
	self.icolliders = {}
	self.free = {}
	return self
end

function Physics:update(dt)
	--self:integrate()
	self:checkCollisions()
end

function Physics:checkCollisions()
	for i=1,#self.icolliders do
		for j=i+1,#self.icolliders do
			if self:collide(self.icolliders[i], self.icolliders[j]) then
				self.icolliders[i]:onCollision(self.icolliders[j])
				self.icolliders[j]:onCollision(self.icolliders[i])
			end
		end
	end
end

function clamp(v, min, max)
	return Vector.new(
		math.min(math.max(min.x, v.x), max.x),
		math.min(math.max(min.y, v.y), max.y)
		)
end
function collideBoxCircle(box, circle)
	assert(box.type == "aabox")
	assert(circle.type == "circle")
	-- from http://stackoverflow.com/a/1879223
	local closest = clamp(circle.pos, box.pos-(box.dim/2), box.pos+(box.dim/2))
	if circle.pos:dist2(closest) < (circle.radius*circle.radius) then
		return true
	end

	return false
end

function collideLineCircle(line, circle)
	assert(line.type == "line")
	assert(circle.type == "circle")
	-- from http://stackoverflow.com/a/1084899
	local cd = line.extend
	local cf = (line.pos-circle.pos)

	local ca = cd*cd
	local cb = 2*(cf*cd)
	local cc = cf*cf - circle.radius*circle.radius

	local discriminant = cb*cb-4*ca*cc
	if discriminant < 0 then return false else
		discriminant = math.sqrt(discriminant)
		local t1 = (-cb - discriminant)/(2*ca)
		local t2 = (-cb + discriminant)/(2*ca)
		if t1 >= 0 and t1 <= 1 then
			return true
		end
		if t2 >= 0 and t2 <= 1 then
			return true
		end
	end

	return false
end

function collideBoxBox(a, b)
	assert(a.type == "aabox")
	assert(b.type == "aabox")
	print("Box/Box colission not implemented!")
end

function collideLineBox(line, box)
	assert(line.type == "line")
	assert(box.type == "aabox")
	local p0 = Vector.new(box.pos.x-box.dim.x, box.pos.y-box.dim.y)
	local p1 = Vector.new(box.pos.x+box.dim.x, box.pos.y-box.dim.y)
	local p2 = Vector.new(box.pos.x+box.dim.x, box.pos.y+box.dim.y)
	local p3 = Vector.new(box.pos.x-box.dim.x, box.pos.y+box.dim.y)
	local a = Collider:newLine(p0, p1)
	local b = Collider:newLine(p1, p2)
	local c = Collider:newLine(p2, p3)
	local d = Collider:newLine(p3, p0)
	if collideLineLine(line, a) then return true end
	if collideLineLine(line, b) then return true end
	if collideLineLine(line, c) then return true end
	if collideLineLine(line, d) then return true end
	return false -- this will return false if line is fully inside of box!!
end

function collideLineLine(a, b)
	assert(a.type == "line")
	assert(b.type == "line")
	-- from http://stackoverflow.com/a/1968345
	local p0 = a.pos
	local p1 = a.pos+a.extend
	local p2 = b.pos
	local p3 = b.pos+b.extend

	local s1 = a.extend
	local s2 = b.extend

	local s = (-s1.y * (p0.x - p2.x) + s1.x * (p0.y - p2.y)) / (-s2.x * s1.y + s1.x * s2.y);
	local t = ( s2.x * (p0.y - p2.y) - s2.y * (p0.x - p2.x)) / (-s2.x * s1.y + s1.x * s2.y);

	if s >= 0 and s <= 1 and t >= 0 and t <= 1 then
		return true
	end
	return false
end

function collideCompoundCompound(a, b)
	assert(a.type == "compound")
	assert(b.type == "compound")
	print("Compound/Compound colission not implemented!")
end

function collideCompoundAny(compound, other)
	assert(compound.type == "compound")
	assert(other.type ~= "compound")
	print("Compound/Any colission not implemented!")
end

function Physics:collide(a, b)
	if a.pos:dist2(b.pos) >= ((a.radius+b.radius)*(a.radius+b.radius)) then
		return false
	end
	if a.type == "compound" or b.type == "compound" then
		if a.type == b.type then return collideCompoundCompound(a, b) else
			local compound = (a.type == "compound") and a or b
			local other = (a.type ~= "compound") and a or b
			return collideCompoundAny(compound, other)
		end

	elseif a.type == "circle" and b.type == "circle" then
		return true
	elseif (a.type == "aabox" and b.type == "circle")
		or (a.type == "circle" and b.type == "aabox") then
		local box = (a.type == "aabox") and a or b
		local circle = (a.type == "circle") and a or b
		return collideBoxCircle(box, circle)
	elseif (a.type == "line" and b.type == "circle")
		or (a.type == "circle" and b.type == "line") then
		local line = (a.type == "line") and a or b
		local circle = (a.type == "circle") and a or b
		return collideLineCircle(line, circle)
	elseif (a.type == "aabox" and b.type == "aabox") then
		return collideBoxBox(a, b)
	elseif (a.type == "line" and b.type == "aabox")
		or (a.type == "aabox" and b.type == "line") then
		local line = (a.type == "line") and a or b
		local box = (a.type == "aabox") and a or b
		return collideLineBox(line, box)
	elseif (a.type == "line" and b.type == "line") then
		return collideLineLine(a, b)
	end

	print("Should never fall through?")
	return false
end

function Physics:rayCast(ray)
	assert(ray.type == "line")
	local objs = {}
	for i=1,#self.icolliders do
		if self:collide(self.icolliders[i], ray) then
			table.insert(objs, self.icolliders[i])
		end
	end

	table.sort( objs, function (a, b)
		return (ray.pos-a.pos) > (ray.pos-b.pos)
	end )

	return objs
end

function Physics:addCollider(c)
	local i = table.remove(self.free) or (#self.icolliders + 1)
	self.colliders[c] = i
	self.icolliders[i] = c
	c:onAdded(self)
end

function Physics:removeCollider(c)
	local i = self.colliders[c]
	self.icolliders[i] = false
	self.colliders[c] = nil
	table.insert(self.free, i)
	c:onRemoved(self)
end