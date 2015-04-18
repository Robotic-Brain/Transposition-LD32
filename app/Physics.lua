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

function Physics:collide(a, b)
	if a.pos:dist2(b.pos) >= ((a.radius+b.radius)*(a.radius+b.radius)) then
		return
	end
	if a.type == "circle" and b.type == "circle" then
		a:onCollision(b)
		b:onCollision(a)
		return
	end
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