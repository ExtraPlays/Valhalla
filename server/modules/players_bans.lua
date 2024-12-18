--- [[
---
--- This module is responsible for managing the bans of players.
---
--- ]]

local PlayersBansModule = {}

--- Ban a player by id
--- @param player_id number player id
--- @param reason string reason
--- @param duration string Ban duration (ex.: "1d", "2h", "30m", "1a")
--- @return unknown
function PlayersBansModule.Add(player_id, reason, duration)
  local reason = reason or "No reason provided."
  local expiration = "NULL"

  if duration then
    local seconds, err = Utils:convertTimeToSeconds(duration)
    if err then
      lib.print.error(err)
      return nil
    end
    expiration = ("DATE_ADD(NOW(), INTERVAL %d SECOND)"):format(seconds)
  end

  -- Monta a query SQL final
  local query = string.format(
    "INSERT INTO players_bans (player_id, reason, expiration) VALUES (?, ?, %s)",
    expiration
  )

  -- Executa a query
  return MySQL.insert.await(query, { player_id, reason })
end

--- Get the ban of a player
--- @param player_id number player id
--- @return table ban as informações do banimento
function PlayersBansModule.Get(player_id)
  return MySQL.single.await('SELECT * FROM players_bans WHERE player_id = ?', { player_id })
end

-- Check if a player is banned
--- @param player_id number player id
--- @return boolean
function PlayersBansModule.Check(player_id)
  local ban = MySQL.single.await('SELECT * FROM players_bans WHERE player_id = ?', { player_id })

  -- If the ban exists and the expiration is 0, then the player is banned.
  if ban then
    local expiration = ban.expiration or 0
    local expirationInSeconds = math.floor(expiration / 1000)
    if expirationInSeconds == 0 or expirationInSeconds > os.time() then
      return true
    else
      PlayersBansModule.Remove(player_id)
      return false
    end
  end

  return false
end

--- Remove a ban from a player
--- @param player_id number player id
--- @return unknown
function PlayersBansModule.Remove(player_id)
  return MySQL.update.await('DELETE FROM players_bans WHERE player_id = ?', { player_id })
end

return PlayersBansModule
