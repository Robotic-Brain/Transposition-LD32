require("GameObjects.GameObject")
require("Collider")
Vector = require("hump.vector")

Level = GameObject:new()

Level._formatMap = {}  -- this mapps a character to a tileImage
Level._tagMap = {}  -- this mapps a character to a field configuration
Level._floorTiles = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","2","3"} -- contains floor tiles for random replacement
Level._formatMap["l"] = love.graphics.newImage("images/ladder.png"); Level._tagMap["l"] = "floor"
Level._formatMap["1"] = love.graphics.newImage("images/tile01.png"); Level._tagMap["1"] = "floor"
Level._formatMap["2"] = love.graphics.newImage("images/tile02.png"); Level._tagMap["2"] = "floor"
Level._formatMap["3"] = love.graphics.newImage("images/tile03.png"); Level._tagMap["3"] = "floor"
Level._formatMap["4"] = love.graphics.newImage("images/tile04.png"); Level._tagMap["4"] = "floor"
Level._formatMap["s"] = love.graphics.newImage("images/tile05.png"); Level._tagMap["s"] = "pierceable"
Level._formatMap["D"] = love.graphics.newImage("images/tile06.png"); Level._tagMap["D"] = "solid"
Level._formatMap["d"] = love.graphics.newImage("images/tile07.png"); Level._tagMap["d"] = "solid"
Level._formatMap["w"] = love.graphics.newImage("images/tile08.png"); Level._tagMap["w"] = "solid"
Level._formatMap["k"] = love.graphics.newImage("images/lava.png"); Level._tagMap["k"] = "kill"
Level._formatMap["p"] = love.graphics.newImage("images/lavaPit.png"); Level._tagMap["p"] = "kill"

Level._sounds = {}
Level._sounds.bluntDeath = love.audio.newSource("sounds/BluntDeath.wav")

function Level:init()
	GameObject.init(self)
	self:setName("Level")
	self.colliders = {}
	return self
end

-- args: p1, p2
-- p1 = left/top corner
-- p2 = right/bottom corner
function Level:addBox( ... )
	local args = { ... }
	assert(#args == 2 or #args == 4)
	local a = 0
	local b = 0
	if #args == 4 then
		a = Vector.new(args[1], args[2])
		b = Vector.new(args[3], args[4])
	else
		a = args[1]
		b = args[2]
	end
	print("addingBox: ", a, b)

	local col = Collider:newAABox((b-a):unpack()):setPosition(a+(b-a)/2):setOwner(self)
	table.insert(self.colliders, col)
	return col
end

-- add collision line args: start/end point
function Level:addLine( ... )
	local args = { ... }
	assert(#args == 2 or #args == 4)
	local a = 0
	local b = 0
	if #args == 4 then
		a = Vector.new(args[1], args[2])
		b = Vector.new(args[3], args[4])
	else
		a = args[1]
		b = args[2]
	end
	print("addingLine: ", a, b)

	local col = Collider:newLine(a,b):setOwner(self)
	table.insert(self.colliders, col)
	return col
end

-- add collision line args: start/end point
function Level:addLineStrip( ... )
	local args = { ... }
	assert(#args >= 4)
	assert(#args%2 == 0)
	local prv = Vector.new(args[1], args[2])
	local col = {}
	for i=3,#args,2 do
		local nxt = Vector.new(args[i], args[i+1])
		print("addingLine: ", prv, nxt)
		local col1 = Collider:newLine(prv, nxt):setOwner(self)
		table.insert(self.colliders, col1)
		table.insert(col, col1)
		prv = nxt
	end
	return col
end

-- position is given in tiles
function Level:addExit(pos, nextLevel)
	local tz = TriggerZone:new():init(32, 32, function (o)
		if o:getUserData():getOwner():getName() ~= "Player" then return end
		THE_WORLD = World:new()
		THE_WORLD:init()
		THE_WORLD:loadLevel(nextLevel)
	end):setPosition((pos*32)+Vector.new(16,16))
	self:getWorld():addObject(tz)
end

-- unknown chars are ignored
-- for mapping see on top of this file
function Level:buildBackgroundFromText(w, h, s)
	assert(w > 0)
	assert(h > 0)
	print("Load Level from string")
	local x = 0
	local y = 0
	local i = 0
	local c = love.graphics.newCanvas(w*32, h*32)
	love.graphics.setCanvas(c)
	while y <= h-1 and x <= w-1 and i < string.len(s) do
		local char = string.sub(s, i, i)
		local tileImg = Level._formatMap[char] or false
		if tileImg then
			love.graphics.draw(tileImg, x*32, y*32)
			if Level._tagMap[char] == "kill" then
				local tz = TriggerZone:new():init(32, 32, function (o)
					o:getUserData():getOwner():die()
					Level._sounds.bluntDeath:play()
				end):setPosition(Vector.new(x*32+16, y*32+16))
				THE_WORLD:addObject(tz)
			elseif Level._tagMap[char] ~= "floor" then
				self:addBox(x*32, y*32, (x+1)*32, (y+1)*32):setTag(Level._tagMap[char])
			end
			x = x + 1
			if x == w then
				x = 0
				y = y + 1
			end
		else
			print("unknown char: "..char)
		end
		i = i + 1
	end
	love.graphics.setCanvas()
	self:setDrawable(c)
end

function Level:onAddedToWorld()
	GameObject.onAddedToWorld(self)
	if self.colliders then
		for i=1,#self.colliders do
			self:getWorld().physics:addCollider(self.colliders[i])
		end
	end
end

function Level:setDrawable(d)
	self.drawable = d
end

function Level:draw()
	GameObject.draw(self)
	if self.drawable then
		love.graphics.draw(self.drawable)
	end
end