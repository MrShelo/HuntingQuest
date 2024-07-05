fx_version 'cerulean'
games { 'gta5' }

author 'Patryk Sadłocha'


client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
    'client/functions.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
shared_script 'shared/config.lua'

dependencies { 
    'PolyZone' 
  }