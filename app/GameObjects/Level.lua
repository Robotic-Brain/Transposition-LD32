require("GameObjects.GameObject")
require("Collider")
Vector = require("hump.vector")

Level = GameObject:new()

Level._tiles = {}
for i=1,8 do
	Level._tiles[i] = love.graphics.newImage("images/tile0"..i..".png")
end
Level._obstacleIndex = 5 -- tiles above (including) this index are considered to be solid

function Level:init()
	GameObject.init(self)
	self:setName("Level")
	self.collider = Collider:newCompound():setOwner(self)
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
		print("addingBox: ", a, b)
	else
		a = args[1]
		b = args[2]
	end

	self.collider:addChild(Collider:newAABox((b-a):unpack()):setPosition(a+(b-a)/2):setOwner(self))
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

	self.collider:addChild(Collider:newLine(a,b):setOwner(self))
end

-- add collision line args: start/end point
function Level:addLineStrip( ... )
	local args = { ... }
	assert(#args >= 4)
	assert(#args%2 == 0)
	local prv = Vector.new(args[1], args[2])
	for i=3,#args,2 do
		local nxt = Vector.new(args[i], args[i+1])
		print("addingLine: ", prv, nxt)
		self.collider:addChild(Collider:newLine(prv, nxt):setOwner(self))
		prv = nxt
	end
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
					self:addBox(i*32, j*32, (i+1)*32, (j+1)*32)
				end
			end
		end
	end
	love.graphics.setCanvas()
	self:setDrawable(c)
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