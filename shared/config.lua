Config = {}

--- Enable or disable maintenance mode (only admins can join)
Config.Maintenance = false

--- Default skin for new players
Config.DefaultSkin = {
  model = 'mp_f_freemode_01',
  components = {
    ["0"] = { drawable = 1, texture = 0 },  -- Máscara
    ["1"] = { drawable = 5, texture = 0 },  -- Cabelo
    ["3"] = { drawable = 15, texture = 0 }, -- Mãos
    ["4"] = { drawable = 10, texture = 0 }, -- Calça
    ["6"] = { drawable = 5, texture = 0 }   -- Sapatos
  }
}


return Config
