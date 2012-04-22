Worm = class()

function Worm:__init(x, y, numsegments)
	self.x = x
	self.y = y
    self.direction = 1
    if math.random(1) then
    	self.xspeed = 100
        self.yspeed = 0
    else
        self.xspeed = 0
	    self.yspeed = 100
    end
	self.width = wormGfx:getWidth()
	self.height = wormGfx:getHeight()
	self.offsetX = self.width/2
	self.offsetY = self.height/2
    self.timeBeforeDirectionChange = math.random(1,5)
    self.r = 0
    self.segments = {}
    for i=1,numsegments,1 do
        segment = {}
        segment.x = self.x
        segment.y = self.y
        segment.nextX = self.x
        segment.nextY = self.y
        segment.width = self.width
        segment.height = self.height
        --segment.x = self.x - i * wormGfx:getWidth()
        --segment.y = self.y - i * wormGfx:getHeight()
        table.insert(self.segments, segment)
    end
    self.segments[1].moving = true
end

function Worm:update(dt)
    self.timeBeforeDirectionChange = self.timeBeforeDirectionChange - dt
    if self.timeBeforeDirectionChange <= 0 then
        self.timeBeforeDirectionChange = math.random(1,5)
        if math.random(1) then self.direction = -self.direction end
        if math.random(1) then 
            swp = self.xspeed
            self.xspeed = self.yspeed
            self.yspeed = swp
        end
    end

	self.x = self.x + self.direction * self.xspeed * dt
	self.y = self.y + self.direction * self.yspeed * dt
	if self.x < 0 then
		self.x = 0
        self.direction = -self.direction
	elseif self.x > (800 - self.width) then
		self.x = 800 - self.width
        self.direction = -self.direction
	end
	if self.y < 0 then
		self.y = 0
		self.direction = -self.direction
	elseif self.y > (600 - self.height) then
		self.y = 600 - self.height
		self.direction = -self.direction
	end

    self.segments[1].x = self.x
    self.segments[1].y = self.y

    for i=2,#self.segments,1 do
        segment = self.segments[i]
        segment.x = segment.nextX
        segment.y = segment.nextY
        if self.xspeed ~= 0 then
            segment.nextX = self.segments[i-1].x - self.direction * self.width
            segment.nextY = self.segments[i-1].y
        else
            segment.nextY = self.segments[i-1].y - self.direction * self.height
            segment.nextX = self.segments[i-1].x
        end
        --[[if segment.moving then
            segment.x = segment.x + segment.direction * self.xspeed * dt
            segment.y = segment.y + segment.direction * self.yspeed * dt
            if segment.x < 0 then
                segment.x = 0
                segment.direction = -segment.direction
            elseif segment.x > (800 - self.width) then
                segment.x = 800 - self.width
                segment.direction = -segment.direction
            end
            if segment.y < 0 then
                segment.y = 0
                segment.direction = -segment.direction
            elseif segment.y > (600 - self.height) then
                segment.y = 600 - self.height
                segment.direction = -segment.direction
            end
        elseif math.abs(segment.x - self.segments[i-1].x) >= self.width or
               math.abs(segment.y - self.segments[i-1].y) >= self.height then
            segment.moving = true
        end
        if math.abs(segment.x - self.segments[i-1].x) > self.width then
            segment.x = segment.x + segment.direction * (math.abs(segment.x - self.segments[i-1].x) - self.width)
        end
        if math.abs(segment.y - self.segments[i-1].y) > self.width then
            segment.y = segment.y + segment.direction * (math.abs(segment.y - self.segments[i-1].y) - self.height)
        end]]--
    end 

	for i,p in pairs(projectiles) do
        for j,s in pairs(self.segments) do
            if(collides(s, p)) then
                table.remove(projectiles, i)
                table.remove(self.segments, j)
                score = score + 20
                if #self.segments == 0 then
                    return false
                end
            end
        end
	end
    for i,s in pairs(self.segments) do
        if(collides(s, player:getRect())) then
            table.remove(self.segments, i)
            player:destroy()
            return #self.segments ~= 0
        end
    end
	return true
end

function Worm:draw()
	--scale = math.random(0.5, 2)
	scale = 1
    for i,segment in pairs(self.segments) do
    	love.graphics.draw(wormGfx, segment.x, segment.y)
    end
end
