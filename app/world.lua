require("GameObject")

-- World or "level" object
World = GameObject:new()

-- loads the given from string
function World:loadFromString( w )
	
end --]]

function World:init()
	self.time = 0
	self.cam = {}
	self.cam.x = 0
	self.cam.y = 0
	self.objects = {}
end

function World:addObject(o)
	self.objects[o] = true
	o:setWorld(self)
end

function World:removeObject(o)
	self.objects[o] = nil
	o:setWorld(nil)
end

function World:update(dt)
	self.time = self.time + dt
	for k,v in pairs(self.objects) do
		k:update(dt)
	end
end

function World:draw()
	love.graphics.push()
	--love.graphics.translate(math.sin(self.time) * 100, 0)
	for k,v in pairs(self.objects) do
		k:draw()
	end
	love.graphics.pop()
end