Vector = require("hump.vector")
love.physics.setMeter(1)

Physics = {}
Physics._theWorld = nil

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
	print("Initializing physics world!!!")
	Physics._theWorld = love.physics.newWorld(0, 0)
	self.pworld = Physics._theWorld
	return self
end

function Physics:update(dt)
	self.pworld:update(dt)
end



function Physics:rayCast(ray)
	assert(ray.type == "ray")
	local objs = {}
	self.pworld:rayCast(ray.start.x, ray.start.y, ray.pend.x, ray.pend.y, function (f, hitX, hitY, nX, nY, t)
		local result = {}
		result.fix=f:getUserData()
		result.pos=t
		print("CastCollide", result.fix, result.pos)
		table.insert(objs, result)
		return -1 --keep going
	end)

	table.sort( objs, function (a, b)
		print("CastComp", a.pos, b.pos)
		return a.pos > b.pos
	end )
	--[[local result2 = {}
	for i=1,#objs do
		table.insert(result2, objs[i].fix)
	end]]

	--return result2
	return objs
end

function Physics:addCollider(c)
	local i = table.remove(self.free) or (#self.icolliders + 1)
	self.colliders[c] = i
	self.icolliders[i] = c
	local cat, m, g = c.fixture:getFilterData()
	c.fixture:setFilterData(cat, c.mask, g)
	c:onAdded(self)
end

function Physics:removeCollider(c)
	local i = self.colliders[c]
	self.icolliders[i] = false
	self.colliders[c] = nil
	table.insert(self.free, i)
	local cat, m, g = c.fixture:getFilterData()
	c.fixture:setFilterData(cat, 0, g)
	c:onRemoved(self)
end