--- FIXME: CASO NAO FUNCIONE ALTERE PARA lib.require("server.modules.player")
local playerModule = require("server.modules.player")
local bansModule = require("server.modules.players_bans")

RegisterCommand("createPlayer", function(source, args)
  local license = "license:fake"
  local firstname = "Vitor"
  local lastname = "Barbosa"
  local groups = { "user", "admin" }
  local skin = Config.DefaultSkin

  local id = playerModule.CreateNewPlayer(license, firstname, lastname, json.encode(groups), json.encode(skin))
  lib.print.info("Player created with id: " .. id)
end, false)

RegisterCommand("getPlayer", function(source, args)
  local license = "steam:1100001106ae8dc"

  lib.print.info(playerModule.GetAllFromUser(license))
end, false)

RegisterCommand("getPlayerById", function(source, args)
  local id = args[1]
  local player = playerModule.Get(id)

  if not player then
    lib.print.error("Player not found")
    return
  end

  lib.print.info(player)
end, false)

RegisterCommand("updatePlayer", function(source, args)
  local id = 2
  local player = playerModule.Get(id)

  if not player then
    lib.print.error("Player not found")
    return
  end

  player.firstname = "Vitor"
  player.lastname = "Barbosa"

  lib.print.info(playerModule.Update(id, player))
end, false)

RegisterCommand("testBan", function(source, args)
  local id = args[1]
  local player = playerModule.Get(id)

  local author
  if source and tonumber(source) and source > 0 then
    local playerName = GetPlayerName(source)
    author = playerName or "Servidor"
  else
    author = "Servidor"
  end

  if not player then
    lib.print.error("Player not found")
    return
  end

  local duration = args[2]
  local reason = table.concat(args, " ", 3)

  bansModule.Add(id, reason, duration)
  lib.print.info(("Player %s (%s) foi banido por %s. Motivo: %s"):format(player.firstname, player.license, author, reason))

  DropPlayer(id, reason)
end, false)

RegisterCommand("testUnban", function(source, args)
  local id = args[1]
  local player = playerModule.Get(id)

  local author
  if source and tonumber(source) and source > 0 then
    local playerName = GetPlayerName(source)
    author = playerName or "Servidor"
  else
    author = "Servidor"
  end

  if not player then
    lib.print.error("Player not found")
    return
  end

  bansModule.Remove(id)
  lib.print.info(("Player %s (%s) foi desbanido por %s"):format(player.firstname, player.license, author))
end, false)
