Utils = {}

--- Convert time expressions to seconds
--- @param expression string time expression (1a, 1d, 1h, 1m)
function Utils:convertTimeToSeconds(expression)
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

return Utils
