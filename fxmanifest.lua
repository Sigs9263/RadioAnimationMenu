fx_version 'cerulean'
game 'gta5'

author 'Sigs'
description 'Radio Animation Menu'
version '2.0'

shared_script 'config.lua'
client_scripts {
    'dependencies/NativeUI.lua',
    'client.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/RadioOn.ogg',
    'html/RadioOff.ogg',
}