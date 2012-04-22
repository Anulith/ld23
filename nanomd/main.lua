require("class")
require("utils")
require("player")
require("projectile")
require("amoeba")
require("bacteria")


function love.load()
	math.randomseed(os.time())
	ship = love.graphics.newImage("gfx/ship2.png")
    spawning = love.graphics.newImage("gfx/ship-spawning.png")
    shipP1 = love.graphics.newImage("gfx/ship-piece1.png")
    shipP2 = love.graphics.newImage("gfx/ship-piece2.png")
    shipP3 = love.graphics.newImage("gfx/ship-piece3.png")
    
	shot = love.graphics.newImage("gfx/projectile.png")
	amoebaGfx = love.graphics.newImage("gfx/amoeba.png")
    bacteriaGfx = love.graphics.newImage("gfx/bacteria.png")
    bgGfx = love.graphics.newImage("gfx/bg.png")
    gameoverGfx = love.graphics.newImage("gfx/gameover.png")

    player = Player(400,300, 150, 5, .01)
    score = 0
    lives = 2
    gameover = false
	projectiles = {}
	entities = {}
	for i=1,20,1 do
        a =  Bacteria(math.random(800), math.random(600))
		table.insert(entities, a)
        while collides(a, player:getRect()) do
            a.x = math.random(800)
            a.y = math.random(600)
        end
	end
	for i=1,20,1 do
        a =  Amoeba(math.random(800), math.random(600))
		table.insert(entities, a)
        while collides(a, player:getRect()) do
            a.x = math.random(800)
            a.y = math.random(600)
        end
	end
end


function love.update(dt)
    if not player:update(dt) then
        lives = lives - 1
        if lives < 0 then
            gameover = true
        else
            player:reset()
        end
    end

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

    for i=1, lives, 1 do
        love.graphics.draw(ship, 800-ship:getWidth()*i - 10, 0)
    end

    if gameover then
        love.graphics.draw(gameoverGfx, 400, 300, 0, 1, 1, gameoverGfx:getWidth()/2, gameoverGfx:getHeight()/2)
    end
end
