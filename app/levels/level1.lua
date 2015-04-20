return function (world)
	local p = Player:new():init()
	world:addObject(p)
	world:followObject(p)
	p:setPosition(Vector.new(100, 100))

	-- setup level
	local l = Level:new():init()
	
	l:buildBackgroundFromText(20, 20,[[
w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,p,1,1,1,1,x,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,p,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,p,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,p,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,p,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,p,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,p,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,w,w,w,w,w,w,w,w,w,w,w,
w,1,1,1,1,1,1,1,1,w,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,w,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,w,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,w,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,D,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,d,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,w,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,w,1,1,1,1,1,1,1,1,1,w,
w,1,1,1,1,1,1,1,1,w,1,1,1,1,1,1,1,1,l,w,
w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w
]]
		)
	world:addObject(l)

	-- setup objects
	world:addObject(Entity:new():init("crate"):setPosition(Vector.new(15*32+16, 2*32+16)):listenForDeath(function (o)
		world.timer.add(0.01, function () world:addObject(Entity:new():init("crate"):setPosition(Vector.new(15*32+16, 2*32+16)):listenForDeath(o.deathListener)) end)
		end))

	-- fake wall or "door"
	local door = Entity:new():init("wall"):setPosition(Vector.new(9*32+16, 15*32+16))
	world:addObject(door)

	-- add trigger
	local tz = TriggerZone:new():init(32, 32, function (o)
		if o:getUserData():getOwner():getName() ~= "Entity" then return end
		door:die()
	end):setPosition(Vector.new(19*32+16,1*32+16))
	world:addObject(tz)

	-- show dropper
	world:addObject(Decal:new():init(love.graphics.newImage("images/crate.png"), 9,
		function ()
			love.graphics.setColor(255,255,255,128)
		end,
		function ()
			love.graphics.setColor(255,255,255,255)
		end
		):setPosition(Vector.new(15*32, 2*32)))

	-- adding exit
	l:addExit(Vector.new(18, 18), "Menu")
end