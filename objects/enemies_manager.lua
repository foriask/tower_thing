enemies_manager = { enemies = {}, enemie_template = {} }
function enemies_manager:set_enemie(_sprite, _pos, _siz, _hp, _colision, _acel)
	local _enemie = {
		type = "enemies",
		collider = _colision or { type = "no" },
		-- colision is a pretty much worthless thing.
		-- Anyways, format:
		-- type = "s", [1] = 50,  [2] = 50 < Square, width 50, height 50
		-- type = "c", radius = 50 < Circle, radius 50
		sprite = _sprite or false,
		size = _siz or 1,
		hitpoints = _hp or 1,
		position = _pos or { 0, 0, 1 },
		matrix_pos = 0,
		acel = _acel or { 0, 0 },
		-- THE LAST DIGIT IN POS (3rd) IS USEFULL. It is used to know what kind of tower can kill it and what path to use.
	}
	function _enemie:damage(_dmg, _dt)
		print("auch" .. _dmg)
	end
	if _enemie.collider.radius then
		_enemie.collider.powradius = math.pow(_enemie.collider.radius, 2)
	end
	_enemie.__index = self.enemie_templante
	table.insert(self.enemies, _enemie)
	return _enemie
end

function enemies_manager.enemie_template:damage(_dmg, _dt)
	self.hitpoints = self.hitpoints - _dmg
	print("auch")
end

function enemies_manager:move(_enemies, _dt)
	local _new_pack = {}
	for _i, _enemie in pairs(_enemies) do
		if _enemie.position[3] == 0 and _enemie ~= "clean" then
			_enemie.position[1] = _enemie.position[1] + (_enemie.acel[1] * _dt * 500)
			_enemie.position[2] = _enemie.position[2] + (_enemie.acel[2] * _dt * 500)
		else
		end
		table.insert(_new_pack, _enemie)
	end
	return _new_pack
end

function enemies_manager:draw(_enemies)
	for _i, _enemie in pairs(_enemies) do
		if not _enemie.sprite then
			if _enemie.collider.type == "c" then
				love.graphics.circle("fill", _enemie.position[1], _enemie.position[2], _enemie.collider.radius)
			else
				love.graphics.rectangle(
					"fill",
					_enemie.position[1],
					_enemie.position[2],
					_enemie.size[1],
					_enemie.size[2]
				)
			end
		else
			love.graphics.draw(_enemie.sprite, _enemie.position[1], _enemie.position[2], _enemie.size)
		end
	end
end
