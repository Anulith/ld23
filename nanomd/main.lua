require("class")
require("utils")
require("player")
require("projectile")
require("amoeba")
require("bacteria")


function love.load()
    love.graphics.setCaption("NANO M.D.")
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
    introGfx = love.graphics.newImage("gfx/intro.png")

    font = love.graphics.newFont("chintzy_cpu_brk/chintzy.ttf", 12)
    love.graphics.setFont(font)

    love.filesystem.setIdentity("nanomd")
    highscores = {}
    if love.filesystem.exists("highscores.lst") then
        for line in love.filesystem.lines("highscores.lst") do
            table.insert(highscores, tonumber(line))
        end
    end

    player = Player(400,300, 150, 5, .01)
    score = 0
    lives = 0
    gameover = false
    gameoverDt = 3
    state = "intro"
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
    if state == "intro" then
        if love.keyboard.isDown("return") then
            state = "game"
        else
            return
        end
    elseif state == "topten" then
        if love.keyboard.isDown("return") then
            state = "intro"
            lives = 2
            gameoverDt = 3
        else
            return
        end
    elseif gameover then
        gameoverDt = gameoverDt - dt
        if gameoverDt < 0 then
            state = "topten"
            table.insert(highscores, score)
            table.sort(highscores, function(a,b) return a>b end)
            if #highscores > 10 then
                table.remove(highscores, 11)
            end
            local data = ""
            for i, hs in pairs(highscores) do
                data = data .. hs .. "\n"
            end
            love.filesystem.write("highscores.lst", data)
        end
    end

    if not player:update(dt) and not gameover then
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
    if state == "intro" then
        love.graphics.draw(introGfx, 0, 0)
        return
    end
    love.graphics.draw(bgGfx, 0, 0)

    if state == "topten" then
        love.graphics.print("TOP TEN SCORES:", 300, 25, 0, 3, 3)
        for i=1,#highscores,1 do
            if highscores[i] == score then
                love.graphics.setColor(255, 0, 0)
                love.graphics.print(i..". "..highscores[i], 300, 50 + i * 15, 0, 2, 2)
                love.graphics.setColor(255,255,255)
            else
                love.graphics.print(i..". "..highscores[i], 300, 50 + i * 15, 0, 2, 2)
            end
        end
        return
    end

    player:draw()

	for i,e in pairs(entities) do
		e:draw()
	end

	for i,p in pairs(projectiles) do
		p:draw()
	end

	love.graphics.print("SCORE: "..score, 0, 0, 0, 2, 2)

    for i=1, lives, 1 do
        love.graphics.draw(ship, 800-ship:getWidth()*i - 10, 0)
    end

    if gameover then
        love.graphics.draw(gameoverGfx, 400, 300, 0, 1, 1, gameoverGfx:getWidth()/2, gameoverGfx:getHeight()/2)
    end
end
