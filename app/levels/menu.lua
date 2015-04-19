return function (world)
	local screenCenter = Vector.new(love.graphics.getDimensions())/2

	local p = Player:new():init():setPosition(screenCenter)
	world:addObject(p)

	local cam = GameObject:new():init():setPosition(screenCenter)
	--world:addObject(cam)
	world:followObject(cam)

	--world:addObject(GridGO:new():init())

	-- setup level
	math.randomseed(42)
	local l = Level:new():init()
	local w, h = love.graphics.getDimensions()
	w = w / 32
	h = h / 32
	local str = string.rep("w", w)
	for i=1,h-2 do
		str = str.."\nw"
		for j=1,w-2 do
			str = str..Level._floorTiles[math.random(#Level._floorTiles)]
		end
		str = str.."w"
	end
	str = str.."\n"..string.rep("w", w)
	print(str)
	l:buildBackgroundFromText(w, h, str)
	world:addObject(l)

	-- setup trigger zones
	local z1 = TriggerZone:new():init(3*32, 1*32, function (o)
		if o:getUserData():getOwner() ~= p then return end
		THE_WORLD = World:new()
		THE_WORLD:init()
		THE_WORLD:loadLevel("Playground")
	end):setPosition(screenCenter-Vector.new(4.5*32, 0*32))
	world:addObject(z1)

	-- setup text
	local c1 = love.graphics.newCanvas(3*32, 1*32)
	love.graphics.setCanvas(c1)
	c1:clear(100,100,100,100)
	love.graphics.setColor(0,0,0,255)
	love.graphics.printf("Move here to Start!", 0, 0, 3*32, "center")
	love.graphics.setColor(255,255,255,255)
	love.graphics.setCanvas()
	local d1 = Decal:new():init(c1, 15):setPosition(screenCenter-Vector.new(4.5*32, 0*32)-Vector.new(3*32, 1*32)/2)
	world:addObject(d1)

	-- setup help text
	local c2 = love.graphics.newCanvas(300, 500)
	love.graphics.setCanvas(c2)
	c2:clear(150,150,150,150)
	love.graphics.setColor(0,0,0,255)
	love.graphics.setFont(love.graphics.newFont(16))
	love.graphics.printf(
[[


Welcome to my first Ludum Dare Game!

Ludum Dare 32
Theme: An Unconventional Weapon

How to play:
You can controll the character with "WASD" or ARROW keys.
SHIFT lets, you move slower, if you need to.
You activate the weapon with the LEFT MOUSE button, it will teleport you to the object you're aiming at.
You can use the RIGHT MOUSE button to drag objects towards you.
]], 0, 0, 300, "center")
	love.graphics.setColor(255,255,255,255)
	love.graphics.setCanvas()
	local d2 = Decal:new():init(c2, 15):setPosition(screenCenter-Vector.new(0, 250))
	world:addObject(d2)
end