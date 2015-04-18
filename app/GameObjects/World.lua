require("GameObjects.GameObject")

-- World or "level" object
World = GameObject:new()

-- loads the given from string
function World:loadFromString( w )
	
end --]]

function World:init()
	GameObject.init(self)
	print("Initializing World")
	self.time = 0
	self.objects = {}
end

-- public: adds object to world and sets world of object
function World:addObject(o)
	self.objects[o] = true
	o:setWorld(self)
end

-- public: remove object from world
-- object is not destroyed (might be garbage collected)
function World:removeObject(o)
	self.objects[o] = nil
	o:setWorld(nil)
end

-- public: update all Gameobjects added to world
function World:update(dt)
	self.time = self.time + dt
	for k,v in pairs(self.objects) do
		k:update(dt)
	end
end

-- public: draw all GameObjects added to world
function World:draw()
	love.graphics.push()
	--love.graphics.translate(math.sin(self.time) * 100, 0)
	for k,v in pairs(self.objects) do
		k:draw()
	end
	love.graphics.pop()
end