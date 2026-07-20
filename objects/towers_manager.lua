tower_manager = {}
function tower_manager:new(_sprite, _pos, _modifiers, _bullet)
	local _table = {
		type = "towers",
		sprite = _sprite,
		position = _pos or { 0, 0, 0 },
		modifiers = _modifiers
			or { shot_speed = 1, bullet_quantity = 1, spatial_spread = 0, time_spread = 0, special = { [1] = none } }, -- Shot speed -> seconds - Specials are defined somewhere idk
		bullet = _bullet or {},
		matrix_pos = 0,
		-- Sprite is an existing sprite object (MORE THAN LÖVE IMAGE OBJ.).
		-- Position is [1] (first) for x and y is [2]
		-- Velocity is a vector from (0, 0) , x and y are the same
	}

	-- "modify obj.custom_collider_code() as a function if custom_collider is enables ,3 (;3 - .)")
	function _table:die()
		return "no"
		-- Originally, this function was "print("hewwo")". I liked that
	end
	_table.__index = _table
	return _table
end

function map_manager:draw(_time)
	for _i, _obj in ipairs(tree_manager.towers) do
		if _obj.sprite then
		else
			love.graphics.rectangle(
				"fill",
				_obj.position[1],
				_obj.position[2],
				map_manager.tile_size,
				map_manager.tile_size
			)
		end
	end
end
