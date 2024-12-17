--- [[
---
--- This module contains all the player related functions.
---
--- ]]

local PlayerModule = {}

local NOT_ALLOWED_TO_UPDATE = {
  id = true,
  created_at = true,
  updated_at = true
}

function PlayerModule.CreateNewPlayer(license, firstname, lastname, groups, skin)
  return MySQL.insert.await(
    [[
      INSERT INTO players (license, firstname, lastname, `groups`, skin)
      VALUES (?, ?, ?, ?, ?)
    ]],
    {
      license, firstname, lastname, groups, skin
    }
  )
end

--- Get player by license
--- @param license string
function PlayerModule.GetAllFromUser(license)
  local players = MySQL.query.await('SELECT * FROM players WHERE license = ?', { license })
  for k, v in next, players do
    players[k].groups = v.groups and json.decode(v.groups) or { 'user' }
    players[k].skin = v.skin and json.decode(v.skin) or { Config.DefaultSkin }
    players[k].metadata = v.metadata and json.decode(v.metadata) or {}
  end
  return players
end

function PlayerModule.Update(id, data)
  local xinfo = {}
  for k, v in next, data do
    if not NOT_ALLOWED_TO_UPDATE[k] then
      if type(v) == 'table' then
        v = "'" .. json.encode(v) .. "'" -- Convert table to json
      elseif type(v) == 'string' then
        v = "'" .. v .. "'"              -- Add quotes to string
      end

      xinfo[#xinfo + 1] = ("`%s` = %s"):format(k, v)
    end
  end

  local query = "UPDATE players SET " .. table.concat(xinfo, ', ') .. " WHERE id = ?"

  return MySQL.update.await(query, { id })
end

function PlayerModule.Get(id)
  local player = MySQL.single.await('SELECT * FROM players WHERE id = ?', { id })
  if player then
    player.skin = player.skin and json.decode(player.skin) or Config.DefaultSkin
    player.metadata = player.metadata and json.decode(player.metadata) or {}
    player.groups = player.groups and json.decode(player.groups) or { 'user' }
  end

  return player
end

function PlayerModule.GetByIdentifier(identifier)
  local player = MySQL.single.await('SELECT * FROM players WHERE license = ?', { identifier })
  if player then
    player.skin = player.skin and json.decode(player.skin) or Config.DefaultSkin
    player.metadata = player.metadata and json.decode(player.metadata) or {}
    player.groups = player.groups and json.decode(player.groups) or { 'user' }
  end

  return player
end

function PlayerModule.DeleteAll(license)
  return MySQL.update.await('DELETE FROM players WHERE license = ?', { license })
end

function PlayerModule.Delete(id)
  return MySQL.update.await('DELETE FROM players WHERE id = ?', { id })
end

return PlayerModule
