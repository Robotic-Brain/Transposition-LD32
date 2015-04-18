GameObject = {}

function GameObject:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function GameObject:update(dt)
	-- body
end

function GameObject:draw()
	-- body
end

function GameObject:setWorld(world)
	self.world = world
end

function GameObject:destroy()
	if (self.world ~= nil) then
		self.world:removeObject(self)
	end
end