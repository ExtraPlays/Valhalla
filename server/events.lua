local playerModule = require("server.modules.player")
local bansModule = require("server.modules.players_bans")

local players = {}
local tmp_players = {}

-- Evento de quando o jogador está conectando ao servidor
AddEventHandler("playerConnecting", function(name, _, deferrals)
  -- Aqui verificamos se o jogador existe no banco de dados e algumas outras coisas (ban, whitelist)

  local src = source
  deferrals.defer()
  deferrals.update("Verificando acesso no servidor... ")

  local steamIdentifier = GetSteamIdentifier(src)

  if not steamIdentifier then
    return deferrals.done("Você precisa estar conectado a uma conta Steam para jogar no servidor.")
  end

  if Config.Maintenance then
    return deferrals.done("O servidor está em manutenção no momento. Tente novamente mais tarde.")
  end

  local player = playerModule.GetByIdentifier(steamIdentifier)

  if not player then
    return deferrals.done("Você não possui uma conta no servidor. Crie uma conta no site.")
  end

  if bansModule.Check(player.id) then
    local ban = bansModule.Get(player.id)
    local banReason = ban.reason or "Sem motivo especificado."
    local banExpiration = ban.expiration == 0 and "Permanente" or os.date("%d/%m/%Y %H:%M:%S", ban.expiration)

    return deferrals.done(("Você está banido do servidor. Motivo: %s. Expira em: %s."):format(banReason, banExpiration))
  end

  if not player.allowlist then
    return deferrals.done("Você não possui acesso ao servidor, solicite a liberação. Seu id: " .. player.id)
  end

  tmp_players[steamIdentifier] = player
  deferrals.done()
end)

AddEventHandler("playerDropped", function(reason)
  -- Aqui removemos o jogador da lista de jogadores online e salvamos os dados dele no banco de dados
  local src = source

  if not players[src] then
    return
  end

  if players[src] then
    lib.print.info(("Jogador %s desconectado do servidor."):format(players[src].firstname))
  end
end)

-- Evento de quando o jogador está conectado ao servidor
AddEventHandler("playerJoining", function()
  -- Aqui adicionamos o jogador na lista de jogadores online e carregamos os dados dele do banco de dados (skin, inventario, etc...)

  local src = source

  local steamIdentifier = GetSteamIdentifier(src)

  if not steamIdentifier then
    return DropPlayer(src, "Você precisa estar conectado a uma conta Steam para jogar no servidor.")
  end

  if not tmp_players[steamIdentifier] then
    return DropPlayer(src, "Erro ao carregar os dados do jogador. Tente novamente ou entre em contato com o suporte.")
  end

  players[src] = tmp_players[steamIdentifier]
  players[src].actived = false

  Citizen.Wait(1000)

  tmp_players[steamIdentifier] = nil

  TriggerEvent("playerSpawn", src)
  lib.print.info(("Jogador %s conectado ao servidor."):format(players[src].firstname))
end)


--- CUSTOM EVENTS
--- TODO: Criar eventos customizados

-- Evento de quando o jogador está conectado ao servidor
AddEventHandler('playerSpawn', function()
  -- Ped do jogador criado no client
  local src = source
  TriggerClientEvent("core:client:update_skin", src, players[src])
  players[src].actived = true
end)


function GetSteamIdentifier(src)
  local steamIdentifier = nil

  for _, id in ipairs(GetPlayerIdentifiers(src)) do
    if string.find(id, "steam") then
      steamIdentifier = id
      break
    end
  end

  return steamIdentifier
end
