Vector = require("hump.vector")

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
			self:collide(self.icolliders[i], self.icolliders[j])
		end
	end
end

function clamp(v, min, max)
	return Vector.new(
		math.min(math.max(min.x, v.x), max.x),
		math.min(math.max(min.y, v.y), max.y)
		)
end

function Physics:collide(a, b)
	if a.pos:dist2(b.pos) >= ((a.radius+b.radius)*(a.radius+b.radius)) then
		return false
	end
	if a.type == "circle" and b.type == "circle" then
		a:onCollision(b)
		b:onCollision(a)
		return true
	elseif (a.type == "aabox" and b.type == "circle")
		or (a.type == "circle" and b.type == "aabox") then
		local box = (a.type == "aabox") and a or b
		local circle = (a.type == "circle") and a or b
		-- from http://stackoverflow.com/a/1879223
		local closest = clamp(circle.pos, box.pos-(box.dim/2), box.pos+(box.dim/2))
		if circle.pos:dist2(closest) < (circle.radius*circle.radius) then
			a:onCollision(b)
			b:onCollision(a)
			return true
		end
	elseif (a.type == "line" and b.type == "circle")
		or (a.type == "circle" and b.type == "line") then
		local line = (a.type == "line") and a or b
		local circle = (a.type == "circle") and a or b
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
				a:onCollision(b)
				b:onCollision(a)
				return true
			end
			if t2 >= 0 and t2 <= 1 then
				a:onCollision(b)
				b:onCollision(a)
				return true
			end
		end
	end

	return false
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