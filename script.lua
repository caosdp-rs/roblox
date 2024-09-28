-- Configuração do jogador e do personagem
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configuração para detectar inimigos e atacar automaticamente
local distanciaAtaque = 50 -- Distância máxima para localizar inimigos
local intervaloAtaque = 1 -- Tempo entre ataques (em segundos)

-- Função para localizar inimigos mais próximos
local function encontrarInimigoProximo()
    local inimigoMaisProximo = nil
    local menorDistancia = distanciaAtaque
    
    -- Percorrer todos os NPCs (mobs) no jogo
    for _, inimigo in pairs(game.Workspace.Enemies:GetChildren()) do
        if inimigo:FindFirstChild("Humanoid") and inimigo.Humanoid.Health > 0 then
            local distancia = (inimigo.HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude
            if distancia < menorDistancia then
                menorDistancia = distancia
                inimigoMaisProximo = inimigo
            end
        end
    end
    
    return inimigoMaisProximo
end

-- Função para atacar o inimigo
local function atacarInimigo(inimigo)
    while inimigo.Humanoid.Health > 0 do
        -- Movimenta-se em direção ao inimigo
        humanoid:MoveTo(inimigo.HumanoidRootPart.Position)

        -- Executa o ataque (simula o clique do mouse)
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))

        -- Espera antes de realizar o próximo ataque
        wait(intervaloAtaque)
    end
end

-- Loop de auto farm
while true do
    local inimigo = encontrarInimigoProximo()
    
    if inimigo then
        -- Se encontrar um inimigo, move-se e ataca
        atacarInimigo(inimigo)
    else
        -- Caso não haja inimigos próximos, aguarda um pouco antes de tentar novamente
        wait(1)
    end
end
