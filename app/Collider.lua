Vector = require("hump.vector")
require("Physics")

Collider = {}

-- public: create new game object
function Collider:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.tags = {}
	return o
end

function Collider:__tostring()
	local str = "Generic Collider: Tags:"
	for k,v in pairs(self.tags) do
		str = str.." "..tostring(k).."="..tostring(v)..";"
	end
	return str
end

-- public: new circle collider with radius
function Collider:newCircle(r, dynHint)
	if type(dynHint) ~= "string" then dynHint = dynHint and "dynamic" or "static" end
	assert(type(dynHint) == "string")
	local o = self:new{
		fixture=love.physics.newFixture(
			love.physics.newBody(Physics._theWorld,0,0, dynHint),
			love.physics.newCircleShape(r), 1)
	}
	o.fixture:setUserData(o)
	--o.fixture:setRestitution(0)
	o.fixture:getBody():setLinearDamping(10)
	local c, m, g = o.fixture:getFilterData()
	o.mask = m
	o.fixture:setFilterData(c, 0, g)
	return o
end

--[[ public: new line collider with start/end
function Collider:newLine(s, e)
	local o = self:new{
		fixture=love.physics.newFixture(
			love.physics.newBody(Physics._theWorld,0,0, "dynamic"),
			love.physics.newCircleShape(r), 1)
	}
	o:setPosition(s)
	return o
end]]

-- public: new Axis aligned Box collider with width/height
function Collider:newAABox(w, h, dynHint)
	if type(dynHint) ~= "string" then dynHint = dynHint and "dynamic" or "static" end
	assert(type(dynHint) == "string")
	local o = self:new{
		fixture=love.physics.newFixture(
			love.physics.newBody(Physics._theWorld,0,0, dynHint),
			love.physics.newRectangleShape(w, h), 1)
	}
	o.fixture:setUserData(o)
	--o.fixture:setRestitution(0)
	o.fixture:getBody():setLinearDamping(10)
	local c, m, g = o.fixture:getFilterData()
	o.mask = m
	o.fixture:setFilterData(c, 0, g)
	return o
end

--[[ public: new Compound collider
function Collider:newCompound()
	local o = self:new{
		type="compound",
		childs={},
		radius=0
	}
 	return o
end]]

--[[function Collider:addChild(c)
	assert(self.type == "compound")
	assert(c.type ~= nil)
	table.insert(self.childs, c)
	self.radius = math.max(self.radius, c.pos:len()+c.radius)
	return self
end]]

function Collider:setPosition(p)
	self.fixture:getBody():setPosition(p:unpack())
	return self
end

function Collider:getPosition()
	return Vector.new(self.fixture:getBody():getPosition())
end

function Collider:setOwner(owner)
	self.owner = owner
	return self
end

function Collider:getOwner()
	assert(self.owner)
	return self.owner
end

function Collider:setTag(t, enable)
	if enable == nil then
		self.tags[t] = true
	else
		self.tags[t] = enable
	end
	print("Tag:", self.tags[t])
	return self
end

function Collider:getTag(t)
	return self.tags[t]
end

function Collider:onCollision(other)
	if self:getOwner() and type(self:getOwner().onCollision) == "function" then
		self:getOwner():onCollision(self, other)
	end
end

function Collider:onAdded()
	print("Collider onAdded: "..tostring(self).."->"..tostring(self:getOwner():getName()))
end

function Collider:onRemoved()
	print("Collider onRemoved: "..tostring(self))
end