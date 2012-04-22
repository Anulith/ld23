Player = class()

function Player:__init(x, y, speed, rspeed, rateOfFire)
    self.x = x
    self.y = y
    self.r = 0
    self.speed = speed
    self.rspeed = rspeed
    self.rateOfFire = rateOfFire
    --self.rect = {}
    --self.rect.width = ship:getWidth()
    --self.rect.height = ship:getHeight()
    self.offsetX = ship:getWidth()  / 2
    self.offsetY = ship:getHeight() / 2
    --self:updateRect()
    self.fireDt = rateOfFire
    self.isDestroyed = false
    self.destroyedDt = 0
    self.spawnDt = 3
end

function Player:getRect()
    r = {}
    if self.isDestroyed or self.spawnDt > 0 then
        r.width = 0
        r.height = 0
        r.x = -1
        r.y = -1
    else
        r.width = ship:getWidth()
        r.height = ship:getHeight()
        r.x = self.x - self.offsetX
        r.y = self.y - self.offsetY
    end

    return r
end


function Player:reset(x, y)
    self.isDestroyed = false
    self.destroyedDt = 0
    self.spawnDt = 3
    self.x = x
    self.y = y
end

--[[function Player:updateRect()
    self.rect.x = self.x - self.offsetX
    self.rect.y = self.y - self.offsetY
end]]--

function Player:update(dt)
    if self.isDestroyed then
        self.destroyedDt = self.destroyedDt + dt

        self.piece1.r = self.piece1.r + self.piece1.rspeed * dt
        self.piece1.x = self.piece1.x + self.piece1.xspeed * dt
        self.piece1.y = self.piece1.y + self.piece1.yspeed * dt

        self.piece2.r = self.piece2.r + self.piece2.rspeed * dt
        self.piece2.x = self.piece2.x + self.piece2.xspeed * dt
        self.piece2.y = self.piece2.y + self.piece2.yspeed * dt

        self.piece3.r = self.piece3.r + self.piece2.rspeed * dt
        self.piece3.x = self.piece3.x + self.piece3.xspeed * dt
        self.piece3.y = self.piece3.y + self.piece3.yspeed * dt

        if self.destroyedDt > 3 then return false end
        return true
    end

    if self.spawnDt > 0 then
        self.spawnDt = self.spawnDt - dt
    end

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

    --self:updateRect()

	if love.keyboard.isDown("x") or love.keyboard.isDown("k") then
		self.speed = 300
	else
		self.speed = 150
	end

	if love.keyboard.isDown("=") then
		self.rateOfFire = self.rateOfFire - .001
	elseif love.keyboard.isDown("-") then
		self.rateOfFire = self.rateOfFire + .001
	end

    return true
end

function Player:draw()
    if self.isDestroyed then
        love.graphics.draw(shipP1, self.piece1.x, self.piece1.y, self.piece1.r)
        love.graphics.draw(shipP2, self.piece2.x, self.piece2.y, self.piece2.r)
        love.graphics.draw(shipP3, self.piece3.x, self.piece3.y, self.piece3.r)
        return
    end
    if self.spawnDt > 0 then
	    love.graphics.draw(spawning, self.x, self.y, self.r, 1, 1, self.offsetX, self.offsetY)
    else
	    love.graphics.draw(ship, self.x, self.y, self.r, 1, 1, self.offsetX, self.offsetY)
    end
end

function Player:destroy()
    if self.isDestroyed then return end
    --self.rect.x = -1
    --self.rect.y = -1
    --self.rect.width = 0
    --self.rect.height = 0
    self.isDestroyed = true
    self.piece1 = {x = self.x, y = self.y, r = 0, rspeed = math.random(5), xspeed = math.random(-10,10), yspeed = math.random(-10,10)}
    self.piece2 = {x = self.x, y = self.y, r = 0, rspeed = math.random(5), xspeed = math.random(-10,10), yspeed = math.random(-10,10)}
    self.piece3 = {x = self.x, y = self.y, r = 0, rspeed = math.random(5), xspeed = math.random(-10,10), yspeed = math.random(-10,10)}
end
