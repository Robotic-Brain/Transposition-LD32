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