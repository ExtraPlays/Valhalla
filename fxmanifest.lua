fx_version 'cerulean'
game 'gta5'

author 'ExtraPlays'
description 'Valhalla Framework - Core'
version '0.0.1'

loadscreen_manual_shutdown 'yes'
lua54 'yes'
use_fxv2_oal 'true'

shared_scripts {
  '@ox_lib/init.lua',
  'shared/config.lua',
  'shared/utils.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/modules/*.lua',
  'server/events.lua',
  'server/main.lua',
}

client_scripts {
  'client/modules/*.lua',
  'client/events.lua',
  'client/main.lua',
}

ox_libs {
  'print'
}
