Amoeba = class()

function Amoeba:__init(x, y)
	self.x = x
	self.y = y
	self.xspeed = math.random(-50, 50)
	self.yspeed = math.random(-50, 50)
	self.width = amoebaGfx:getWidth()
	self.height = amoebaGfx:getHeight()
	self.offsetX = self.width/2
	self.offsetY = self.height/2
end

function Amoeba:update(dt)
	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt
	if self.x < 0 then
		self.x = 0
		self.xspeed = -self.xspeed
	elseif self.x > (800 - self.width) then
		self.x = 800 - self.width
		self.xspeed = -self.xspeed
	end
	if self.y < 0 then
		self.y = 0
		self.yspeed = -self.yspeed
	elseif self.y > (600 - self.height) then
		self.y = 600 - self.height
		self.yspeed = -self.yspeed
	end
	for i,p in pairs(projectiles) do
		if(collides(self, p)) then
			table.remove(projectiles, i)
            score = score + 10
			return false
		end
	end
    if(collides(self, player:getRect())) then
        player:destroy()
        return false
    end
	return true
end

function Amoeba:draw()
	--scale = math.random(0.5, 2)
	scale = 1
	love.graphics.draw(amoebaGfx, self.x, self.y)
end
