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
	return self
end

-- public: physics update
function GameObject:update(dt)
	-- body
end

-- public: render update
function GameObject:draw()
	-- body
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
	self.pos = vec
	if self.collider then
		self.collider:setPosition(self:getPosition())
	end
end

function GameObject:getPosition()
	return self.pos
end

function GameObject:move(vec)
	self:setPosition(self:getPosition() + vec)
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
	print("OnWorldAdded: "..tostring(self))
	if self.collider then
		self:getWorld().physics:addCollider(self.collider)
	end
end

function GameObject:getWorld()
	return self.world
end