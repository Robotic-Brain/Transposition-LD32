require("GameObjects.GameObject")
require("Collider")
Vector = require("hump.vector")

Level = GameObject:new()

Level._tiles = {}  -- this mapps a tileId to an immage
Level._formatMap = {}  -- this mapps a character to a tileId
Level._floorTiles = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","2","3"} -- contains floor tiles for random replacement
for i=1,8 do
	Level._tiles[i] = love.graphics.newImage("images/tile0"..i..".png")
	if i < 10 then
		Level._formatMap[tostring(i)] = i
	end
end

Level._formatMap["w"] = 8
table.insert(Level._tiles, love.graphics.newImage("images/ladder.png"))
Level._formatMap["l"] = #Level._tiles

Level._obstacleIndex = 5 -- tiles above (including) this index are considered to be solid
Level._solidIndex = 6	-- tiles below (excluding) this index are considered "transparent" for the teleport
						-- if a collider gets created below this index, it gets the tag "pierceable"

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
		local tileId = Level._formatMap[char] or -1
		if tileId > 0 and tileId <= #Level._tiles then
			print(x, y, tileId)
			love.graphics.draw(Level._tiles[tileId], x*32, y*32)
			if tileId >= Level._obstacleIndex then
				local tag = "solid"
				if tileId < Level._solidIndex then tag = "pierceable" end
				self:addBox(x*32, y*32, (x+1)*32, (y+1)*32):setTag(tag)
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

-- width, height, list of tiles (tttttt \n ttttttt)
-- map bounds are added automatically
function Level:buildBackground(w, h, ...)
	local t = {...}
	assert(#t == w*h)

	local c = love.graphics.newCanvas(w*32, h*32)
	love.graphics.setCanvas(c)
	for j=0,h-1 do
		for i=0,w-1 do
			local tileId = t[i+j*w + 1]
			if tileId > 0 and tileId <= #Level._tiles then
				love.graphics.draw(Level._tiles[tileId], i*32, j*32)
				if tileId >= Level._obstacleIndex then
					local tag = "solid"
					if tileId < Level._solidIndex then tag = "pierceable" end
					self:addBox(i*32, j*32, (i+1)*32, (j+1)*32):setTag(tag)
				end
			end
		end
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