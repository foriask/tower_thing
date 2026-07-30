require("objects.enemies_manager")
require("objects.item_manager")
require("objects.towers_manager")
require("map.map_manager")
require("player.controller")

-- To add a functions, just add a function to that "functions" and use its name in the controls file - easy
functions = {}

function functions:debug_place_enemy(_x, _y)
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
	tree_manager:index(enemies_manager:new(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
end

function functions:debug_place_bullet(_x, _y)
	local _bullet = { nil, { _x, _y }, { 0, 2 }, 0 }
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
	tree_manager:index(bullet_manager:new(_bullet))
end

function functions:debug_place_tower(_x, _y)
	tree_manager:index(tower_manager:new(nil, { _x, _y }))
end

function functions:set_setting_debug()
	controller:save_controls("debug_place_enemy")
end

function functions:debug_change_map(_x, _y)
	map_manager:change_tile_color(_x, _y, 255, 0, 0)
end
return functions
