require("objects.item_manager")
require("usefull.usefull")
bullet_manager = {}
bullet_manager.__index = bullet_manager
function bullet_manager:new(_preset, _sprite, _pos, _vel, _dmg, _cust, _cust_movement, _cust_collider)
	local _table = {}
	if _preset then
		_table = {
			type = "bullets",
			sprite = _preset[1],
			position = _preset[2] or { 0, 0, 0 },
			velocity = _preset[3] or { 0, 0 },
			damage = _preset[4] or 0,
			is_custom = _preset[5] or false,
			custom_seek = _preset[6] or false,
			custom_collier = _preset[7] or false,
			matrix_pos = 0,
		}
	else
		_table = {
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
	end

	-- "modify obj.custom_collider_code() as a function if custom_collider is enables ,3 (;3 - .)")
	function _table:die()
		return "no"
		-- Originally, this function was "print("hewwo")". I liked that
	end
	_table.__index = _table
	return _table
end

function bullet_manager:death(_bullet, _obj, _here, _dt)
	if _obj and _obj.type == "enemy" then
		_obj:damage(_bullet.damage, _here, _dt)
	end
	_bullet.die(_here, _dt)
	return "clean"
end

function bullet_manager:collision_raycast(_obj1, _obj2)
	-- _obj1 -> bullet / simple obj
	-- _obj2 -> enemies / complex obj

	if _obj2.collider.type == "c" then
		-- Dont ask how "powdistance_2d" works. Just trust the process.

		local _distance = powdistance_2d(_obj1.position, _obj2.position)
		if _distance == 0 or _distance <= _obj2.collider.radius then
			print(_distance)
			return true, _obj1.position
		end

		-- I should make that better
	end
	-- Circles are simple. collider.radius iws necesary though. This just checks it the lazy way, point - circle. This is just fine for most of uses. Also scales with the speed/fps ratio to avoid problems.
	if _obj2.collider.type == "s" then
		local _check_point = _obj1.position
		local _horizon_check_1 = ((_check_point[1] < _obj2.collider[3]) and (_check_point[1] > _obj2.collider[1]))
		if not _horizon_check_1 then
			return false
		end
		local _vertical_check_1 = ((_check_point[2] < _obj2.collider[4]) and (_check_point[2] > _obj2.collider[2]))
		if not _vertical_check_1 then
			return
		end
		return true, _check_point
		-- VIVO BIEN...  ME RINDO. LOD pero más difícil¿?
	end
end

function bullet_manager:collide(_bullets, _dt)
	local _new_pack = _bullets
	local _i = 0
	while _i < (tree_manager.base_size * tree_manager.base_size) do
		if not tree_manager.matrix.bullets or not tree_manager.matrix.bullets[_i] then
			goto fuck
		end
		for _e, _bullet_id in ipairs(tree_manager.matrix.bullets[_i]) do
			local _obj = {}
			local _real_point = {}
			local _collision = false
			local _bullet = tree_manager.bullets[_bullet_id]
			if _bullet and _bullet == "clean" then
				goto next_bullet
			end
			local _target = _bullet.target
			if _target then
				for _e, _target in ipairs(_target) do
					if tree_manager.matrix[_target][_i] then
						for _a, _possible in ipairs(tree_manager.matrix[_target][_i]) do
							local _maybe_collision, _point =
								self:collision_raycast(_bullet, tree_manager[_target][_possible])
							_collision = _collision or _maybe_collision
							_obj = _collision and _possible or _obj
							_real_point = _collision and _point or _real_point
						end
					end
				end
			elseif tree_manager.matrix.enemies and tree_manager.matrix.enemies[_i] then
				for _a, _possible in ipairs(tree_manager.matrix.enemies[_i]) do
					local _maybe_collision, _point = self:collision_raycast(_bullet, tree_manager.enemies[_possible])
					_collision = _collision or _maybe_collision
					_obj = _collision and _possible or _obj
					_real_point = _collision and _point or _real_point
				end
			end
			if _collision then
				_new_pack[_bullet_id] =
					bullet_manager:death(_bullet, tree_manager[_target or "enemies"][_obj], _real_point)
			end
			::next_bullet::
		end
		::fuck::
		_i = _i + 1
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
				_bullet = bullet_manager:death(_bullet, false, _dt)
			else
				if _bullet.position[2] > (love.graphics.getPixelHeight() + 100) or _bullet.position[2] < -100 then
					_bullet = bullet_manager:death(_bullet, false, _dt)
				end
			end -- Both borders check. One at a time for better performance (I don't know if that works... but it fell it)
			_new_bullet_pack[_i] = _bullet -- this is faster? lmao
			_i = _i + 1
		end
	end
	return _new_bullet_pack -- wawawa .3 (:3 - ·)
end

function bullet_manager:draw(_time, _bullets)
	if #_bullets == 0 then
		return
	end
	for _i, _obj in ipairs(_bullets) do
		if _obj == "clean" then
			return
		end
		if _obj.sprite then
		else
			love.graphics.circle("fill", _obj.position[1], _obj.position[2], 4)
		end
	end
end
