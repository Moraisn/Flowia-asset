fx_version "cerulean"
game "gta5"

title "LB Phone - Flowia-App"
description "Application Flowia for LB Phone"
author "Moraisn"
version '1.0'

lua54 'yes'

client_script {
    'client.lua',
    'config.lua'
}

files {
    "ui/**/*"
}

ui_page "ui/index.html"
