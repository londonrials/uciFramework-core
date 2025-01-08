-- Basic Info
fx_version 'bodacious'
game 'gta5'

-- Resource Metadata
name 'UCI Framework Core'
description 'Core materials for the UCI Framework.'
author 'London Rials'
version '1.0.0'

-- Client Side Scripts
client_scripts {
    'config.lua',
    'client/cl-restrictions.lua'
}

-- Server Side Scripts
server_scripts {
    'config.lua',
    --'server/sv-restrictions.lua'
}

-- Shared Scripts
shared_scripts {
    'shared/shared.lua'
}