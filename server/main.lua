--- FIXME: CASO NAO FUNCIONE ALTERE PARA lib.require("server.modules.player")
local playerModule = require("server.modules.player")

lib.print.info(playerModule)

RegisterCommand("createPlayer", function(source, args)
  local license = "license:fake"
  local firstname = "Vitor"
  local lastname = "Barbosa"
  local groups = { "user", "admin" }
  local skin = { model = "mp_m_freemode_01", drawables = {}, textures = {} }

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
