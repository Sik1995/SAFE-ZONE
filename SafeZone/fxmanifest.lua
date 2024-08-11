shared_script '@pablo/shared_fg-obfuscated.lua'
shared_script '@pablo/ai_module_fg-obfuscated.lua'
shared_script '@fiveguard/ai_module_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

name "basics"
description "FiveM Server Basics"
author "Kmoc#3214"
version "0.0.1"

shared_scripts {
	'shared/*.lua',
	'configs/*.lua',
	'config.lua'
}

client_scripts {
	'@qb-core/locale.lua',
	'locale.lua',
	'locales/en.lua',
	'client/*.lua'
}

server_scripts {
	'@qb-core/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'locales/en.lua',
	'server/*.lua'
}

ui_page 'html/index.html'

files {
	-- HTML Load
	'html/**',
}