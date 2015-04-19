Vector = require("hump.vector")

GameObject = {}

-- public: create new game object
function GameObject:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

-- public: resets GameObject to initial state
function GameObject:init()
	print("Initializing GameObject")
	self:setPosition(Vector.new())
	self:setName("Generic GO")
	self:setDrawLayer(0)
	return self
end

function GameObject:__tostring()
	return tostring(self.getName())
end

-- public: physics update
function GameObject:update(dt)
	-- body
end

-- public: render update
function GameObject:draw()
	-- body
end

function GameObject:setDrawLayer(layer)
	self.drawLayer = layer
	return self
end

function GameObject:getDrawLayer()
	return self.drawLayer
end

function GameObject:setName(name)
	self.name = name
end

function GameObject:getName()
	return self.name
end

-- public: Sets position
-- every GameObject MUST have a position
function GameObject:setPosition(vec)
	assert(Vector.isvector(vec))
	self.pos = vec
	if self.collider then
		self.collider:setPosition(vec)
	end
	return self
end

function GameObject:getPosition()
	if self.collider then
		return self.collider:getPosition()
	else
		return self.pos
	end
end

function GameObject:move(vec)
	assert(false)
	assert(Vector.isvector(vec))
	self.collider.fixture:getBody():applyForce(vec:unpack())
	--self:setPosition(self:getPosition() + vec)
end

-- public: removes object from world and destroys it
function GameObject:destroy()
	if (self.world ~= nil) then
		self.world:removeObject(self)
	end
end

-- protected: Should only be called by World
function GameObject:setWorld(world)
	self.world = world
	self:onAddedToWorld()
end

function GameObject:onAddedToWorld()
	print("OnWorldAdded: "..self:getName())
	if self.collider then
		self:getWorld().physics:addCollider(self.collider)
	end
end

function GameObject:getWorld()
	return self.world
end