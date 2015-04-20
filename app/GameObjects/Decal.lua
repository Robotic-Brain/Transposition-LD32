require("GameObjects.GameObject")

Decal = GameObject:new()

function Decal:init(drawable, layer, preDraw, postDraw)
	assert(type(layer) == "number")
	GameObject.init(self)
	self:setName("Decal")
	self.drawable = drawable
	self:setDrawLayer(layer)
	self.preDraw = preDraw
	self.postDraw = postDraw
	return self
end

function Decal:draw()
	love.graphics.push()
	if self.preDraw then self.preDraw() end
	love.graphics.translate(self:getPosition():unpack())
	love.graphics.draw(self.drawable)
	if self.postDraw then self.postDraw() end
	love.graphics.pop()
end