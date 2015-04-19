Vector = require("hump.vector")

InputManager = {}

-- returns movent in [-1...1] range as vector
function InputManager.getMovement()
	local x = 0
	local y = 0
	if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
		x = -1
	elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		x = 1
	end

	if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		y = -1
	elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		y = 1
	end

	if love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift") then
		x = x/2
		y = y/2
	end

	return Vector.new(x, y)
end

-- returns true if "Fire" button was hit last frame
function InputManager:didFire()
	return self.fireState
end

function InputManager:didFire2()
	return love.mouse.isDown("r")
end

function InputManager:update(dt)
	if love.mouse.isDown("l") and not self.lastMouseState then
		self.fireState = true
	else
		self.fireState = false
	end

	self.lastMouseState = love.mouse.isDown("l")
end