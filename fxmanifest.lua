fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Paradise'
description 'Custom Plate Script'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'scripting/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'scripting/server.lua'
}