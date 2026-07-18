require("objects.enemies_manager")
require("objects.item_manager")

functions = {}

function functions.place_tower(_x, _y) end

function functions.debug_place_enemy(_x, _y)
	tree_manager:index(enemies_manager:set_enemie(nil, { _x, _y }, 5, 0, { type = "c", radius = 5 }, { 2, 2 }))
end
