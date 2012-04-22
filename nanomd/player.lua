Player = class()

function Player:__init(x, y, speed, rspeed, rateOfFire)
    self.x = x
    self.y = y
    self.r = 0
    self.speed = speed
    self.rspeed = rspeed
    self.rateOfFire = rateOfFire
    self.rect = {}
    self.rect.width = ship:getWidth()
    self.rect.height = ship:getHeight()
    self.offsetX = self.rect.width / 2
    self.offsetY = self.rect.height / 2
    self:updateRect()
    self.fireDt = rateOfFire
end

function Player:updateRect()
    self.rect.x = self.x - self.offsetX
    self.rect.y = self.y - self.offsetY
end

function Player:update(dt)
	if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
		self.r = self.r + dt * self.rspeed
	elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		self.r = self.r - dt * self.rspeed
	end
	self.fireDt = self.fireDt + dt
	if love.keyboard.isDown("z") or love.keyboard.isDown("j") then
		if self.rateOfFire < self.fireDt then
			self.fireDt = 0
			table.insert(projectiles, Projectile(self.x, self.y, math.cos(self.r - HALFPI) * 500, math.sin(self.r - HALFPI) * 500))
		end
	end
	
	if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		self.x = self.x + (math.cos(self.r - HALFPI) *  self.speed * dt)
		if self.x < self.offsetX then
			self.x = self.offsetX 
		elseif self.x > (800 - self.offsetX) then
			self.x = 800 - self.offsetX
		end

		self.y = self.y + (math.sin(self.r - HALFPI) * self.speed * dt)
		if self.y < self.offsetY then
			self.y = self.offsetY
		elseif self.y > (600 - self.offsetY) then
			self.y = 600 - self.offsetY
		end
	end

    self:updateRect()

	if love.keyboard.isDown("x") then
		self.speed = 300
	else
		self.speed = 150
	end

	if love.keyboard.isDown("=") then
		self.rateOfFire = self.rateOfFire - .001
	elseif love.keyboard.isDown("-") then
		self.rateOfFire = self.rateOfFire + .001
	end
end

function Player:draw()
	love.graphics.draw(ship, self.x, self.y, self.r, 1, 1, self.offsetX, self.offsetY)
    love.graphics.print(self.rateOfFire, 0, 20)
end
