Vector = require("hump.vector")
love.physics.setMeter(32)

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
	self.collisionListeners = {}
	self.free = {}
	print("Initializing physics world!!!")
	Physics._theWorld = love.physics.newWorld(0, 0)
	self.pworld = Physics._theWorld
	self.pworld:setCallbacks(
		function (...)
			return self:dispatchCollision("beginContact", ...)
		end,
		function (...)
			return self:dispatchCollision("endContact", ...)
		end,
		function (...)
			return self:dispatchCollision("preSolve", ...)
		end,
		function (...)
			return self:dispatchCollision("postSolve", ...)
		end
		)
	return self
end

function Physics:destroy()
	Physics._theWorld:destroy()
end

function Physics:dispatchCollision(phase, ...)
	assert(phase == "beginContact"
		or phase == "endContact"
		or phase == "preSolve"
		or phase == "postSolve"
		)
	for k,v in pairs(self.collisionListeners) do
		if type(k) == "function" then
			k(phase, ...)
		end
	end
end

function Physics:addCollisionListener(fnc)
	assert(type(fnc) == "function")
	print("Collision listener added")
	self.collisionListeners[fnc] = true
end

function Physics:removeCollisionListener(fnc)
	assert(type(fnc) == "function")
	print("Collision listener removed")
	self.collisionListeners[fnc] = nil
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
		table.insert(objs, result)
		return -1 --keep going
	end)

	table.sort( objs, function (a, b)
		return a.pos > b.pos
	end )
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