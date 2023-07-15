function love.load()

	platform = {}
	player = {}
	enemies = {}
	score = 0
	timeCounter = 0

	platform.width = love.graphics.getWidth()
	platform.height = love.graphics.getHeight()

	platform.x = 0
	platform.y = platform.height / 1.8

	player.x = love.graphics.getWidth() / 1.8
	player.y = love.graphics.getHeight() / 1.8
    enemies.y=love.graphics.getWidth() / 2.7

	player.speed = 200

	player.img = love.graphics.newImage('resources/images/leo.png')
	playerdroit = love.graphics.newImage('resources/images/leo.png')
	playergauche = love.graphics.newImage('resources/images/leogauche.png')
	background = love.graphics.newImage("resources/images/fond.jpg")
	enemyImg = love.graphics.newImage('resources/images/enemy.png')
	enemyWidth = enemyImg:getWidth() /5.5
	enemyHeight = enemyImg:getHeight()/5.5

    musicTrack = love.audio.newSource("resources/audio/Mercury.wav", "static")
  	musicTrack:setLooping(true)

	player.ground = player.y
	
	player.y_velocity = 0

	player.down = 300
	player.jump_height = -400
	player.gravity = -500

	success = love.window.setMode( 800, 450, boolean)

	-- Initialisation des variables de vagues d'ennemis
	waveCount = 1
	waveTimer = 0
	waveTimerMax = 10
	waveSpeedIncrease = 30
	musicTrack:play()
end

function love.update(dt)

	if score >= 10 then
		background = love.graphics.newImage("resources/images/fond1.jpg")
	end

	if score >= 20 then
		background = love.graphics.newImage("resources/images/fond2.jpg")
	end

	if score >= 30 then
		background = love.graphics.newImage("resources/images/fond3.jpg")
	end

	if love.keyboard.isDown('w') then
		playerdroit = love.graphics.newImage('resources/images/leo.png')
		playergauche = love.graphics.newImage('resources/images/leogauche.png')
	end

	if score >=10 and love.keyboard.isDown('x') then
		playerdroit = love.graphics.newImage('resources/images/antho.png')
		playergauche = love.graphics.newImage('resources/images/anthogauche.png')
		player.jump_height = -500
		player.gravity = -500
		player.down = 600
	end

	if score >= 15 and love.keyboard.isDown('c') then
		playerdroit = love.graphics.newImage('resources/images/thomas.png')
		playergauche = love.graphics.newImage('resources/images/thomasgauche.png')
		player.jump_height = -600
		player.gravity = -300
		player.down = 600
	end

	if score >= 20 and love.keyboard.isDown('v') then
		playerdroit = love.graphics.newImage('resources/images/mateo.png')
		playergauche = love.graphics.newImage('resources/images/mateogauche.png')
		player.jump_height = -700
		player.gravity = -200
		player.down = 1000
	end

	timeCounter = timeCounter + dt
	if timeCounter > 2 then
		score = score + 1
		timeCounter = 0
	end

	-- Mise à jour du timer de la vague d'ennemis
	waveTimer = waveTimer - (1 + waveCount / 2) * dt
	if waveTimer < 0 then
		waveTimer = waveTimerMax
		local enemySpeed = 100 + (waveCount - 1) * waveSpeedIncrease
		local enemy = {
			x = love.graphics.getWidth(),
			y = platform.y - enemyHeight,
			speed = enemySpeed,
			img = enemyImg,
			width = enemyWidth,
			height = enemyHeight
		}
		table.insert(enemies, enemy)
		waveCount = waveCount + 1
	end

	-- Mise à jour de la position des ennemis
	for i, enemy in ipairs(enemies) do
		enemy.x = enemy.x - enemy.speed * dt
		if enemy.x + enemy.width < 0 then
			table.remove(enemies, i)
		end
	end

	-- Déplacement du joueur
	if love.keyboard.isDown('right') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed * dt)
			player.img = playerdroit
		end
	elseif love.keyboard.isDown('left') then
		if player.x > 0 then 
			player.x = player.x - (player.speed * dt)
			player.img = playergauche
		end
    end

    if love.keyboard.isDown('up') then
		if player.y_velocity == 0 then
			player.y_velocity = player.jump_height
		end
	end

	if love.keyboard.isDown('down') then
		if player.y_velocity > 0 then
			player.y_velocity = player.down
		end
	end

    if player.y_velocity ~= 0 then
		player.y = player.y + player.y_velocity * dt
		player.y_velocity = player.y_velocity - player.gravity * dt
	end

	if player.y > player.ground then
		player.y_velocity = 0
    	player.y = player.ground
	end

	for i, enemy in ipairs(enemies) do
    if checkCollision(player.x-30, player.y-110, player.img:getWidth()-10, player.img:getHeight()-10,
            enemy.x, enemy.y, enemyImg:getWidth(), enemyImg:getHeight()) then
        -- Arrêtez le jeu en appelant la fonction love.event.quit()
		love.event.quit()
	end
end

end

function love.draw()
	
	for i = 0, love.graphics.getWidth() / background:getWidth() do
	   for j = 0, love.graphics.getHeight() / background:getHeight() do
		   love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
	   end
   end

   for _, enemy in ipairs(enemies) do
	   love.graphics.draw(enemyImg, enemy.x, enemies.y)
   end

   love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)

   love.graphics.print("Score: " .. score, 10, 10)

end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
   return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function playSound(sound)
    pitchMod = 0.8 + love.math.random(0, 10)/25
    sound:setPitch(pitchMod)
    sound:play()
  end