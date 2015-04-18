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
	self.pos = {x = 0, y = 0}
end

-- public: physics update
function GameObject:update(dt)
	-- body
end

-- public: render update
function GameObject:draw()
	-- body
end

-- public: Sets position
-- every GameObject MUST have a position
function GameObject:setPosition(x, y)
	self.pos = self.pos or {}
	self.pos.x = x
	self.pos.y = y
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
end