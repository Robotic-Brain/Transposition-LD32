require("GameObjects.GameObject")

TriggerZone = GameObject:new()

function TriggerZone:init(width, height, fnc, onPhase)
	GameObject.init(self)
	onPhase = onPhase or "beginContact"
	self:setName("TriggerZone")
	--self.drawable = love.graphics.newCanvas(width, height)
	self.collider = Collider:newAABox(width, height):setOwner(self):setTag("pierceable")
	self.collider.fixture:setSensor(true)
	--self:setDrawLayer(10)
	self.func = fnc
	self.dim = Vector.new(width, height)

	self.callback = function (phase, a, b )
		if a == self.collider.fixture or b == self.collider.fixture then
			if phase == onPhase then
				self.func((a == self.collider.fixture) and b or a)
			end
		end
	end

	--[[love.graphics.setCanvas(self.drawable)
	self.drawable:clear(255,0,0, 255)
	love.graphics.setCanvas() --]]
	return self
end

function TriggerZone:destroy()
	GameObject.destroy(self)
end

--[[function TriggerZone:draw()
	love.graphics.push()
	love.graphics.polygon("fill", self.collider.fixture:getBody():getWorldPoints(self.collider.fixture:getShape():getPoints()))
	love.graphics.translate(self:getPosition():unpack())
	love.graphics.translate((-self.dim/2):unpack())
	--love.graphics.draw(self.drawable)
	love.graphics.pop()
end --]]

function TriggerZone:onAddedToWorld()
	GameObject.onAddedToWorld(self)
	self:getWorld().physics:addCollisionListener(self.callback)
end

function TriggerZone:onRemoveFromWorld()
	self:getWorld().physics:removeCollisionListener(self.callback)
	GameObject.onRemoveFromWorld(self)
end