bullet_manager = {}
bullet_manager.__index = bullet_manager
function bullet_manager:new(_sprite, _pos, _vel, _dmg, _cust, _cust_movement, _cust_collider_code, _cust_collider)
	local _table = {
		sprite = _sprite,
		position = _pos,
		velocity = _vel,
		damage = _dmg or 0,
		is_custom = _cust or false,
		custom_seek = _cust_movement,
		custom_collider_code = _cust_collider_code,
		custom_collider = _cust_collider,
		-- Sprite is an existing sprite object.
		-- Position is [1] (first) for x and y is [2]
		-- Velocity is a vector from (0, 0) , x and y are the same
		-- Custom setting are defined by the bullet in particular
	}
	function _table:die()
		return "no"
		-- Originally, this function was "print("hewwo")". I liked that
	end
	_table.__index = _table
	return _table
end

function bullet_manager:bullet_death(_bullet, _obj, _dt)
	local _xd = _obj and _obj:damage(_bullet.damage)
	_bullet.die(_dt)
	_bullet = "clean"
end

function bullet_manager:collide(_bullets_pack, _enemies_pack, _towers_pack, _dt)
	-- Call all the collide functions, also call destroy, die, damage and whatever is in custom_collider_code
	if (not _bullets_pack) or (#_bullets_pack == 0) then
		return {}
	end
	-- THIS IS NOT OPTIMIZED; WTF. PLS USE YOUR BRAIN. #######
	local _new_bullet_pack = {}
	for _i, _bullet in ipairs(_bullets_pack) do
		if _bullet.is_custom then
			_bullet.custom_collider(_bullets_pack, _enemies_pack, _towers_pack, _dt)
		else
			local _collide, _here, _obj = collision_raycast(_bullet.position, _bullet.velocity, _enemies_pack)
			if _collide then
				_bullet = bullet_manager:bullet_death(_bullet, _obj, _dt)
			end
		end
		table.insert(_new_bullet_pack, _bullet)
	end
	return _new_bullet_pack
end

function bullet_manager:move_bullets(_bullets_pack, _dt)
	if (not _bullets_pack) or #_bullets_pack == 0 then
		return {}
	end
	local _new_bullet_pacl = {}
	for _i, _bullet in ipairs(_bullets_pack) do
		if _bullet.is_custom then
			_bullet:custmon_movement()
		else
			_bullet.position = sum_table(_bullet.position, _bullet.velocity)
		end
		if _bullet.position[1] > (love.graphics.getPixelWidth() + 100) or _bullet.position[1] < -100 then
			_bullet = bullet_manager:bullet_death(_bullet, _obj, _dt)
		end
		if _bullet.position[2] > (love.graphics.getPixelHeight() + 100) or _bullet.position[2] < -100 then
			_bullet = bullet_manager:bullet_death(_bullet, _obj, _dt)
		end
	end
end
