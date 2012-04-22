Projectile = class()

function Projectile:__init(x, y, xspeed, yspeed)
	self.xspeed = xspeed
	self.yspeed = yspeed
	self.x = x
	self.y = y
	self.width = shot:getWidth()
	self.height = shot:getHeight()
end

function Projectile:update(dt)
	self.x = self.x + self.xspeed * dt
	self.y = self.y + self.yspeed * dt
	if self.x > 800 or self.y > 600 or self.x < 0 or self.y < 0 then
		return false
	end
	return true
end

function Projectile:draw()
	love.graphics.draw(shot, self.x, self.y)
end
