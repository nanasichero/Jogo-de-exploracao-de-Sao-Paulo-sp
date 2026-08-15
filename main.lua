function love.load()
    love.window.setMode(400, 700, {resizable = false, vsync = true})
    
    gameState = "creation"
    inputName = "Paulistano"
    
    -- Jogador a pé
    player = {
        x = 200,
        y = 500,
        width = 20,
        height = 20,
        speed = 140,
        inCar = false
    }
    
    -- Carro para explorar
    car = {
        x = 180,
        y = 350,
        width = 28,
        height = 50,
        speed = 220,
        color = {0.1, 0.5, 0.9}
    }
    
    -- Pontos turísticos e a sua Casa em SP
    landmarks = {
        {name = "Av. Paulista", x = 50, y = 100, w = 300, h = 35, color = {0.3, 0.3, 0.3}},
        {name = "Parque Ibirapuera", x = 80, y = 200, w = 240, h = 80, color = {0.2, 0.5, 0.2}},
        {name = "Minha Casa", x = 180, y = 600, w = 40, h = 40, color = {0.8, 0.3, 0.3}} -- Seu destino final!
    }
end

function love.update(dt)
    if gameState == "playing" then
        local currentSpeed = player.inCar and car.speed or player.speed
        
        -- Controles de movimento
        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            if player.inCar then car.y = car.y - currentSpeed * dt else player.y = player.y - currentSpeed * dt end
        end
        if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            if player.inCar then car.y = car.y + currentSpeed * dt else player.y = player.y + currentSpeed * dt end
        end
        if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            if player.inCar then car.x = car.x - currentSpeed * dt else player.x = player.x - currentSpeed * dt end
        end
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            if player.inCar then car.x = car.x + currentSpeed * dt else player.x = player.x + currentSpeed * dt end
        end
        
        -- Sincroniza o boneco com o carro se estiver dentro
        if player.inCar then
            player.x = car.x + 4
            player.y = car.y + 15
        end
        
        -- Checa se chegou na "Sua Casa"
        local casa = {x = 180, y = 600}
        local distCasa = math.sqrt((player.x - casa.x)^2 + (player.y - casa.y)^2)
        if distCasa < 35 then
            gameWon = true
        else
            gameWon = false
        end
    end
end

function love.draw()
    if gameState == "creation" then
        -- Tela de Criação de Avatar
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.rectangle("fill", 0, 0, 400, 700)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("=== SAO PAULO CITY ===", 90, 150, 0, 1.2, 1.2)
        love.graphics.print("Avatar: " .. inputName, 110, 220)
        love.graphics.print("Toque na tela para comecar a explorar", 60, 420)
        
    elseif gameState == "playing" then
        -- Fundo da cidade
        love.graphics.setColor(0.15, 0.15, 0.15)
        love.graphics.rectangle("fill", 0, 0, 400, 700)
        
        -- Desenha os locais de São Paulo
        for _, place in ipairs(landmarks) do
            love.graphics.setColor(place.color)
            love.graphics.rectangle("fill", place.x, place.y, place.w, place.h)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(place.name, place.x + 5, place.y + 5)
        end
        
        -- Desenha o Carro
        love.graphics.setColor(car.color)
        love.graphics.rectangle("fill", car.x, car.y, car.width, car.height)
        
        -- Desenha o Jogador (se a pé)
        if not player.inCar then
            love.graphics.setColor(0.9, 0.8, 0.2)
            love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
        end
        
        -- HUD / Mensagens na tela
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Explorador: " .. inputName, 15, 15)
        
        if gameWon then
            love.graphics.setColor(0.2, 1, 0.2)
            love.graphics.print("SUCESSO! Voce chegou em SUA CASA!", 70, 350)
        else
            if player.inCar then
                love.graphics.print("Dirigindo... Va para a Minha Casa!", 15, 35)
            else
                love.graphics.print("A pe. Toque perto do carro para entrar.", 15, 35)
            end
        end
    end
end

function love.touchpressed(id, x, y, dx, pressure)
    if gameState == "creation" then
        gameState = "playing"
    else
        -- Entrar/sair do carro por toque
        local distCar = math.abs(player.x - x) + math.abs(player.y - y)
        if distCar < 60 then
            player.inCar = not player.inCar
        else
            if not player.inCar then
                player.x = x
                player.y = y
            end
        end
    end
end

function love.keypressed(key)
    if gameState == "creation" then
        gameState = "playing"
    elseif key == "e" then
        player.inCar = not player.inCar
    end
end
