require("class")
require("utils")
require("player")
require("projectile")
require("amoeba")


function love.load()
	math.randomseed(os.time())
	ship = love.graphics.newImage("gfx/ship2.png")
	shot = love.graphics.newImage("gfx/projectile.png")
	amoebaGfx = love.graphics.newImage("gfx/amoeba.png")
    bgGfx = love.graphics.newImage("gfx/bg.png")
    player = Player(400,300, 150, 5, .01)
    score = 0
	projectiles = {}
	entities = {}
	for i=1,100,1 do
        a =  Amoeba(math.random(800), math.random(600))
		table.insert(entities, a)
        while collides(a, player.rect) do
            a.x = math.random(800)
            a.y = math.random(600)
        end
	end
end


function love.update(dt)
    player:update(dt)

	for i,e in pairs(entities) do
		if not e:update(dt) then
			table.remove(entities, i)
		end
	end

	for i,p in pairs(projectiles) do
		if not p:update(dt) then
			table.remove(projectiles, i)
		end
	end
end

function love.draw()
    love.graphics.draw(bgGfx, 0, 0)
    player:draw()

	for i,e in pairs(entities) do
		e:draw()
	end

	for i,p in pairs(projectiles) do
		p:draw()
	end

	love.graphics.print(score, 0, 0)
end
