require("GameObjects.GameObject")
Timer = require("hump.timer")
require("Physics")

-- World or "level" object
World = GameObject:new()

-- loads the given level
function World:loadLevel( name )
	self:destroy()
	self:init()
	print("Loading level: "..name)
	require("levels."..name)(self)
	package.loaded["levels."..name] = nil
end --]]

function World:init()
	GameObject.init(self)
	print("Initializing World")
	self.time = 0
	self.timer = Timer.new()
	self.objects = {}
	self.physics = Physics:new():init()
	self:followObject(nil)
end

function World:destroy()
	GameObject.destroy(self)
	for k,v in pairs(self.objects) do
		k:destroy()
	end

	if self.follow then
		self.follow:destroy()
	end

	self.physics:destroy()
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
	self.physics:update(dt)
	if self.follow then
		self:setPosition(-self.follow:getPosition())
	end
	self.time = self.time + dt
	self.timer.update(dt)
	for k,v in pairs(self.objects) do
		k:update(dt)
	end
end

-- public: draw all GameObjects added to world
function World:draw()
	love.graphics.push()
	love.graphics.translate(self.pos:unpack())
	love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	local drawQueue = {}
	for k,v in pairs(self.objects) do
		table.insert(drawQueue, k)
	end
	table.sort(drawQueue, function (a, b)
		return a:getDrawLayer() < b:getDrawLayer()
	end)
	for i=1,#drawQueue do
		drawQueue[i]:draw()
	end
	love.graphics.pop()
end

function World:followObject(o)
	self.follow = o
end