Vector = require("hump.vector")

InputManager = {}

-- returns movent in [-1...1] range as vector
function InputManager.getMovement()
	local x = 0
	local y = 0
	if love.keyboard.isDown("a") then
		x = -1
	elseif love.keyboard.isDown("d") then
		x = 1
	end

	if love.keyboard.isDown("w") then
		y = -1
	elseif love.keyboard.isDown("s") then
		y = 1
	end

	return Vector.new(x, y)
end

-- returns true if "Fire" button was hit last frame
function InputManager:didFire()
	return self.fireState
end

function InputManager:update(dt)
	if love.mouse.isDown("l") and not self.lastMouseState then
		self.fireState = true
	else
		self.fireState = false
	end

	self.lastMouseState = love.mouse.isDown("l")
end