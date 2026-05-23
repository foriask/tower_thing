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
	if _obj then
		_obj:damage(_bullet.damage)
	end
	_bullet.die(_dt)
	_bullet = "clean"
	return _bullet
end

function bullet_manager:collide(_bullets_pack, _enemies_pack, _towers_pack, _dt)
	-- Call all the collide functions, also call destroy, die, damage and whatever is in custom_collider_code
	if (not _bullets_pack) or (#_bullets_pack == 0) then
		return {} -- IF there is nothing, I want SOMETHING to exists. This could do a makeover for some problems. I don't care
	end
	-- THIS IS NOT OPTIMIZED; WTF. PLS USE YOUR BRAIN. #######
	local _new_bullet_pack = {}
	for _i, _bullet in pairs(_bullets_pack) do
		if _bullet ~= "clean" then -- Do not touch "clean" state. Those will be removed shortly.
			if _bullet.is_custom then -- Custom things go by their custom methods.
				_bullet.custom_collider(_bullets_pack, _enemies_pack, _towers_pack, _dt)
			else
				local _collide, _here, _obj = collision_raycast(_bullet.position, _bullet.velocity, _enemies_pack)
				-- I like how functions work in Lua ngl
				if _collide then
					_bullet = bullet_manager:bullet_death(_bullet, _obj, _dt)
				end
			end
		end
		table.insert(_new_bullet_pack, _bullet)
	end
	return _new_bullet_pack -- YES IT WORKS OH MY GOD
end

function bullet_manager:move_bullets(_bullets_pack, _dt)
	if (not _bullets_pack) or #_bullets_pack == 0 then
		return {} -- The same as before
	end
	local _new_bullet_pack = {}
	for _i, _bullet in pairs(_bullets_pack) do
		if _bullet ~= "clean" then
			if _bullet.is_custom then
				_bullet:custmon_movement() -- custom things
			else
				_bullet.position = sum_table(_bullet.position, _bullet.velocity) -- Yes, it just sums the velocity. Most of them are just constant velocities, why bother doing more?
			end
			if _bullet.position[1] > (love.graphics.getPixelWidth() + 100) or _bullet.position[1] < -100 then
				_bullet = bullet_manager:bullet_death(_bullet, false, _dt)
			else
				if _bullet.position[2] > (love.graphics.getPixelHeight() + 100) or _bullet.position[2] < -100 then
					_bullet = bullet_manager:bullet_death(_bullet, false, _dt)
				end
			end -- Both borders check. One at a time for better performance (I don't know if that works... but it fell it)
		end
		table.insert(_new_bullet_pack, _bullet) -- wiwiwiwiwiwii
	end
	return _new_bullet_pack -- wawawa .3 (:3 - ·)
end
