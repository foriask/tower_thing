require("objects.enemies_manager")
require("objects.item_manager")
require("player.controller")

-- To add a functions, just add a function to that "functions" and use its name in the controls file - easy
functions = {}

function functions:place_tower(_x, _y) end

function functions:debug_place_enemy(_x, _y)
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
end

function functions:debug_place_bullet(_x, _y)
	local _bullet = { nil, { _x, _y }, { 0, 10 }, 0 }
	tree_manager:index(bullet_manager:new(_bullet))
end

function functions:set_setting_debug()
	controller:save_controls("debug_place_enemy")
end
return functions
