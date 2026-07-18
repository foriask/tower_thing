require("objects.item_manager")
bullet_manager = {}
bullet_manager.__index = bullet_manager
function bullet_manager:new(_sprite, _pos, _vel, _dmg, _cust, _cust_movement, _cust_collider)
	local _table = {
		type = "bullets",
		sprite = _sprite,
		position = _pos or { 0, 0, 0 },
		velocity = _vel or { 0, 0 },
		damage = _dmg or 0,
		is_custom = _cust or false,
		custom_seek = _cust_movement,
		custom_collier = _cust_collider,
		matrix_pos = 0,
		-- Sprite is an existing sprite object.
		-- Position is [1] (first) for x and y is [2]
		-- Velocity is a vector from (0, 0) , x and y are the same
		-- Custom setting are defined by the bullet in particular
	}

	-- "modify obj.custom_collider_code() as a function if custom_collider is enables ,3 (;3 - .)")
	function _table:die()
		return "no"
		-- Originally, this function was "print("hewwo")". I liked that
	end
	_table.__index = _table
	return _table
end

function bullet_manager:bullet_death(_bullet, _obj, _here, _dt)
	if _obj and _obj.type == "enemy" then
		_obj:damage(_bullet.damage, _here, _dt)
	end
	_bullet.die(_here, _dt)
	_bullet = "clean"
	return _bullet
end

function bullet_manager:void_collide(_bullet, _matrix_pos, _dt)
	for _i, _thing in ipairs(tree_manager.matrix[_matrix_pos]) do
		if tree_manager[_thing[2]] and (#tree_manager[_thing[2]] >= _thing[1]) then
			local _obj = tree_manager[_thing[2]][_thing[1]]
			if _obj ~= "clean" then
				local _collision_list = {}
				local _collide, _here = collision_raycast(_bullet.position, _bullet.velocity, _obj)
				if _collide and not _collision_list.collide then
					_collision_list[1] = _obj
					_collision_list[2] = _here
					return true, _collision_list
				end
			end
		end
	end
	return false
end

function bullet_manager:check_matrix(_bullet, _number, _dt)
	local _matri_pos = _bullet.matrix_pos + _number
	if tree_manager.matrix[_matri_pos] then
		local _collide, _pack = self:void_collide(_bullet, _matri_pos, _dt)
		if _collide then
			return true, _pack
		end
	end
	return false, {}
end

function bullet_manager:collide(_bullets, _dt)
	if (not _bullets) or not #_bullets then
		return {}
	end
	local _new_pack = {}

	for _i, _bullet in ipairs(_bullets) do
		if _bullet ~= "clean" then
			local _collide, _pack = self:check_matrix(_bullet, 0, _dt)
			if _collide then
				_bullet = self:bullet_death(_bullet, _pack[1], _pack[2])
			end
			_new_pack[#_new_pack + 1] = _bullet
		end
	end
	return _new_pack
end

function bullet_manager:move(_bullets_pack, _dt)
	if (not _bullets_pack) or not #_bullets_pack then
		return {} -- The same as before
	end
	local _new_bullet_pack = {}
	local _i = 1
	for _a, _bullet in ipairs(_bullets_pack) do
		if _bullet ~= "clean" then
			if _bullet.is_custom then
				_bullet:custom_movement() -- custom things
			else
				_bullet.position =
					{ _bullet.velocity[1] * _dt + _bullet.position[1], _bullet.velocity[2] * _dt + _bullet.position[2] }
				-- Yes, it just sums the velocity. Most of them are just constant velocities, why bother doing more?
				-- THE ORDER IS PRETTY RELEVANT THERE, ADVISE: DON'T WORK WITH ME.
			end
			if _bullet.position[1] > (love.graphics.getPixelWidth() + 100) or _bullet.position[1] < -100 then
				_bullet = bullet_manager:bullet_death(_bullet, false, _dt)
			else
				if _bullet.position[2] > (love.graphics.getPixelHeight() + 100) or _bullet.position[2] < -100 then
					_bullet = bullet_manager:bullet_death(_bullet, false, _dt)
				end
			end -- Both borders check. One at a time for better performance (I don't know if that works... but it fell it)
			_new_bullet_pack[_i] = _bullet -- this is faster? lmao
			_i = _i + 1
		end
	end
	return _new_bullet_pack -- wawawa .3 (:3 - ·)
end
