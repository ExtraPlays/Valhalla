--- [[
---
--- This module is responsible for managing the bans of players.
---
--- ]]

local PlayersBansModule = {}


local function convertTimeToSeconds(expression)
  local timeUnit = string.sub(expression, -1):lower()       -- Get the last character of the string
  local timeValue = tonumber(string.sub(expression, 1, -2)) -- Get the value of the string without the last character (time unit)

  if not timeValue or timeValue <= 0 then
    return nil, "Invalid time value. Use expressions like 1a, 1d, 1h, 1m"
  end

  local seconds = 0
  if timeUnit == "m" then
    seconds = timeValue * 60       -- minutes
  elseif timeUnit == "h" then
    seconds = timeValue * 3600     -- hours
  elseif timeUnit == "d" then
    seconds = timeValue * 86400    -- days
  elseif timeUnit == "a" then
    seconds = timeValue * 31536000 -- years
  else
    return nil, "Invalid time unit. Use 'a', 'd', 'h', 'm'"
  end

  return seconds
end

--- Ban a player by id
--- @param player_id number player id
--- @param reason string reason
--- @param duration string Ban duration (ex.: "1d", "2h", "30m", "1a")
--- @return unknown
function PlayersBansModule.Add(player_id, reason, duration)
  local reason = reason or "No reason provided."
  local expiration = nil

  if duration then
    local seconds, err = convertTimeToSeconds(duration)
    if err then
      lib.print.error(err)
      return nil
    end
    expiration = ("DATE_ADD(NOW(), INTERVAL %d SECOND)"):format(seconds)
  end

  local query = [[
    INSERT INTO players_bans (player_id, reason, expiration)
    VALUES (?, ?, %s)
  ]]

  query = expiration and query:format("DATE_ADD(NOW(), INTERVAL ? SECOND)") or query:format("NULL")

  return MySQL.insert.await(query, { player_id, reason, expiration })
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
    if ban.expiration == 0 then
      return true
    else
      -- If the expiration is greater than the current time, then the player is banned.
      if ban.expiration > os.time() then
        return true
      else
        PlayersBansModule.Remove(player_id)
        return false
      end
    end
  else
    return false
  end
end

--- Remove a ban from a player
--- @param player_id number player id
--- @return unknown
function PlayersBansModule.Remove(player_id)
  return MySQL.delete.await('DELETE FROM players_bans WHERE player_id = ?', { player_id })
end

return PlayersBansModule
