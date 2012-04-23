Virus = class()

function Virus:__init(x, y)
	self.x = x
	self.y = y
    self.speed = 75
	self.width = virusGfx:getWidth()
	self.height = virusGfx:getHeight()
	self.offsetX = self.width/2
	self.offsetY = self.height/2
    self.hp = 3
end

function Virus:update(dt)
    if player.x > self.x then
        self.x = self.x + self.speed * dt
    elseif player.x < self.x then
        self.x = self.x - self.speed * dt
    end
    if player.y > self.y then
        self.y = self.y + self.speed * dt
    elseif player.y < self.y then
        self.y = self.y - self.speed * dt
    end
	--self.x = self.x + self.xspeed * dt
	--self.y = self.y + self.yspeed * dt
	--[[if self.x < 0 then
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
	end]]--
	for i,p in pairs(projectiles) do
		if(collides(self, p)) then
			table.remove(projectiles, i)
            self.hp = self.hp - 1
            if self.hp < 1 then
                score = score + 100
			    return false
            end
		end
	end
    if(collides(self, player:getRect())) then
        player:destroy()
        return false
    end
	return true
end

function Virus:draw()
	--scale = math.random(0.5, 2)
	scale = 1
	love.graphics.draw(virusGfx, self.x, self.y)
end
