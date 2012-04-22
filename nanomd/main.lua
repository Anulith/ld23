require("class")
require("utils")
require("player")
require("projectile")
require("amoeba")
require("bacteria")
require("worm")


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
    wormGfx = love.graphics.newImage("gfx/worm.png")
    waveclearGfx = love.graphics.newImage("gfx/waveclear.png")

    font = love.graphics.newFont("chintzy_cpu_brk/chintzy.ttf", 12)
    love.graphics.setFont(font)

    love.filesystem.setIdentity("nanomd")
    highscores = {}
    if love.filesystem.exists("highscores.lst") then
        for line in love.filesystem.lines("highscores.lst") do
            table.insert(highscores, tonumber(line))
        end
    end

    player = Player(400,300, 20, 2, .16)
    score = 0
    lives = 2
    gameover = false
    gameoverDt = 3
    state = "intro"
    wave = 1
    freemen = {}

	projectiles = {}
	entities = {}
    setupWave()
end

function setupWave()
    for i=1,10 + wave*5,1 do
        table.insert(entities, Amoeba(math.random(800), math.random(600)))
    end

    if wave > 2 then
        for i=1,5 + wave*5,1 do
            table.insert(entities, Bacteria(math.random(800), math.random(600)))
        end
    end

    if wave > 5 then
        for i=1,wave,1 do
            table.insert(entities, Worm(math.random(800), math.random(600), 7))
        end
    end
end

function love.keypressed(key)
    if state == "intro" then
        if key == "return" then
            state = "game"
        else
            return
        end
    elseif state == "topten" then
        if key == "return" then
            state = "intro"
            entities = {}
            lives = 2
            wave = 1
            setupWave()
            gameoverDt = 3
            gameover = false
            player:reset(400,300, 20, 2, .2)
        else
            return
        end
    elseif state == "waveclear" then
        if key == "return" then
            if powerupChoice == 0 then
                player.speed = player.speed + 30
            elseif powerupChoice == 1 then
                player.rspeed = player.rspeed + .5
            else
                player.rateOfFire = player.rateOfFire - .02 
            end
            state = "game"
        elseif key == "down" then
            if powerupChoice < 2 then powerupChoice = powerupChoice + 1 end
        elseif key == "up" then
            if powerupChoice > 0 then powerupChoice = powerupChoice - 1 end
        end 
    end
end

function love.update(dt)
    if state == "waveclear" then return end

    if gameover and state ~= "topten" then
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
            player:reset(400,300)
        end
    end

	for i,e in pairs(entities) do
		if not e:update(dt) then
			table.remove(entities, i)
		end
	end

    if #entities == 0 then
        wave = wave + 1
        setupWave()
        player.spawnDt = 3
        state = "waveclear"
        powerupChoice = 0
    end

	for i,p in pairs(projectiles) do
		if not p:update(dt) then
			table.remove(projectiles, i)
		end
	end

    score10k = math.floor(score/10000)
    if score10k > 0 and freemen[score10k] == nil then
        freemen[score10k] = 1
        lives = lives + 1
    end
end

function love.draw()
    if state == "intro" then
        love.graphics.draw(introGfx, 0, 0)
        return
    elseif state == "waveclear" then
        love.graphics.draw(waveclearGfx, 200, 200)
        love.graphics.draw(ship, 320, 297 + 18 * powerupChoice, HALFPI, .5, .5, ship:getWidth()/2, ship:getHeight()/2)
        return
    end
    love.graphics.draw(bgGfx, 0, 0)

    if state == "topten" then
        love.graphics.print("TOP TEN SCORES", 75, 25, 0, 6,6)
        for i=1,#highscores,1 do
            if highscores[i] == score then
                love.graphics.setColor(255, 0, 0)
                love.graphics.print(i..". "..highscores[i], 300, 70 + i * 25, 0, 3,3)
                love.graphics.setColor(255,255,255)
            else
                love.graphics.print(i..". "..highscores[i], 300, 70 + i * 25, 0, 2, 2)
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
