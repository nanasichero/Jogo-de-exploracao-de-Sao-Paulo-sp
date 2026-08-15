function love.load()
    -- Configurações da tela para celular
    love.window.setMode(400, 700, {resizable=true, vsync=true})
    
    -- Dados do Jogador / Avatar
    player = {
        x = 200,
        y = 350,
        size = 40,
        speed = 150,
        name = "Paulistano"
    }
    
    gameState = "creation" -- Estados: "creation" ou "playing"
    inputName = "Alex"
end

function love.update(dt)
    if gameState == "playing" then
        -- Simulação de controles básicos (ou toque na tela)
        if love.keyboard.isDown("up") then player.y = player.y - player.speed * dt end
        if love.keyboard.isDown("down") then player.y = player.y + player.speed * dt end
        if love.keyboard.isDown("left") then player.x = player.x - player.speed * dt end
        if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    end
end

function love.draw()
    if gameState == "creation" then
        love.graphics.print("=== CRIACAO DE AVATAR ===", 80, 100, 0, 1.2, 1.2)
        love.graphics.print("Nome do personagem: " .. inputName, 80, 160)
        love.graphics.print("Toque na tela ou Pressione ENTER para comecar", 50, 300)
    elseif gameState == "playing" then
        -- Fundo simulando a cidade de São Paulo
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        
        -- Indicador de Localização
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Local: Avenida Paulista - SP", 20, 20)
        
        -- Desenha o Avatar
        love.graphics.setColor(0.9, 0.3, 0.3)
        love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(player.name, player.x - 5, player.y - 20)
    end
end

function love.keypressed(key)
    if gameState == "creation" and (key == "return" or key == "space") then
        gameState = "playing"
    end
end

function love.touchpressed(id, x, y, dx, pressure)
    if gameState == "creation" then
        gameState = "playing"
    else
        -- Movimentação simples por toque na tela (move o avatar para o local tocado)
        player.x = x - player.size / 2
        player.y = y - player.size / 2
    end
end
