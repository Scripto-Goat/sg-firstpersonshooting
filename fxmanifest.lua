
fx_version 'cerulean'
game 'gta5'

lua54 'yes'

-- Information
author 'Scripto Goat'
description 'SG First Person Shooting'
version '1.0.0'

-- Client
client_script { 
    '@ox_lib/init.lua', 
    'main.lua', 
    'config/client.lua'
}

use_experimental_fxv2_oal 'yes'